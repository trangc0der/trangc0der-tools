# FastPanel Installation Helper for AlmaLinux 8.10

This shell script (`fastpanel-almalinux-8.10.sh`) is designed to facilitate the installation of FastPanel on a VPS running **AlmaLinux 8.10**. It automates several pre-installation steps and then launches the official FastPanel installer.

**Script URL on GitHub:** [fastpanel-almalinux-8.10.sh](https://github.com/trangc0der/trangc0der-tools/blob/2acb11b8377ffc7feaee2a018fc1c8270abfffbb/vps/panel/fastpanel/fastpanel-almalinux-8.10.sh)

## Target Operating System

- **AlmaLinux 8.10**

It is highly recommended to run this script on a fresh/clean installation of AlmaLinux 8.10 to prevent potential conflicts.

## Script Features

This script performs the following actions _before_ launching the official FastPanel installer:

1.  **Root/Sudo Check:** Verifies if the script is being run with root or sudo privileges.
2.  **User Confirmation:** Asks for user confirmation before proceeding with any changes.
3.  **System Update:** Updates and upgrades all system packages on AlmaLinux 8.10 using `sudo dnf update -y && sudo dnf upgrade -y`.
4.  **Install `wget`:** Checks if `wget` is installed. If not, it installs `wget` using `sudo dnf install -y wget`.
5.  **Launch Official Installer:** Downloads and executes the official FastPanel installation script from `http://installer.fastpanel.direct/install.sh`.

The core installation of FastPanel itself is handled by the official script provided by FastPanel.

## How to Use

1.  **Download the script to your AlmaLinux 8.10 VPS:**
    You can download it directly from GitHub:

    ```bash
    curl -o fastpanel-almalinux-8.10.sh [https://raw.githubusercontent.com/trangc0der/trangc0der-tools/2acb11b8377ffc7feaee2a018fc1c8270abfffbb/vps/panel/fastpanel/fastpanel-almalinux-8.10.sh](https://raw.githubusercontent.com/trangc0der/trangc0der-tools/2acb11b8377ffc7feaee2a018fc1c8270abfffbb/vps/panel/fastpanel/fastpanel-almalinux-8.10.sh)
    ```

    Or, if you have cloned the repository:

    ```bash
    git clone [https://github.com/trangc0der/trangc0der-tools.git](https://github.com/trangc0der/trangc0der-tools.git)
    cd trangc0der-tools/vps/panel/fastpanel/
    ```

2.  **Make the script executable:**

    ```bash
    chmod +x fastpanel-almalinux-8.10.sh
    ```

3.  **Run the script with sudo privileges:**
    ```bash
    sudo ./fastpanel-almalinux-8.10.sh
    ```

## What to Expect During FastPanel Installation

- After the initial preparations, this script will execute FastPanel's official installer.
- The FastPanel installer is interactive. You will need to follow the on-screen prompts, which may include providing an email address for registration and receiving login credentials.
- The installation process might take some time, depending on your VPS resources and internet connection.

## After FastPanel Installation

- Once the FastPanel installation is complete, you will typically receive your login URL, username, and password either on-screen or via the email address you provided during the setup.
- Access the provided URL in your web browser to log in to your FastPanel dashboard.
- For further guidance on using FastPanel, please refer to the [official FastPanel documentation](https://fastpanel.direct/wiki/en).

## Disclaimer

- This script is intended to simplify the initial steps for installing FastPanel on AlmaLinux 8.10. The actual FastPanel installation is performed by their official script.
- Always review any script from the internet before running it on your server.
- It is recommended to use this script on a fresh OS installation. The author or contributor is not responsible for any issues that may arise.

---

Feel free to report issues or suggest improvements via GitHub.
