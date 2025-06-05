# WordPress All-In-One Toolkit for AlmaLinux 8.10

This script (`wordpress-all-in-one.sh`) is a powerful, menu-driven utility designed to automate and simplify the installation, management, and maintenance of WordPress sites on an **AlmaLinux 8.10** server. It includes features for setting up the necessary LEMP stack, managing WP-CLI, handling backups, SSL certificates, and more, with support for both English and Vietnamese languages.

**Script URL on GitHub:** [wordpress-all-in-one.sh](https://github.com/trangc0der/trangc0der-tools/blob/4ba879c202e30c5fc7304213fc0c2a24958729a8/vps/wordpress/wordpress-all-in-one/wordpress-all-in-one.sh)

## Target Operating System

- **AlmaLinux 8.10**

## Prerequisites

- An AlmaLinux 8.10 server (preferably a fresh installation for LEMP setup).
- Root or `sudo` privileges are required to execute the script and perform administrative tasks.
- A stable internet connection for downloading packages, WordPress core, WP-CLI, and SSL certificates.

## Language Support

Upon execution, the script will prompt you to choose your preferred language (English or Vietnamese). All subsequent menus, prompts, and messages will be displayed in the selected language.

## Core Features

The script offers a wide array of functionalities organized into a main menu:

### 1. Setup LEMP Stack

- Installs **Nginx** web server.
- Installs **MariaDB** database server.
  - Provides a reminder to run `sudo mysql_secure_installation` post-setup.
- Installs **PHP** (allows selection of version, e.g., 8.1, 8.2) along with `php-fpm` and essential extensions for WordPress (`php-mysqlnd`, `php-gd`, `php-xml`, `php-mbstring`, `php-curl`, `php-zip`, `php-imagick`, etc.).
- Configures PHP-FPM to work with Nginx.
- Opens HTTP and HTTPS ports in the firewall.

### 2. Manage WP-CLI (WordPress Command Line Interface)

- **Install/Update WP-CLI:** Downloads the latest stable version of WP-CLI to `/usr/local/bin/wp`.
- **Check WP-CLI Version:** Displays the currently installed WP-CLI version and information.
- **Uninstall WP-CLI:** Removes WP-CLI from the system.

### 3. Install New WordPress Site

- Prompts for domain name, web root path, and database details.
- Automatically generates a strong database password if not provided.
- Creates a dedicated MariaDB database and user for the new site.
- Downloads the latest version of WordPress core.
- Generates `wp-config.php` with database credentials and unique security keys (salts).
- Sets appropriate file and directory permissions for WordPress, owned by the web server user (e.g., `nginx`).
- Creates and configures an Nginx server block for the specified domain, including permalink rewrite rules.
- Provides guidance on pointing DNS and completing the WordPress installation via the browser.

### 4. Backup WordPress Site

- Prompts for the WordPress site's web root path and a backup storage directory.
- Automatically extracts database credentials from `wp-config.php`.
- Creates a full backup including:
  - **Database:** A compressed SQL dump (`.sql.gz`) using `mysqldump`.
  - **Files:** A compressed archive (`.tar.gz`) of the entire WordPress web root directory.
- Stores backups in the specified directory with a timestamp.

### 5. Restore WordPress Site

- Prompts for the WordPress site's web root path, the path to the files backup (`.tar.gz`), and the path to the database backup (`.sql` or `.sql.gz`).
- **Caution:** This operation will overwrite existing files and database content for the specified site path. Confirmation is required.
- Restores files and imports the database.
- Resets file and directory permissions.

### 6. Update WordPress (via WP-CLI)

- Prompts for the WordPress site path.
- Provides a sub-menu to:
  - Update WordPress Core.
  - Update All Active Plugins.
  - Update All Active Themes.

### 7. Manage Maintenance Mode (via WP-CLI)

- Prompts for the WordPress site path.
- Allows enabling or disabling WordPress maintenance mode using WP-CLI.

### 8. Run Custom WP-CLI Command

- Prompts for the WordPress site path and a custom WP-CLI command.
- Executes the command as the web server user (e.g., `nginx`) within the context of the specified site.

### 9. Setup SSL with Let's Encrypt (Certbot)

- Checks for and offers to install Certbot and the `python3-certbot-nginx` plugin.
- Prompts for the domain name (which must be live and pointed to the server's IP) and an email address for registration.
- Requests and installs an SSL certificate from Let's Encrypt using Certbot, automatically configuring the Nginx server block for HTTPS and redirection.

### 10. Delete WordPress Site (USE WITH EXTREME CAUTION!)

- Prompts for the WordPress site's web root path.
- **Requires multiple, explicit confirmations due to its destructive nature.**
- Permanently deletes:
  - All WordPress files and directories for the site.
  - The Nginx server block configuration file for the site.
  - The associated MariaDB database.
  - The associated MariaDB user.
- **There is NO UNDO for this operation.**

### 0. Exit

- Exits the script.

## How to Use

1.  **Download the script to your AlmaLinux 8.10 VPS:**

    ```bash
    curl -o wordpress-all-in-one.sh [https://raw.githubusercontent.com/trangc0der/trangc0der-tools/4ba879c202e30c5fc7304213fc0c2a24958729a8/vps/wordpress/wordpress-all-in-one/wordpress-all-in-one.sh](https://raw.githubusercontent.com/trangc0der/trangc0der-tools/4ba879c202e30c5fc7304213fc0c2a24958729a8/vps/wordpress/wordpress-all-in-one/wordpress-all-in-one.sh)
    ```

    Alternatively, if you have cloned the repository:

    ```bash
    git clone [https://github.com/trangc0der/trangc0der-tools.git](https://github.com/trangc0der/trangc0der-tools.git)
    # Navigate to the script's directory:
    cd trangc0der-tools/vps/wordpress/wordpress-all-in-one/
    ```

2.  **Make the script executable:**

    ```bash
    chmod +x wordpress-all-in-one.sh
    ```

3.  **Run the script with sudo privileges:**

    ```bash
    sudo ./wordpress-all-in-one.sh
    ```

4.  **Language Selection:**

    - Upon execution, the script will first ask you to choose between English and Vietnamese.

5.  **Navigate the Menu:**
    - The script will display a main menu with various options.
    - Enter the number corresponding to the desired action and press `Enter`.
    - Follow any on-screen prompts. Some options may lead to sub-menus.
    - After an action is completed, you can usually press `Enter` to return to the previous menu.

## Important Notes & Considerations

- **`mysql_secure_installation`:** After setting up the LEMP stack (Option 1), it is highly recommended to run `sudo mysql_secure_installation` to secure your MariaDB server (set root password, remove anonymous users, etc.).
- **DNS Configuration:** For new WordPress sites and SSL setup, ensure your domain name's DNS A record is correctly pointed to your server's IP address. DNS propagation can take time.
- **WP-CLI Execution:** WP-CLI commands executed by this script are typically run as the web server user (defined as `nginx` in the script) to maintain correct file ownership and permissions.
- **Backup Storage:** When using the backup feature, ensure the chosen backup directory is secure and has sufficient disk space. Consider transferring backups off-server regularly.
- **Data Integrity:** Destructive operations like "Delete WordPress Site" and "Restore WordPress Site" require careful confirmation. **Always have reliable backups before performing such actions.**
- **SSL with Certbot:** For Certbot to successfully issue an SSL certificate, your domain must be publicly accessible and correctly resolved to your server's IP.
- **Firewall:** The LEMP stack installation attempts to open HTTP/HTTPS ports. If you have a custom firewall setup, you might need to adjust it manually.

## Disclaimer

- This script is provided "as-is" without any warranties.
- Always review scripts from the internet before running them on your system, especially those that perform system-level changes and require root privileges.
- The author or contributors are not responsible for any data loss or system issues that may arise from the use (or misuse) of this script. **Use at your own risk.**
- It is strongly recommended to test this script in a non-production environment first.
- **Regularly back up all your important data.**

---

Contributions, bug reports, or suggestions for new features are welcome via GitHub Issues or Pull Requests to the main repository.
