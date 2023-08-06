Cloudflare Access IP Whitelisting Automation

In this project, we aim to automate the process of updating IP whitelisting rules in Cloudflare Access policies using a script. Cloudflare Access provides a zero-trust security model that ensures secure access to applications, allowing only authorized IP addresses. This automation script leverages Cloudflare's API to seamlessly update IP whitelisting rules whenever the IP address of the server changes. The script also integrates with Discord to provide real-time notifications about policy updates.

Project Components:

Cloudflare API Integration: The script uses the Cloudflare API to interact with Access policies. It updates IP whitelisting rules based on the current IP address of the server.

Home Assistant Integration (Alternative avaliable!): For users of Home Assistant, the script fetches the current IPv4 and IPv6 addresses from Home Assistant sensors. This information is then used to update the Cloudflare Access policy.

Discord Integration: The script sends notifications to a Discord channel, informing users about successful or failed policy updates. This ensures that administrators are promptly informed about any changes.

Alternative API Integration: In cases where Home Assistant is not used, the script provides an alternative method to fetch the server's IP addresses from other APIs, such as ifconfig.me for IPv4 and ifconfig.co for IPv6.

How to Use:

Obtain a Cloudflare API token and set up a Discord webhook.
Configure the script by replacing placeholders with actual values.
Execute the script to automatically update Cloudflare Access policies based on the server's IP addresses.
Receive real-time notifications on your Discord channel about policy updates.
Alternative API Option:

For users who do not use Home Assistant, the second script provides the flexibility to retrieve server IP addresses from other APIs. This alternative approach ensures that users can still automate IP whitelisting in Cloudflare Access without relying on a specific platform.

This project enhances security and streamlines the process of managing IP whitelisting rules in Cloudflare Access, offering a seamless solution for administrators who want to ensure secure access to their applications.

Note: It is recommended to review and test the script thoroughly before deploying it in a production environment to ensure its accuracy and reliability.

Usage and Attribution:

Feel free to utilize the project and its included scripts to enhance your IP whitelisting automation with Cloudflare Access. The provided scripts offer a convenient way to streamline your access management and ensure the security of your applications.

If you decide to share, modify, or redistribute the project, we kindly request that you provide proper attribution. When using or referencing this project in your own work, please include a backlink to the original creator. This helps acknowledge the effort and time invested in creating and sharing this solution.

Remember that this project is provided as-is, and while efforts have been made to ensure accuracy and reliability, it's essential to review and test the scripts before deploying them in your environment.

Thank you for considering this attribution, and we hope this project proves valuable in your IP whitelisting automation efforts.
