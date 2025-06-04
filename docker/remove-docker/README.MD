### **Guide: How to Completely Remove Docker Using an Automated Script**

This guide explains how to use the `remove-docker.sh` script to completely and permanently uninstall Docker from a DNF-based Linux system.

> **WARNING: DESTRUCTIVE ACTION**
> This script is designed to permanently and completely remove Docker. It will irreversibly delete:
>
> - All Docker containers (running or stopped).
> - All Docker images.
> - All Docker networks.
> - **All Docker volumes, which means any persistent data stored by your containers will be permanently lost.**
>
> Please back up any important data before proceeding.

### **Compatibility**

This script is specifically designed for Linux distributions that use the `dnf` package manager, such as **AlmaLinux, CentOS, Fedora, or RHEL**.

### **How to Use**

#### **Step 1: Download the Script**

Connect to your server via SSH and download the script from its GitHub repository.

```bash
wget https://raw.githubusercontent.com/trangc0der/trangc0der-tools/main/docker/remove-docker/remove-docker.sh
```

#### **Step 2: Make the Script Executable**

Grant execute permissions to the downloaded file.

```bash
chmod +x remove-docker.sh
```

#### **Step 3: Run the Script**

Execute the script with `sudo` privileges to allow it to remove system packages and directories.

```bash
sudo ./remove-docker.sh
```

The script will run without further prompts and will display its progress as it executes each step.

### **What the Script Does**

The script performs the following actions in sequence to ensure a complete removal:

1.  **Stops all Docker containers**: It begins by safely stopping all containers that are currently running on your system.
2.  **Prunes all Docker Data**: The script then executes a powerful command to delete all stopped containers, all networks, all images, and all volumes.
3.  **Uninstalls Docker Packages**: It proceeds to use the `dnf` package manager to uninstall `docker-ce`, `docker-ce-cli`, `containerd.io`, and other related Docker packages.
4.  **Removes Residual Files**: Finally, it cleans up the system by deleting leftover Docker directories, including `/var/lib/docker`, `/var/lib/containerd`, `/etc/docker`, and the user-specific `~/.docker` folder, to ensure no configuration files or data remain.

Once completed, you will see a confirmation message: `--- Docker has been successfully removed from the system --- ✅`.
