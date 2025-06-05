# Docker All-In-One Management Script for AlmaLinux 8.10

This script (`docker-all-in-one.sh`) provides a convenient menu-driven interface to manage various Docker operations on an AlmaLinux 8.10 system. It simplifies common tasks from installation to daily management and maintenance.

**Script URL on GitHub:** [docker-all-in-one.sh](https://github.com/trangc0der/trangc0der-tools/blob/9037bebd50b7b61327daf88ec194b496839aaf98/docker/docker-all-in-one/docker-all-in-one.sh)

## Target Operating System

* **AlmaLinux 8.10**

## Prerequisites

* An AlmaLinux 8.10 server.
* Root or `sudo` privileges to execute the script and perform Docker operations.

## Features (Menu Options)

The script offers a comprehensive menu with the following functionalities:

1.  **Install Docker Engine:** Installs Docker CE, CLI, Containerd, Buildx plugin, and Compose plugin. Also handles removal of older versions and sets up the Docker repository.
2.  **Uninstall Docker Engine:** Completely removes Docker packages, and optionally its data directories (`/var/lib/docker`, `/var/lib/containerd`).
3.  **Start Docker Service:** Starts the Docker systemd service.
4.  **Stop Docker Service:** Stops the Docker systemd service.
5.  **Restart Docker Service:** Restarts the Docker systemd service.
6.  **Check Docker Service Status:** Displays the current status of the Docker service.
7.  **List Docker Images:** Shows all Docker images available locally.
8.  **List Docker Containers (All):** Lists all Docker containers, including stopped ones.
9.  **Remove a Specific Docker Image:** Prompts for an Image ID or Name to remove it.
10. **Remove a Specific Docker Container:** Prompts for a Container ID or Name to remove it.
11. **View Logs of a Container:** Prompts for a Container ID or Name and streams its logs (`docker logs -f`).
12. **Pull an Image from Docker Hub:** Prompts for an image name (and optional tag) to pull from Docker Hub.
13. **Prune Docker System:** Removes all unused Docker objects:
    * Stopped containers
    * Unused networks
    * Dangling images (and optionally all unused images if `-a` is used in implementation)
    * Build cache
    * Optionally unused volumes (if ` --volumes` flag is used in the prune command within the script)
14. **Add Current User to 'docker' Group:** Adds the user who invoked `sudo` (or the current user if run directly as root) to the `docker` group. This allows running Docker commands without `sudo` after logging out and back in.
0.  **Exit:** Exits the script.

## How to Use

1.  **Download the script to your AlmaLinux 8.10 VPS:**
    ```bash
    curl -o docker-all-in-one.sh [https://raw.githubusercontent.com/trangc0der/trangc0der-tools/9037bebd50b7b61327daf88ec194b496839aaf98/docker/docker-all-in-one/docker-all-in-one.sh](https://raw.githubusercontent.com/trangc0der/trangc0der-tools/9037bebd50b7b61327daf88ec194b496839aaf98/docker/docker-all-in-one/docker-all-in-one.sh)
    ```
    Alternatively, if you have cloned the repository:
    ```bash
    git clone [https://github.com/trangc0der/trangc0der-tools.git](https://github.com/trangc0der/trangc0der-tools.git)
    cd trangc0der-tools/docker/docker-all-in-one/
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x docker-all-in-one.sh
    ```

3.  **Run the script with sudo privileges:**
    ```bash
    sudo ./docker-all-in-one.sh
    ```

4.  **Navigate the Menu:**
    * The script will display a menu of available options.
    * Enter the number corresponding to the action you want to perform and press `Enter`.
    * Follow any on-screen prompts for specific actions (e.g., entering an Image ID).
    * After an action is completed, you can press `Enter` to return to the main menu.

## Important Notes

* **Running Docker without `sudo`:** After using option `14. Add Current User to 'docker' Group`, you **must log out and log back in** for the group changes to take effect. Alternatively, you can run `newgrp docker` in your current terminal session.
* **Data Loss Warning:** Operations like "Uninstall Docker Engine" (option 2) and "Prune Docker System" (option 13) can lead to data loss (images, containers, volumes). The script will ask for confirmation before performing these destructive actions. Please be cautious.
* **Interactivity:** Some options will prompt you for input (e.g., Image ID, Container Name). Ensure you provide the correct information.

## Disclaimer

* This script is provided as-is. Always review scripts from the internet before running them on your system, especially those requiring root privileges.
* While this script aims to simplify Docker management, understanding the underlying Docker commands is still beneficial.
* The author or contributors are not responsible for any data loss or system issues that may arise from using this script. Use at your own risk.

---

Contributions, bug reports, or suggestions for new features are welcome via GitHub Issues or Pull Requests to the main repository.