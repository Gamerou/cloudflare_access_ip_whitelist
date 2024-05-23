# Tutorial: Updating Cloudflare Access IP Whitelist Using Bash Script

In this tutorial, we'll walk you through the process of updating the IP whitelist for Cloudflare Access using a Bash script. This script will automatically fetch your current IPv4 and IPv6 addresses and update the IP whitelist in Cloudflare Access.

**Prerequisites:**
- A Cloudflare account with Cloudflare Access enabled.
(- Access to HomeAssistant API.)
- A working installation of `jq`, a command-line JSON processor. You can install `jq` using your system's package manager.

**Step 1: Obtain Your Cloudflare API Token**
1. Log in to your Cloudflare account.
2. Go to the "My Profile" section and generate a new API token with the required permissions for managing Access policies.
3. Note down the generated API token.

**Step 2: Set Up the Script**
1. Open a text editor on your system.
2. Copy and paste the script provided below into the text editor.
3. Replace the placeholder values in the script with your Cloudflare API token, account identifier, app UUID, policy UUID, and Discord webhook URL.

**Step 3: Install jq**
1. Open your terminal.
2. Depending on your operating system, use the appropriate package manager to install `jq`:
   - On Ubuntu/Debian: `sudo apt-get install jq`
   - On macOS (using Homebrew): `brew install jq`
   - On CentOS/RHEL: `sudo yum install jq`

**Step 4: Run the Script**
1. Save the script file with a `.sh` extension (e.g., `update_ip_whitelist.sh`).
2. Make the script executable by running the following command in the terminal:
   ```
   chmod +x update_ip_whitelist.sh
   ```
3. Run the script using the following command:
   ```
   ./update_ip_whitelist.sh
   ```

The script will fetch your current IPv4 and IPv6 addresses, update the IP whitelist in Cloudflare Access, and provide you with feedback on the terminal. If the update is successful, it will also send a notification to a Discord channel using the specified webhook URL.

That's it! You've successfully set up a Bash script to automatically update the IP whitelist for Cloudflare Access.

**Step 5: Automate with Cron Job (Optional)**

To automate the IP whitelist update process, you can use the `cron` scheduler on Unix-like systems. Here's how you can set up a cron job to run the script at a specific interval:

1. Open your terminal.
2. Run the following command to edit your user's crontab:
   ```
   crontab -e
   ```
   choose 1.
3. Add a new line to the crontab file to specify the interval and the script's path. For example, to run the script every minute, add the following line:
   ```
   */1 * * * * /bin/bash /path/to/update_ip_whitelist.sh
   ```
   Make sure to replace `/path/to/update_ip_whitelist.sh` with the actual path to your script.

4. Save and exit the editor.

The script will now run automatically every minute, keeping your Cloudflare Access IP whitelist up to date.

**Help?:**
If you have any questions or need assistance with this project, feel free to reach out to GitHub Help at `github-help@schandlserver.de`. **no guarantee**

**Conclusion:**
You've successfully learned how to create a Bash script to update the Cloudflare Access IP whitelist and how to automate this process using `cron`. By combining these steps, you can maintain an up-to-date whitelist of IP addresses for secure access to your Cloudflare-protected applications.

Feel free to explore and modify the script further to suit your specific needs. Don't forget to acknowledge the original creator, Gamerou, if you decide to use or adapt this script for your own purposes.

Happy scripting and securing your applications with Cloudflare Access!
