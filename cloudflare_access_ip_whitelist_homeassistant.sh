#!/bin/bash

# https://github.com/Gamerou/cloudflare_access_ip_whitelist
# by Gamerou

# Cloudflare API Details
CF_API_KEY="YOUR_CLOUDFLARE_API_KEY"
CF_API_EMAIL="YOUR_CLOUDFLARE_EMAIL"
CF_ZONE_ID="YOUR_CLOUDFLARE_ZONE_ID"

# HomeAssistant API Details
HA_BASE_URL="YOUR_HOMEASSISTANT_URL"
HA_TOKEN="YOUR_HOMEASSISTANT_TOKEN"
HA_SENSOR_IPV4="YOUR_HOMEASSISTANT_SENSOR"
HA_SENSOR_IPV6="YOUR_HOMEASSISTANT_SENSOR"

# Discord Webhook URL
discord_webhook_url="YOUR_DISCORD_WEBHOOK_URL"

# Debug mode
DEBUG=false

# Policy details for each application
declare -A app_policies
app_policies=(
  ["APPLICATION_UUID_1"]="POLICY_UUID_1"
  ["APPLICATION_UUID_2"]="POLICY_UUID_2"
  # Add more application policies as needed
)

# Function to log debug messages
log_debug() {
    if [ "$DEBUG" = true ]; then
        echo "DEBUG: $1"
    fi
}

# Get current IPv4 address from HomeAssistant
log_debug "Fetching current IPv4 address from HomeAssistant..."
response_ipv4=$(curl -s -X GET "$HA_BASE_URL/api/states/$HA_SENSOR_IPV4" -H "Authorization: Bearer $HA_TOKEN")
log_debug "Response: $response_ipv4"

# Extract the current IPv4 address
current_ipv4=$(echo $response_ipv4 | jq -r '.state')
log_debug "Current IPv4: $current_ipv4"

# Get current IPv6 address from HomeAssistant
log_debug "Fetching current IPv6 address from HomeAssistant..."
response_ipv6=$(curl -s -X GET "$HA_BASE_URL/api/states/$HA_SENSOR_IPV6" -H "Authorization: Bearer $HA_TOKEN")
log_debug "Response: $response_ipv4"

# Extract the current IPv6 address
current_ipv6=$(echo $response_ipv6 | jq -r '.state')
log_debug "Current IPv6: $current_ipv6"

# Check if IP addresses have changed
if [ -f "ip_addresses.txt" ]; then
  previous_ips=$(cat ip_addresses.txt)
  current_ips="${current_ipv4}:${current_ipv6}"

  if [ "$previous_ips" == "$current_ips" ] && [ "$DEBUG" == "false" ]; then
    echo "IP addresses have not changed. Skipping policy update."
    exit
  fi
fi

echo "${current_ipv4}:${current_ipv6}" > ip_addresses.txt

# Loop through each application and update IP whitelist
for app_uuid in "${!app_policies[@]}"; do
  policy_uuid="${app_policies[$app_uuid]}"
  api_url="https://api.cloudflare.com/client/v4/accounts/${account_identifier}/access/apps/${app_uuid}/policies/${policy_uuid}"

  # Policy data to update with current IP addresses
  policy_data='{
    "name": "IP",
    "decision": "bypass",
    "include": [
      {
        "ip": {
          "ip": "'"${current_ipv4}"'"
        }
      },
      {
        "ip": {
          "ip": "'"${current_ipv6}"'"
        }
      }
    ],
    "exclude": [],
    "require": []
  }'

  # Send the PUT request to update the policy
  response=$(curl -s -X PUT -H "Content-Type: application/json" -H "X-Auth-Email: $CF_API_EMAIL" -H "X-Auth-Key: $CF_API_KEY" --data "${policy_data}" "${api_url}")
  log_debug "Response: $response"

  # Check if policy update was successful
  if [ "$(echo "${response}" | jq -r '.success')" = "true" ]; then
    echo "Successfully updated Access Policy: ${policy_uuid}"
    # Send success message to Discord
    discord_message="Successfully updated Cloudflare Access Policy with IPv4: ${current_ipv4} and IPv6: ${current_ipv6}"
    curl -H "Content-Type: application/json" -d "{\"content\": \"$discord_message\"}" "${discord_webhook_url}"
  else
    echo "Error updating Access Policy: ${response}"
    # Send error message to Discord
    discord_message="Error updating Cloudflare Access Policy. Response: ${response}"
    curl -H "Content-Type: application/json" -d "{\"content\": \"$discord_message\"}" "${discord_webhook_url}"
  fi
done
