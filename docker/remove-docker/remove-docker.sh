#!/bin/bash

# Dừng tất cả các container đang chạy
echo "--- Stopping all running Docker containers ---"
docker stop $(docker ps -aq)

# Xóa tất cả các container, network, image và volume
echo "--- Removing all Docker containers, networks, images, and volumes ---"
docker system prune -a -f --volumes

# Gỡ cài đặt các gói Docker
echo "--- Uninstalling Docker packages ---"
sudo dnf remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# Xóa các tài nguyên Docker còn sót lại
echo "--- Removing residual Docker resources ---"
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker
sudo rm -rf ~/.docker

echo "--- Docker has been successfully removed from the system --- ✅"