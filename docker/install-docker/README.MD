# Docker Engine Installation Script for AlmaLinux 8.10

This shell script (`install-docker.sh`) automates the installation of Docker Engine, Docker CLI, Containerd, Docker Buildx plugin, and Docker Compose plugin on **AlmaLinux 8.10**. It follows the official Docker installation guidelines.

**Script URL on GitHub:** [install-docker.sh](https://github.com/trangc0der/trangc0der-tools/blob/b4aaaef3516e7fda1bfb7a71eac7340b228c7b1d/docker/install-docker/install-docker.sh)

## Target Operating System

- **AlmaLinux 8.10**

## Script Features

This script performs the following actions:

1.  **Root Privilege Check:** Ensures the script is executed with root or `sudo` privileges.
2.  **Uninstall Old Versions:** Attempts to remove any older Docker packages and potentially conflicting packages like `podman` and `runc` to ensure a clean installation.
3.  **Install Dependencies:** Installs necessary packages such as `dnf-utils`, `device-mapper-persistent-data`, and `lvm2`.
4.  **Set Up Docker Repository:** Adds the official Docker CE stable repository for AlmaLinux (via CentOS repository).
5.  **Install Docker Engine:** Installs the latest stable versions of:
    - `docker-ce` (Docker Engine)
    - `docker-ce-cli` (Docker Command Line Interface)
    - `containerd.io` (Container runtime)
    - `docker-buildx-plugin` (For Buildx, an advanced image builder)
    - `docker-compose-plugin` (For Docker Compose V2, e.g., `docker compose up`)
6.  **Start and Enable Docker Service:** Starts the Docker service and enables it to start automatically on system boot.
7.  **Verification Information:** Provides commands to verify the installation.
8.  **Post-installation Guidance:** Instructs on how to allow non-root users to run Docker commands.

## How to Use

1.  **Download the script to your AlmaLinux 8.10 VPS:**
    You can download it directly from GitHub:

    ```bash
    curl -o install-docker.sh [https://raw.githubusercontent.com/trangc0der/trangc0der-tools/b4aaaef3516e7fda1bfb7a71eac7340b228c7b1d/docker/install-docker/install-docker.sh](https://raw.githubusercontent.com/trangc0der/trangc0der-tools/b4aaaef3516e7fda1bfb7a71eac7340b228c7b1d/docker/install-docker/install-docker.sh)
    ```

    Alternatively, if you have cloned the repository:

    ```bash
    git clone [https://github.com/trangc0der/trangc0der-tools.git](https://github.com/trangc0der/trangc0der-tools.git)
    cd trangc0der-tools/docker/install-docker/
    ```

2.  **Make the script executable:**

    ```bash
    chmod +x install-docker.sh
    ```

3.  **Run the script with sudo privileges:**
    ```bash
    sudo ./install-docker.sh
    ```
    The script will output its progress.

## Verifying Installation

After the script completes, you can verify the Docker Engine installation by checking the version:

```bash
docker --version
```
