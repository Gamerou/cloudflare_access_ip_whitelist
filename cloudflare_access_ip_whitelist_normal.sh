#!/bin/bash

# https://github.com/Gamerou/cloudflare_access_ip_whitelist
# Gamerou

# Cloudflare API-Token
api_token="YOUR_CLOUDFLARE_API_TOKEN"

# Discord Webhook URL
discord_webhook_url="YOUR_DISCORD_WEBHOOK_URL"

# Policy details
account_identifier="YOUR_CLOUDFLARE_ACCOUNT_IDENTIFIER"

# Policy details for each application
declare -A app_policies
app_policies=(
  ["APPLICATION_UUID_1"]="POLICY_UUID_1"
  ["APPLICATION_UUID_2"]="POLICY_UUID_2"
  # Add more application policies as needed
)

# Function to get current IPv4 and IPv6 addresses
get_current_ip_addresses() {
  current_ipv4=$(curl -s https://api64.ipify.org?format=text)
  current_ipv6=$(curl -s https://api64.ipify.org?format=text)
}

# Check if IP addresses have changed
get_current_ip_addresses
if [ -f "ip_addresses.txt" ]; then
  previous_ips=$(cat ip_addresses.txt)
  current_ips="${current_ipv4}:${current_ipv6}"

  if [ "$previous_ips" == "$current_ips" ]; then
    echo "IP addresses have not changed. Skipping policy update."
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
