#!/bin/bash

# Kịch bản Đa Chức Năng Quản Lý Docker cho AlmaLinux 8.10
# Tác giả: trangc0der
# Phiên bản: 1.0

# --- KIỂM TRA QUYỀN ROOT ---
if [ "$(id -u)" -ne 0 ]; then
  echo "⚠️  LỖI: Kịch bản này cần được chạy với quyền root hoặc sudo."
  echo "Vui lòng chạy lại với lệnh: sudo $0"
  exit 1
fi

# --- CÁC HÀM CHỨC NĂNG ---

# Hàm kiểm tra Docker đã cài đặt chưa
check_docker_installed() {
  if ! command -v docker &> /dev/null; then
    echo "⚠️ Docker chưa được cài đặt. Vui lòng chọn tùy chọn 'Cài đặt Docker' trước."
    return 1
  fi
  return 0
}

# 1. Cài đặt Docker
install_docker() {
  echo "🔵 Đang tiến hành cài đặt Docker Engine..."
  if command -v docker &> /dev/null; then
    echo "✅ Docker đã được cài đặt. Phiên bản: $(docker --version)"
    read -r -p "Bạn có muốn cài đặt lại không? (y/N): " reinstall_confirm
    if [[ "$reinstall_confirm" != "y" && "$reinstall_confirm" != "Y" ]]; then
      return
    fi
  fi

  echo "   Gỡ cài đặt các phiên bản cũ (nếu có)..."
  sudo dnf remove docker \
                    docker-client \
                    docker-client-latest \
                    docker-common \
                    docker-latest \
                    docker-latest-logrotate \
                    docker-logrotate \
                    docker-engine \
                    podman \
                    runc -y > /dev/null 2>&1
  echo "   Cài đặt các gói cần thiết và thiết lập kho lưu trữ Docker..."
  sudo dnf install -y dnf-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
  sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
  echo "   Cài đặt Docker Engine, CLI, Containerd và các plugin..."
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  if [ $? -eq 0 ]; then
    echo "✅ Docker Engine đã được cài đặt thành công."
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "✅ Docker service đã được khởi động và kích hoạt."
    echo "   LƯU Ý: Để chạy lệnh 'docker' mà không cần 'sudo', hãy chọn tùy chọn 'Thêm người dùng vào nhóm docker'."
  else
    echo "❌ Lỗi trong quá trình cài đặt Docker."
  fi
}

# 2. Gỡ cài đặt Docker
uninstall_docker() {
  if ! check_docker_installed; then return; fi
  read -r -p "⚠️  BẠN CÓ CHẮC CHẮN MUỐN GỠ CÀI ĐẶT HOÀN TOÀN DOCKER KHÔNG? (bao gồm cả images, containers, volumes) (y/N): " confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "🔵 Đang gỡ cài đặt Docker..."
    sudo systemctl stop docker
    sudo dnf remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
    # sudo groupdel docker # Cân nhắc nếu muốn xóa cả group
    echo "✅ Docker đã được gỡ cài đặt hoàn toàn."
  else
    echo "ℹ️  Đã hủy thao tác gỡ cài đặt Docker."
  fi
}

# 3. Khởi động Docker Service
start_docker_service() {
  if ! check_docker_installed; then return; fi
  echo "🔵 Đang khởi động Docker service..."
  sudo systemctl start docker
  if sudo systemctl is-active --quiet docker; then
    echo "✅ Docker service đã được khởi động."
  else
    echo "❌ Lỗi khi khởi động Docker service."
  fi
}

# 4. Dừng Docker Service
stop_docker_service() {
  if ! check_docker_installed; then return; fi
  echo "🔵 Đang dừng Docker service..."
  sudo systemctl stop docker
  if ! sudo systemctl is-active --quiet docker; then
    echo "✅ Docker service đã được dừng."
  else
    echo "❌ Lỗi khi dừng Docker service."
  fi
}

