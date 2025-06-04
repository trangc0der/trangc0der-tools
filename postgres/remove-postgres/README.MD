This guide explains how to use the `remove-postgres.sh` script to completely uninstall PostgreSQL and all its data from your system.

> ### ⚠️ **WARNING: PERMANENT DATA LOSS**
>
> This script is designed to **permanently and completely remove** PostgreSQL from your system. It will delete:
>
> - All PostgreSQL databases and their data.
> - All related software packages.
> - The dedicated `postgres` system user.
>
> **Ensure you have backed up any critical data before running this script**.

---

### **Compatibility**

This script is specifically designed for **AlmaLinux 8.x** and other Linux distributions that use the `dnf` package manager (like CentOS, Fedora, or RHEL).

---

### **How to Use**

#### **Step 1: Download the Script**

Connect to your server via SSH and download the script from its GitHub repository.

```bash
wget https://raw.githubusercontent.com/trangc0der/trangc0der-tools/main/postgres/remove-postgres/remove-postgres.sh
```

#### **Step 2: Make the Script Executable**

Grant execute permissions to the downloaded file.

```bash
chmod +x remove-postgres.sh
```

#### **Step 3: Run the Script**

Execute the script with `sudo` privileges, which are required to stop services and remove system files and packages.

```bash
sudo ./remove-postgres.sh
```

The script will run automatically without further prompts, showing its progress at each stage.

---

### **The Removal Process**

The script performs the following four steps to ensure a complete and clean uninstallation:

1.  **Stop and Disable PostgreSQL Services**: It first finds any running PostgreSQL services, stops them, and disables them so they don't start on the next boot.
2.  **Uninstall PostgreSQL Packages**: The script uses `dnf` to remove all packages related to PostgreSQL, including the server, libraries, and any additional modules.
3.  **Delete Data and Configuration**: It then permanently deletes the `/var/lib/pgsql` directory, which contains all of your databases and configuration files.
4.  **Remove the 'postgres' User**: Finally, it removes the `postgres` system user that was created during the initial installation.

Once finished, the script will display a confirmation message: `✅ Quá trình gỡ cài đặt PostgreSQL đã hoàn tất!`.
