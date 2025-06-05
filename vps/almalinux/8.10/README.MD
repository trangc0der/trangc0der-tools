# AlmaLinux 8.10 Initial VPS Setup Script (LEMP Stack)

This is a shell script (`.sh`) designed to automate the initial setup process for a Virtual Private Server (VPS) running AlmaLinux 8.10. This script installs a LEMP stack (Linux, Nginx, MariaDB, PHP) along with basic utilities and minimal security configurations.

**Script URL on GitHub:** [trangc0der-tools/vps/almalinux/8.10/install-new-vps.sh](https://github.com/trangc0der/trangc0der-tools/blob/e88860b9cd25fbd7ce75e3d249867421efb6d029/vps/almalinux/8.10/install-new-vps.sh)

## Target Operating System

- **AlmaLinux 8.10**

## Features / Installed Packages

The script will perform the following tasks:

1.  **System Update:** Updates all packages to their latest versions.
2.  **Install EPEL Repository:** Adds the EPEL (Extra Packages for Enterprise Linux) repository for additional software packages.
3.  **Install Basic Utilities:**
    - `wget`, `curl` (file downloaders)
    - `git` (version control system)
    - `zip`, `unzip` (archiving tools)
    - `htop` (interactive process viewer)
    - `vim`, `nano` (text editors)
    - `net-tools` (network utilities like `netstat`)
    - `bind-utils` (DNS tools like `dig`, `nslookup`)
    - `policycoreutils-python-utils`, `setools` (SELinux management tools)
4.  **Install Nginx:** High-performance web server.
    - Starts and enables Nginx service.
5.  **Install MariaDB:** Database server (MySQL replacement).
    - Starts and enables MariaDB service.
6.  **Install PHP:** Server-side scripting language.
    - Uses `dnf module` to install a PHP version (defaults to **PHP 8.1** in the script, customizable).
    - Installs `php-fpm` and common PHP extensions (`php-cli`, `php-mysqlnd`, `php-gd`, `php-xml`, `php-mbstring`, `php-json`, `php-opcache`, `php-zip`, `php-curl`, `php-intl`, `php-bcmath`).
7.  **Configure PHP-FPM:**
    - Adjusts `user` and `group` in `www.conf` to work with Nginx.
    - Starts and enables `php-fpm` service.
8.  **Configure Nginx for PHP:**
    - Backs up the current default Nginx configuration file (if it exists).
    - Creates/overwrites a new Nginx default configuration file (`/etc/nginx/conf.d/default.conf`) with support for processing PHP files via `php-fpm`.
    - Tests Nginx syntax and restarts the service.
9.  **Configure Firewalld:**
    - Installs, starts, and enables Firewalld.
    - Opens ports for `ssh`, `http`, and `https`.
10. **Install Fail2ban:**
    - Enhances security by banning IPs that show malicious signs (e.g., SSH brute-force attempts).
    - Creates a `jail.local` configuration file and enables protection for `sshd`.

## How to Use

1.  **Download the script to your VPS:**
    You can download it directly from GitHub:

    ```bash
    curl -o install-new-vps.sh [https://raw.githubusercontent.com/trangc0der/trangc0der-tools/e88860b9cd25fbd7ce75e3d249867421efb6d029/vps/almalinux/8.10/install-new-vps.sh](https://raw.githubusercontent.com/trangc0der/trangc0der-tools/e88860b9cd25fbd7ce75e3d249867421efb6d029/vps/almalinux/8.10/install-new-vps.sh)
    ```

    Or, if you have cloned the repository:

    ```bash
    git clone [https://github.com/trangc0der/trangc0der-tools.git](https://github.com/trangc0der/trangc0der-tools.git)
    cd trangc0der-tools/vps/almalinux/8.10/
    ```

2.  **Make the script executable:**

    ```bash
    chmod +x install-new-vps.sh
    ```

3.  **Run the script:**
    It's recommended to run it with `sudo` to ensure all commands are executed successfully:
    ```bash
    sudo ./install-new-vps.sh
    ```
    The script will display the steps it is performing.

## Important Post-Installation Steps

After the script finishes, perform the following crucial steps:

1.  **Secure MariaDB Installation:**

    ```bash
    sudo mysql_secure_installation
    ```

    Follow the prompts to set a `root` password for MariaDB, remove anonymous users, disallow remote root login, and remove the test database.

2.  **Deploy Your Web Application:**
    Upload your website's source code to the Nginx root directory (default is `/usr/share/nginx/html` as configured in the script).

3.  **Configure Domain Name (if applicable):**
    If you are using a custom domain name, update the `server_name` directive in the Nginx configuration file (`/etc/nginx/conf.d/default.conf`) from `_` to your domain name (e.g., `yourdomain.com www.yourdomain.com`). Then, point your domain's DNS records to your VPS's IP address.

4.  **Test PHP:**
    Create a file named `info.php` in the `/usr/share/nginx/html` directory with the following content:

    ```php
    <?php
    phpinfo();
    ?>
    ```

    Then, access `http://<YOUR_VPS_IP>/info.php` from your web browser to see PHP configuration details. **Remember to delete this file after testing for security reasons.**

5.  **Customize Fail2ban:**
    Review and further customize settings in `/etc/fail2ban/jail.local` to suit your needs (e.g., ban time, max retries for other services).

6.  **Consider SSL/TLS:**
    To secure your website, you should install an SSL/TLS certificate (e.g., using Let's Encrypt).

## Customization

### PHP Version

You can change the PHP version installed by modifying the `PHP_MODULE_STREAM` variable at the beginning of the `install-new-vps.sh` script.
For example, to install PHP 8.0:

```bash
PHP_MODULE_STREAM="php:8.0"
```
