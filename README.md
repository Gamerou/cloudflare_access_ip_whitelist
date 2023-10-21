**Project Description:**

The goal of this project is to create an automated solution for updating IP whitelisting rules within Cloudflare Access policies using a specially designed script. Cloudflare Access is a security framework that enforces strict access control to applications by permitting only authorized IP addresses. This project streamlines the process of updating these access rules by employing the Cloudflare API to dynamically adjust IP whitelists based on server IP changes. Additionally, the script integrates with Discord to provide instant notifications for policy updates.

**Project Components:**

1. **Cloudflare API Integration:** The script is tightly integrated with Cloudflare's API, allowing it to efficiently manage and update IP whitelisting rules according to the server's current IP address.

2. **Home Assistant Integration (Optional):** For users of Home Assistant, the script can seamlessly retrieve the current IPv4 and IPv6 addresses from Home Assistant sensors. This information is then utilized to update the relevant Cloudflare Access policy.

3. **Discord Integration (Optional) :** Real-time communication is established through Discord, enabling the script to send notifications to a designated channel. These notifications promptly alert administrators about the success or failure of policy updates.

4. **Alternative API Option:** In scenarios where Home Assistant is not employed, the script accommodates the use of alternative APIs to obtain server IP addresses. This provides users with flexibility, ensuring that IP whitelisting updates can still be achieved, irrespective of the platform.

**Usage Instructions:**

1. Obtain a Cloudflare API token and configure a Discord webhook.
2. Personalize the script by replacing placeholders with actual credentials and values.
3. Execute the script, which will autonomously update Cloudflare Access policies based on the server's IP addresses.
4. Stay informed about policy updates through real-time Discord notifications.

**Alternative API Choice:**

For users who do not utilize Home Assistant, the script offers an adaptable approach by allowing the retrieval of server IP addresses from other APIs. This alternative method ensures that administrators can efficiently automate IP whitelisting within Cloudflare Access, even without relying on a specific platform.

**Get Started:**
To get started, download the latest release from the "Releases" tab in the project repository. Follow the step-by-step instructions in the tutorial to configure and utilize the Cloudflare Access Policy Updater effectively. Enhance your Cloudflare security by ensuring that your Access Policies are always up to date with the latest IP addresses from your network.

**Note:** It is highly recommended to thoroughly review and test the script before implementing it in a production environment. This precaution ensures the script's accuracy and reliability when managing IP whitelisting in Cloudflare Access policies.
