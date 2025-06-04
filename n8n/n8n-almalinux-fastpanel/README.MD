# Guide to Installing n8n on AlmaLinux with FastPanel using an Automated Script

This script is designed to automate the installation of n8n (using Docker) on an AlmaLinux server that already has FastPanel installed. The script will perform the following tasks:

- Check for and install Docker & Docker Compose if they are not already present.
- Prompt the user for the necessary information to configure n8n and its PostgreSQL database.
- Create a `docker-compose.yml` file with a standard configuration.
- Launch the n8n and PostgreSQL containers.
- Guide the user through the final steps to complete the installation (configuring a Reverse Proxy in FastPanel).

## Prerequisites

- A server running AlmaLinux OS (or a similar distribution like CentOS, Rocky Linux).
- FastPanel already installed on the server.
- `sudo` or `root` access.
- A domain (or subdomain) with its DNS A record pointed to the server's IP address, which will be used for n8n.

## Installation Steps

### Step 1: Download the Script

Connect to your server via SSH and download the installation script from GitHub using `wget` or `curl`.

```bash
wget https://raw.githubusercontent.com/trangc0der/trangc0der-tools/main/n8n/n8n-almalinux-fastpanel/n8n-almalinux-fastpanel.sh
```

### Step 2: Grant Execute Permissions

After downloading, you need to make the script executable.

```bash
chmod +x n8n-almalinux-fastpanel.sh
```

### Step 3: Run the Script and Provide Information

Execute the script with `sudo` to begin the installation process.

```bash
sudo ./n8n-almalinux-fastpanel.sh
```

The script will prompt you for the following information:

1.  **Domain:** The domain name you have prepared for accessing n8n (e.g., `n8n.yourdomain.com`).
2.  **n8n User:** A username for logging into the n8n web interface.
3.  **n8n Password:** A password for the n8n user (input will be hidden).
4.  **Database Name:** A name for the PostgreSQL database (e.g., `n8n_db`).
5.  **Database User:** A username for the database.
6.  **Database Password:** A password for the database user (input will be hidden).

After you provide all the information, the script will automatically handle the rest of the setup.

### Step 4: Configure the Reverse Proxy in FastPanel

Once the script finishes and the containers are running, you will see a **"BUOC 1 HOAN TAT" (STEP 1 COMPLETE)** message.

At this point, n8n is running and listening on the server's local address `http://127.0.0.1:5555`. The final step is to create a site in FastPanel and configure it as a reverse proxy to point your domain to the n8n application.

1.  **Log in to FastPanel.**
2.  **Create a new site:**
    - Go to "Sites" and click "New Site".
    - Select "Site on server" and enter the domain you provided to the script in Step 3.
    - Complete the site creation process.
3.  **Install SSL:** After creating the site, go to its settings and install a free SSL certificate from Let's Encrypt.
4.  **Configure Proxy:**
    - In the site's settings, find the **Proxy** section.
    - Enable the Proxy feature.
    - In the **Proxy URL** field, enter the address where n8n is listening:
      ```
      http://127.0.0.1:5555
      ```
    - Save the configuration.

### Step 5: Finish

You can now access your n8n instance by navigating to your domain (`https://n8n.yourdomain.com`). Log in with the n8n username and password you created in Step 3.

## Management and Troubleshooting

- **Working Directory:** All configuration files (`docker-compose.yml`) and data volumes (`n8n_local_data`, `postgres_data`) are stored in the `~/n8n_data` directory.
- **Check n8n logs:** If you encounter any issues, you can view the n8n container logs with the following command:
  ```bash
  sudo docker logs n8n
  ```
- **Restart the service:**
  ```bash
  cd ~/n8n_data
  sudo docker compose up -d
  ```
- **Stop the service:**
  ```bash
  cd ~/n8n_data
  sudo docker compose down
  ```