# 5. Khởi động lại Docker Service
restart_docker_service() {
  if ! check_docker_installed; then return; fi
  echo "🔵 Đang khởi động lại Docker service..."
  sudo systemctl restart docker
  if sudo systemctl is-active --quiet docker; then
    echo "✅ Docker service đã được khởi động lại."
  else
    echo "❌ Lỗi khi khởi động lại Docker service."
  fi
}

# 6. Kiểm tra trạng thái Docker Service
status_docker_service() {
  if ! check_docker_installed; then return; fi
  echo "🔵 Trạng thái Docker service:"
  sudo systemctl status docker
}

# 7. Liệt kê Docker Images
list_docker_images() {
  if ! check_docker_installed; then return; fi
  echo "🔵 Danh sách Docker Images:"
  sudo docker images
}

# 8. Liệt kê Docker Containers (đang chạy và đã dừng)
list_docker_containers() {
  if ! check_docker_installed; then return; fi
  echo "🔵 Danh sách Docker Containers (bao gồm cả đã dừng):"
  sudo docker ps -a
}

# 9. Xóa một Docker Image cụ thể
remove_docker_image() {
  if ! check_docker_installed; then return; fi
  list_docker_images
  read -r -p "Nhập ID hoặc Tên của Image cần xóa: " image_id
  if [ -z "$image_id" ]; then
    echo "⚠️ ID/Tên Image không được để trống."
    return
  fi
  sudo docker rmi "$image_id"
}

# 10. Xóa một Docker Container cụ thể
remove_docker_container() {
  if ! check_docker_installed; then return; fi
  list_docker_containers
  read -r -p "Nhập ID hoặc Tên của Container cần xóa: " container_id
  if [ -z "$container_id" ]; then
    echo "⚠️ ID/Tên Container không được để trống."
    return
  fi
  sudo docker rm "$container_id"
}

# 11. Dọn dẹp Docker (Prune)
prune_docker_system() {
  if ! check_docker_installed; then return; fi
  echo "⚠️  CẢNH BÁO: Thao tác này sẽ xóa TẤT CẢ các đối tượng Docker không sử dụng:"
  echo "   - Tất cả các container đã dừng."
  echo "   - Tất cả các network không được sử dụng bởi ít nhất một container."
  echo "   - Tất cả các image không có tên và không được tham chiếu bởi container nào (dangling images)."
  echo "   - Tất cả build cache."
  read -r -p "Bạn có chắc chắn muốn tiếp tục dọn dẹp hệ thống Docker không? (y/N): " confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "🔵 Đang dọn dẹp hệ thống Docker..."
    sudo docker system prune -a -f --volumes 
    # Thêm --volumes để xóa cả volume không sử dụng nếu muốn
    # sudo docker system prune -a -f # Không xóa volume
    echo "✅ Hệ thống Docker đã được dọn dẹp."
  else
    echo "ℹ️  Đã hủy thao tác dọn dẹp."
  fi
}

# 12. Thêm người dùng hiện tại vào nhóm docker
add_user_to_docker_group() {
  local current_user
  current_user=${SUDO_USER:-$(whoami)} # Lấy người dùng đã gọi sudo, hoặc người dùng hiện tại nếu không có SUDO_USER

  if [ -z "$current_user" ] || [ "$current_user" == "root" ]; then
      echo "⚠️ Không thể thêm người dùng 'root' hoặc người dùng không xác định vào nhóm docker theo cách này."
      echo "   Nếu bạn đang chạy script với user root, hãy đăng nhập bằng user thường và chạy lại tùy chọn này,"
      echo "   hoặc thực hiện thủ công: sudo usermod -aG docker <tên_user_của_bạn>"
      return
  fi

  if groups "$current_user" | grep -q '\bdocker\b'; then
    echo "✅ Người dùng '$current_user' đã ở trong nhóm 'docker'."
  else
    echo "🔵 Đang thêm người dùng '$current_user' vào nhóm 'docker'..."
    sudo usermod -aG docker "$current_user"
    if [ $? -eq 0 ]; then
      echo "✅ Người dùng '$current_user' đã được thêm vào nhóm 'docker'."
      echo "   LƯU Ý: Bạn cần ĐĂNG XUẤT và ĐĂNG NHẬP LẠI để thay đổi có hiệu lực,"
      echo "   hoặc chạy lệnh 'newgrp docker' trong terminal hiện tại."
    else
      echo "❌ Lỗi khi thêm người dùng '$current_user' vào nhóm 'docker'."
    fi
  fi
}

