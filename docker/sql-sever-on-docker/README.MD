# SQL Server 2019 Docker Installation Script

This script automates the process of setting up a Microsoft SQL Server 2019 instance running inside a Docker container.

## Overview

Running SQL Server in a Docker container is a fast and efficient way to get a database environment up and running for development and testing. This script simplifies the process by handling the necessary Docker commands to pull the official image and run the container with a basic configuration.

## Prerequisites

Before running this script, you must have the following software installed and running on your system:

- **Docker:** Ensure the Docker service is installed and active. You can check its status with `sudo systemctl status docker`.

## Usage

1.  Connect to your server via SSH and download the installation script from GitHub using `wget` or `curl`.

```bash
wget https://raw.githubusercontent.com/trangc0der/trangc0der-tools/main/docker/sql-sever-on-docker/install-sql-sever-2019-on-docker.sh
```

2.  **Make the script executable:**
    ```bash
    chmod +x install-sql-sever-2019-on-docker.sh
    ```
3.  **Run the script:**
    ```bash
    ./install-sql-sever-2019-on-docker.sh
    ```

The script will then:

1.  Pull the `mcr.microsoft.com/mssql/server:2019-latest` Docker image.
2.  Start a new Docker container with SQL Server.

## Configuration

The script uses the following environment variables to configure the SQL Server container. You can modify these within the script before execution.

- `MSSQL_SA_PASSWORD`: **(Required)** Sets the password for the System Administrator (`sa`) user. **You must set a strong password** to meet Microsoft's password policy requirements.
- `ACCEPT_EULA`: **(Required)** You must set this to `Y` to accept the End-User Licensing Agreement.
- `MSSQL_PID`: (Optional) The Product ID for the SQL Server edition you want to use. Defaults to `Developer` edition if not specified, which is free for development and testing. Other options include `Express`, `Standard`, `Enterprise`, etc.
- **Port Mapping**: The script maps port `1433` on the host to port `1433` in the container, which is the default SQL Server port.

**Example `docker run` command in the script:**

```bash
docker run -e "ACCEPT_EULA=Y" \
           -e "MSSQL_SA_PASSWORD=YourStrong@Password123" \
           -p 1433:1433 \
           --name sql_server_2019 \
           -d mcr.microsoft.com/mssql/server:2019-latest
```

## Connecting to the Database

Once the container is running, you can connect to the SQL Server instance using any standard database tool (like Azure Data Studio, DBeaver, or SQL Server Management Studio) with the following details:

- **Server/Host:** `localhost` (or the IP address of your Docker host)
- **Port:** `1433`
- **Login/User:** `sa`
- **Password:** The password you set for the `MSSQL_SA_PASSWORD` environment variable.

## Managing the Container

Here are some useful Docker commands to manage your SQL Server container:

- **Check container status:**
  ```bash
  docker ps -a
  ```
- **View container logs:**
  ```bash
  docker logs sql_server_2019
  ```
- **Stop the container:**
  ```bash
  docker stop sql_server_2019
  ```
- **Start the container:**
  ```bash
  docker start sql_server_2019
  ```
- **Remove the container (this will delete the data unless you have configured a persistent volume):**
  ```bash
  docker rm sql_server_2019
  ```

---
