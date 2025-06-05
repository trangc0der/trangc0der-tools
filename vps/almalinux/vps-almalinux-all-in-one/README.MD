# VPS All-In-One Management Script for AlmaLinux 8.10

This script (`vps-almalinux-all-in-one.sh`) is a comprehensive, menu-driven utility designed to simplify various server administration tasks on an **AlmaLinux 8.10** system. It offers a wide range of functions, from system monitoring and maintenance to user and firewall management, with support for both English and Vietnamese languages.

**Script URL on GitHub:** [vps-almalinux-all-in-one.sh](https://github.com/trangc0der/trangc0der-tools/blob/48f552b922bd32be089aa6422231cf7fbe460aef/vps/almalinux/vps-almalinux-all-in-one/vps-almalinux-all-in-one.sh)

## Target Operating System

* **AlmaLinux 8.10**

## Prerequisites

* An AlmaLinux 8.10 server.
* Root or `sudo` privileges are required to execute the script and perform administrative tasks.

## Language Support

The script will prompt you to choose your preferred language (English or Vietnamese) upon execution. All subsequent menus, prompts, and messages will be displayed in the selected language.

## Features

The script is organized into several categories, accessible via a main menu:

### 1. System Information
* **Display Full System Details:** Shows hostname, OS version, kernel version, system uptime, and CPU load average.
* **Show Disk Usage:** Displays filesystem disk space usage (`df -h`).
* **Show Memory Usage:** Shows RAM and swap usage (`free -h`).

### 2. System Maintenance (Sub-Menu)
* **Update System:** Updates all system packages (`sudo dnf update -y && sudo dnf upgrade -y`).
* **Install a Package:** Prompts for a package name and installs it using `sudo dnf install -y <package>`.
* **Remove a Package:** Prompts for a package name and removes it using `sudo dnf remove -y <package>`.
* **Reboot Server:** Prompts for confirmation and then reboots the server (`sudo reboot`).
* **Shutdown Server:** Prompts for confirmation and then shuts down the server (`sudo shutdown now`).

### 3. Service Management (Sub-Menu)
* **Start a Service:** Prompts for a service name and starts it (`sudo systemctl start <service>`).
* **Stop a Service:** Prompts for a service name and stops it (`sudo systemctl stop <service>`).
* **Restart a Service:** Prompts for a service name and restarts it (`sudo systemctl restart <service>`).
* **Check Service Status:** Prompts for a service name and displays its status (`sudo systemctl status <service>`).
* **Enable a Service:** Prompts for a service name and enables it to start on boot (`sudo systemctl enable <service>`).
* **Disable a Service:** Prompts for a service name and disables it from starting on boot (`sudo systemctl disable <service>`).

### 4. User Management (Sub-Menu)
* **Add a New User:** Prompts for a new username and creates the user. Offers to set the password immediately.
* **Delete a User:** Prompts for a username and deletes the user (with confirmation, including home directory removal).
* **Add User to Sudoers (wheel group):** Prompts for a username and adds them to the `wheel` group, granting sudo privileges.
* **List All Local Users:** Displays a list of local (non-system) users.

### 5. Firewall (firewalld) Management (Sub-Menu)
* **Check Firewall Status:** Displays the running state of firewalld and details of the active/default zone.
* **Add a Service:** Prompts for a service name (e.g., `http`, `ssh`) and adds it permanently to the firewall.
* **Remove a Service:** Prompts for a service name and removes it permanently from the firewall.
* **Add a Port:** Prompts for a port and protocol (e.g., `8080/tcp`) and adds it permanently.
* **Remove a Port:** Prompts for a port and protocol and removes it permanently.
* **Reload Firewall:** Applies pending permanent changes (`sudo firewall-cmd --reload`).
* **List All Rules & Zones:** Provides a detailed listing of firewall configurations for all zones.

### 0. Exit
* Exits the script.

## How to Use

1.  **Download the script to your AlmaLinux 8.10 VPS:**
    ```bash
    curl -o vps-almalinux-all-in-one.sh [https://raw.githubusercontent.com/trangc0der/trangc0der-tools/48f552b922bd32be089aa6422231cf7fbe460aef/vps/almalinux/vps-almalinux-all-in-one/vps-almalinux-all-in-one.sh](https://raw.githubusercontent.com/trangc0der/trangc0der-tools/48f552b922bd32be089aa6422231cf7fbe460aef/vps/almalinux/vps-almalinux-all-in-one/vps-almalinux-all-in-one.sh)
    ```
    Alternatively, if you have cloned the repository:
    ```bash
    git clone [https://github.com/trangc0der/trangc0der-tools.git](https://github.com/trangc0der/trangc0der-tools.git)
    cd trangc0der-tools/vps/almalinux/vps-almalinux-all-in-one/
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x vps-almalinux-all-in-one.sh
    ```

3.  **Run the script with sudo privileges:**
    ```bash
    sudo ./vps-almalinux-all-in-one.sh
    ```

4.  **Language Selection:**
    * Upon execution, the script will first ask you to choose between English and Vietnamese.

5.  **Navigate the Menu:**
    * The script will display a main menu with categories of tasks.
    * Enter the number corresponding to the desired category or action and press `Enter`.
    * Some main menu options will lead to sub-menus with more specific tasks.
    * Follow any on-screen prompts for specific actions (e.g., entering a package name, service name, username, or port number).
    * After an action is completed, you can usually press `Enter` to return to the previous menu or the main menu.

## Important Notes

* **Root/Sudo Privileges:** This script performs administrative tasks and therefore requires root or `sudo` access to function correctly.
* **Confirmations:** Critical operations such as rebooting, shutting down, deleting users, or removing packages will prompt for confirmation before execution. Please read these prompts carefully.
* **Firewall Reload:** When adding or removing services/ports in the firewall, the changes are made to the permanent configuration. You must use the "Reload Firewall" option (or run `sudo firewall-cmd --reload` manually) for these changes to take effect immediately in the active firewall.
* **User Privileges:** When a user is added to the `wheel` group for `sudo` access, they typically need to log out and log back in for the new group membership and associated privileges to apply fully.
* **Interactivity:** The script is interactive and will often wait for user input. Ensure you are available to respond to prompts.

## Disclaimer

* This script is provided "as-is" without any warranties.
* Always review any script from the internet before running it on your system, especially those that perform system-level changes and require root privileges.
* The author or contributors are not responsible for any data loss or system issues that may arise from the use (or misuse) of this script. **Use at your own risk.**
* It is always recommended to have backups of your important data before performing significant system administration tasks.

---

Contributions, bug reports, or suggestions for new features are welcome via GitHub Issues or Pull Requests to the main repository.