# 13. Xem log của một container
view_container_logs() {
  if ! check_docker_installed; then return; fi
  list_docker_containers
  read -r -p "Nhập ID hoặc Tên của Container để xem log: " container_id
  if [ -z "$container_id" ]; then
    echo "⚠️ ID/Tên Container không được để trống."
    return
  fi
  echo "🔵 Log của container '$container_id' (Nhấn Ctrl+C để thoát):"
  sudo docker logs -f "$container_id"
}

# 14. Pull một image từ Docker Hub
pull_docker_image() {
  if ! check_docker_installed; then return; fi
  read -r -p "Nhập tên image cần pull (ví dụ: ubuntu:latest hoặc nginx): " image_name
  if [ -z "$image_name" ]; then
    echo "⚠️ Tên image không được để trống."
    return
  fi
  echo "🔵 Đang pull image '$image_name'..."
  sudo docker pull "$image_name"
}


# --- MENU CHÍNH ---
show_menu() {
  echo ""
  echo "=============================================="
  echo "     📜 MENU QUẢN LÝ DOCKER (ALMALINUX 8.10) 📜     "
  echo "=============================================="
  echo "  1. Cài đặt Docker Engine"
  echo "  2. Gỡ cài đặt Docker Engine"
  echo "----------------------------------------------"
  echo "  Dịch vụ Docker:"
  echo "  3. Khởi động Docker Service"
  echo "  4. Dừng Docker Service"
  echo "  5. Khởi động lại Docker Service"
  echo "  6. Kiểm tra trạng thái Docker Service"
  echo "----------------------------------------------"
  echo "  Quản lý Images & Containers:"
  echo "  7. Liệt kê Docker Images"
  echo "  8. Liệt kê Docker Containers (Tất cả)"
  echo "  9. Xóa một Docker Image"
  echo "  10. Xóa một Docker Container"
  echo "  11. Xem log của một Container"
  echo "  12. Pull một Image từ Docker Hub"
  echo "----------------------------------------------"
  echo "  Tiện ích & Bảo trì:"
  echo "  13. Dọn dẹp hệ thống Docker (Prune)"
  echo "  14. Thêm người dùng hiện tại vào nhóm 'docker'"
  echo "----------------------------------------------"
  echo "  0. Thoát"
  echo "=============================================="
}

# --- VÒNG LẶP CHÍNH CỦA KỊCH BẢN ---
while true; do
  show_menu
  read -r -p "Vui lòng chọn một tùy chọn [0-14]: " choice

  case $choice in
    1) install_docker ;;
    2) uninstall_docker ;;
    3) start_docker_service ;;
    4) stop_docker_service ;;
    5) restart_docker_service ;;
    6) status_docker_service ;;
    7) list_docker_images ;;
    8) list_docker_containers ;;
    9) remove_docker_image ;;
    10) remove_docker_container ;;
    11) view_container_logs ;;
    12) pull_docker_image ;;
    13) prune_docker_system ;;
    14) add_user_to_docker_group ;;
    0) echo "👋  Tạm biệt!"; exit 0 ;;
    *) echo "⚠️  Lựa chọn không hợp lệ. Vui lòng thử lại." ;;
  esac
  echo ""
  read -r -p "Nhấn Enter để tiếp tục..."
  clear # Xóa màn hình cho dễ nhìn ở lần lặp menu tiếp theo
done