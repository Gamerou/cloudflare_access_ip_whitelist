#!/bin/bash

# https://github.com/Gamerou/cloudflare_access_ip_whitelist
# Gamerou

# Cloudflare API Details
CF_API_KEY="YOUR_CLOUDFLARE_API_KEY"
CF_API_EMAIL="YOUR_CLOUDFLARE_EMAIL"
CF_ZONE_ID="YOUR_CLOUDFLARE_ZONE_ID"

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

# Get current IPv4 address from ipify.org
log_debug "Fetching current IPv4 address from ipify.org..."
response_ipv4=$(curl -s curl -s https://api.ipify.org?format=json)
log_debug "Response: $response_ipv4"

# Extract the current IPv4 address
current_ipv4=$(echo $response_ipv4 | jq -r '.ip')
log_debug "Current IPv4: $current_ipv4"

# Get current IPv6 address from ipify.org
log_debug "Fetching current IPv4 address from ipify.org..."
response_ipv6=$(curl -s curl -s https://api6.ipify.org?format=json)
log_debug "Response: $response_ipv6"

# Extract the current IPv4 address
current_ipv6=$(echo $response_ipv6 | jq -r '.ip')
log_debug "Current IPv4: $current_ipv4"

# Check if IP addresses have changed
if [ -f "ip_addresses_ddns.txt" ]; then
  previous_ip=$(cat ip_addresses_ddns.txt)
  log_debug "Previous IPv4: $previous_ip"

  if [ "$previous_ip" == "$current_ipv4" ] && [ "$DEBUG" == "false" ]; then
    echo "IPv4 address has not changed. Skipping policy update."
    exit
  fi
fi

# Save current IP addresses to file
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
  response=$(curl -s -X PUT -H "Content-Type: application/json" -H "X-Auth-Email: YOUR_CLOUDFLARE_EMAIL" -H "X-Auth-Key: ${api_token}" --data "${policy_data}" "${api_url}")

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
