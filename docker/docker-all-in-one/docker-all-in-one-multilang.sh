#!/bin/bash

# Kịch bản Đa Chức Năng Quản Lý Docker cho AlmaLinux 8.10
# Phiên bản: 1.1 (Hỗ trợ đa ngôn ngữ)

# --- BIẾN NGÔN NGỮ TOÀN CỤC ---
SCRIPT_LANG="en" # Mặc định là Tiếng Anh

# --- ĐỊNH NGHĨA CHUỖI VĂN BẢN (TIẾNG ANH) ---
EN_ACCESS_DENIED="ERROR: This script must be run with root or sudo privileges."
EN_PROMPT_SUDO_RERUN="Please try again with: sudo \$0"
EN_LANG_CHOICE_PROMPT="Enter your choice (1-2): "
EN_LANG_INVALID_CHOICE="Invalid choice, defaulting to English."

EN_MENU_HEADER="     📜 DOCKER MANAGEMENT MENU (ALMALINUX 8.10) 📜     "
EN_MENU_OPT_INSTALL_DOCKER="1. Install Docker Engine"
EN_MENU_OPT_UNINSTALL_DOCKER="2. Uninstall Docker Engine"
EN_MENU_DOCKER_SERVICE_SUBHEADER="Docker Service:"
EN_MENU_OPT_START_SERVICE="3. Start Docker Service"
EN_MENU_OPT_STOP_SERVICE="4. Stop Docker Service"
EN_MENU_OPT_RESTART_SERVICE="5. Restart Docker Service"
EN_MENU_OPT_STATUS_SERVICE="6. Check Docker Service Status"
EN_MENU_IMG_CONT_SUBHEADER="Image & Container Management:"
EN_MENU_OPT_LIST_IMAGES="7. List Docker Images"
EN_MENU_OPT_LIST_CONTAINERS="8. List Docker Containers (All)"
EN_MENU_OPT_REMOVE_IMAGE="9. Remove a Docker Image"
EN_MENU_OPT_REMOVE_CONTAINER="10. Remove a Docker Container"
EN_MENU_OPT_VIEW_LOGS="11. View Logs of a Container"
EN_MENU_OPT_PULL_IMAGE="12. Pull an Image from Docker Hub"
EN_MENU_UTIL_MAINT_SUBHEADER="Utilities & Maintenance:"
EN_MENU_OPT_PRUNE_SYSTEM="13. Prune Docker System (Clean unused objects)"
EN_MENU_OPT_ADD_USER_GROUP="14. Add current user to 'docker' group"
EN_MENU_OPT_EXIT="0. Exit"
EN_PROMPT_ENTER_CHOICE_MENU="Please select an option [0-14]: "
EN_ERR_INVALID_OPTION="⚠️  Invalid option. Please try again."
EN_MSG_PRESS_ENTER_TO_CONTINUE="Press Enter to continue..."
EN_MSG_EXITING="👋  Exiting!"

EN_MSG_DOCKER_NOT_INSTALLED_CHOOSE_INSTALL="⚠️ Docker is not installed. Please select 'Install Docker Engine' first."
EN_INFO_INSTALLING_DOCKER="🔵 Proceeding with Docker Engine installation..."
EN_MSG_DOCKER_ALREADY_INSTALLED="✅ Docker is already installed. Version:" # Append version
EN_PROMPT_REINSTALL_CONFIRM="Do you want to reinstall? (y/N): "
EN_INFO_UNINSTALLING_OLD_VERSIONS="   Uninstalling old versions (if any)..."
EN_INFO_INSTALLING_DEPS_REPO="   Installing necessary packages and setting up Docker repository..."
EN_INFO_INSTALLING_DOCKER_ENGINE="   Installing Docker Engine, CLI, Containerd and plugins..."
EN_MSG_DOCKER_INSTALL_SUCCESS="✅ Docker Engine installed successfully."
EN_MSG_DOCKER_SERVICE_STARTED_ENABLED="✅ Docker service has been started and enabled."
EN_INFO_ADD_USER_TO_GROUP_POST_INSTALL="   NOTE: To run 'docker' commands without 'sudo', select the 'Add current user to docker group' option."
EN_ERR_DOCKER_INSTALL_FAILED="❌ Error during Docker installation."

EN_PROMPT_UNINSTALL_CONFIRM="⚠️  ARE YOU SURE YOU WANT TO COMPLETELY UNINSTALL DOCKER? (this includes images, containers, volumes) (y/N): "
EN_INFO_UNINSTALLING_DOCKER="🔵 Uninstalling Docker..."
EN_MSG_UNINSTALL_COMPLETE="✅ Docker has been completely uninstalled."
EN_MSG_UNINSTALL_CANCELLED="ℹ️  Docker uninstallation cancelled."

EN_INFO_STARTING_DOCKER="🔵 Starting Docker service..."
EN_MSG_DOCKER_SERVICE_STARTED="✅ Docker service has been started."
EN_ERR_STARTING_DOCKER="❌ Error starting Docker service."
EN_INFO_STOPPING_DOCKER="🔵 Stopping Docker service..."
EN_MSG_DOCKER_SERVICE_STOPPED="✅ Docker service has been stopped."
EN_ERR_STOPPING_DOCKER="❌ Error stopping Docker service."
EN_INFO_RESTARTING_DOCKER="🔵 Restarting Docker service..."
EN_MSG_DOCKER_SERVICE_RESTARTED="✅ Docker service has been restarted."
EN_ERR_RESTARTING_DOCKER="❌ Error restarting Docker service."
EN_INFO_DOCKER_SERVICE_STATUS="🔵 Docker service status:"

EN_INFO_LISTING_IMAGES="🔵 Docker Images List:"
EN_INFO_LISTING_CONTAINERS="🔵 Docker Containers List (including stopped):"
EN_PROMPT_IMAGE_ID_TO_REMOVE="Enter ID or Name of the Image to remove: "
EN_ERR_IMAGE_ID_EMPTY="⚠️ Image ID/Name cannot be empty."
EN_PROMPT_CONTAINER_ID_TO_REMOVE="Enter ID or Name of the Container to remove: "
EN_ERR_CONTAINER_ID_EMPTY="⚠️ Container ID/Name cannot be empty."

EN_WARN_PRUNE_SYSTEM="⚠️  WARNING: This action will remove ALL unused Docker objects:"
EN_INFO_PRUNE_CONTAINERS="   - All stopped containers."
EN_INFO_PRUNE_NETWORKS="   - All networks not used by at least one container."
EN_INFO_PRUNE_IMAGES="   - All dangling images (and potentially all unused images if -a is used)."
EN_INFO_PRUNE_CACHE="   - All build cache."
EN_PROMPT_PRUNE_CONFIRM="Are you sure you want to proceed with pruning the Docker system? (y/N): "
EN_INFO_PRUNING_SYSTEM="🔵 Pruning Docker system..."
EN_MSG_PRUNE_COMPLETE="✅ Docker system has been pruned."
EN_MSG_PRUNE_CANCELLED="ℹ️  Pruning operation cancelled."

EN_ERR_CANNOT_ADD_ROOT_USER="⚠️ Cannot add 'root' user or unidentified user to docker group this way."
EN_INFO_ADD_ROOT_MANUALLY="   If you are running the script as root, please log in as a regular user and run this option again,"
EN_INFO_ADD_ROOT_MANUALLY_CMD="   or perform manually: sudo usermod -aG docker <your_username>"
EN_MSG_USER_ALREADY_IN_GROUP="✅ User '%s' is already in the 'docker' group." # %s will be username
EN_INFO_ADDING_USER_TO_GROUP="🔵 Adding user '%s' to 'docker' group..." # %s will be username
EN_MSG_USER_ADDED_TO_GROUP="✅ User '%s' has been added to the 'docker' group." # %s will be username
EN_INFO_LOGOUT_REQUIRED="   NOTE: You need to LOG OUT and LOG BACK IN for the changes to take effect,"
EN_INFO_NEWGRP_OPTION="   or run 'newgrp docker' in your current terminal session."
EN_ERR_ADDING_USER_TO_GROUP="❌ Error adding user '%s' to 'docker' group." # %s will be username

EN_PROMPT_CONTAINER_ID_FOR_LOGS="Enter ID or Name of the Container to view logs: "
EN_INFO_VIEWING_LOGS="🔵 Logs for container '%s' (Press Ctrl+C to exit):" # %s will be container_id
EN_PROMPT_IMAGE_TO_PULL="Enter the image name to pull (e.g., ubuntu:latest or nginx): "
EN_ERR_IMAGE_NAME_EMPTY="⚠️ Image name cannot be empty."
EN_INFO_PULLING_IMAGE="🔵 Pulling image '%s'..." # %s will be image_name


# --- ĐỊNH NGHĨA CHUỖI VĂN BẢN (TIẾNG VIỆT) ---
VI_ACCESS_DENIED="⚠️  LỖI: Kịch bản này cần được chạy với quyền root hoặc sudo."
VI_PROMPT_SUDO_RERUN="Vui lòng chạy lại với lệnh: sudo \$0"
VI_LANG_CHOICE_PROMPT="Nhập lựa chọn của bạn (1-2): "
VI_LANG_INVALID_CHOICE="Lựa chọn không hợp lệ, mặc định Tiếng Anh."

VI_MENU_HEADER="     📜 MENU QUẢN LÝ DOCKER (ALMALINUX 8.10) 📜     "
VI_MENU_OPT_INSTALL_DOCKER="1. Cài đặt Docker Engine"
VI_MENU_OPT_UNINSTALL_DOCKER="2. Gỡ cài đặt Docker Engine"
VI_MENU_DOCKER_SERVICE_SUBHEADER="Dịch vụ Docker:"
VI_MENU_OPT_START_SERVICE="3. Khởi động Docker Service"
VI_MENU_OPT_STOP_SERVICE="4. Dừng Docker Service"
VI_MENU_OPT_RESTART_SERVICE="5. Khởi động lại Docker Service"
VI_MENU_OPT_STATUS_SERVICE="6. Kiểm tra trạng thái Docker Service"
VI_MENU_IMG_CONT_SUBHEADER="Quản lý Images & Containers:"
VI_MENU_OPT_LIST_IMAGES="7. Liệt kê Docker Images"
VI_MENU_OPT_LIST_CONTAINERS="8. Liệt kê Docker Containers (Tất cả)"
VI_MENU_OPT_REMOVE_IMAGE="9. Xóa một Docker Image"
VI_MENU_OPT_REMOVE_CONTAINER="10. Xóa một Docker Container"
VI_MENU_OPT_VIEW_LOGS="11. Xem log của một Container"
VI_MENU_OPT_PULL_IMAGE="12. Pull một Image từ Docker Hub"
VI_MENU_UTIL_MAINT_SUBHEADER="Tiện ích & Bảo trì:"
VI_MENU_OPT_PRUNE_SYSTEM="13. Dọn dẹp hệ thống Docker (Prune)"
VI_MENU_OPT_ADD_USER_GROUP="14. Thêm người dùng hiện tại vào nhóm 'docker'"
VI_MENU_OPT_EXIT="0. Thoát"
VI_PROMPT_ENTER_CHOICE_MENU="Vui lòng chọn một tùy chọn [0-14]: "
VI_ERR_INVALID_OPTION="⚠️  Lựa chọn không hợp lệ. Vui lòng thử lại."
VI_MSG_PRESS_ENTER_TO_CONTINUE="Nhấn Enter để tiếp tục..."
VI_MSG_EXITING="👋  Tạm biệt!"

VI_MSG_DOCKER_NOT_INSTALLED_CHOOSE_INSTALL="⚠️ Docker chưa được cài đặt. Vui lòng chọn tùy chọn 'Cài đặt Docker Engine' trước."
VI_INFO_INSTALLING_DOCKER="🔵 Đang tiến hành cài đặt Docker Engine..."
VI_MSG_DOCKER_ALREADY_INSTALLED="✅ Docker đã được cài đặt. Phiên bản:" # Append version
VI_PROMPT_REINSTALL_CONFIRM="Bạn có muốn cài đặt lại không? (y/N): "
VI_INFO_UNINSTALLING_OLD_VERSIONS="   Gỡ cài đặt các phiên bản cũ (nếu có)..."
VI_INFO_INSTALLING_DEPS_REPO="   Cài đặt các gói cần thiết và thiết lập kho lưu trữ Docker..."
VI_INFO_INSTALLING_DOCKER_ENGINE="   Cài đặt Docker Engine, CLI, Containerd và các plugin..."
VI_MSG_DOCKER_INSTALL_SUCCESS="✅ Docker Engine đã được cài đặt thành công."
VI_MSG_DOCKER_SERVICE_STARTED_ENABLED="✅ Docker service đã được khởi động và kích hoạt."
VI_INFO_ADD_USER_TO_GROUP_POST_INSTALL="   LƯU Ý: Để chạy lệnh 'docker' mà không cần 'sudo', hãy chọn tùy chọn 'Thêm người dùng hiện tại vào nhóm docker'."
VI_ERR_DOCKER_INSTALL_FAILED="❌ Lỗi trong quá trình cài đặt Docker."

VI_PROMPT_UNINSTALL_CONFIRM="⚠️  BẠN CÓ CHẮC CHẮN MUỐN GỠ CÀI ĐẶT HOÀN TOÀN DOCKER KHÔNG? (bao gồm cả images, containers, volumes) (y/N): "
VI_INFO_UNINSTALLING_DOCKER="🔵 Đang gỡ cài đặt Docker..."
VI_MSG_UNINSTALL_COMPLETE="✅ Docker đã được gỡ cài đặt hoàn toàn."
VI_MSG_UNINSTALL_CANCELLED="ℹ️  Đã hủy thao tác gỡ cài đặt Docker."

VI_INFO_STARTING_DOCKER="🔵 Đang khởi động Docker service..."
VI_MSG_DOCKER_SERVICE_STARTED="✅ Docker service đã được khởi động."
VI_ERR_STARTING_DOCKER="❌ Lỗi khi khởi động Docker service."
VI_INFO_STOPPING_DOCKER="🔵 Đang dừng Docker service..."
VI_MSG_DOCKER_SERVICE_STOPPED="✅ Docker service đã được dừng."
VI_ERR_STOPPING_DOCKER="❌ Lỗi khi dừng Docker service."
VI_INFO_RESTARTING_DOCKER="🔵 Đang khởi động lại Docker service..."
VI_MSG_DOCKER_SERVICE_RESTARTED="✅ Docker service đã được khởi động lại."
VI_ERR_RESTARTING_DOCKER="❌ Lỗi khi khởi động lại Docker service."
VI_INFO_DOCKER_SERVICE_STATUS="🔵 Trạng thái Docker service:"

VI_INFO_LISTING_IMAGES="🔵 Danh sách Docker Images:"
VI_INFO_LISTING_CONTAINERS="🔵 Danh sách Docker Containers (bao gồm cả đã dừng):"
VI_PROMPT_IMAGE_ID_TO_REMOVE="Nhập ID hoặc Tên của Image cần xóa: "
VI_ERR_IMAGE_ID_EMPTY="⚠️ ID/Tên Image không được để trống."
VI_PROMPT_CONTAINER_ID_TO_REMOVE="Nhập ID hoặc Tên của Container cần xóa: "
VI_ERR_CONTAINER_ID_EMPTY="⚠️ ID/Tên Container không được để trống."

VI_WARN_PRUNE_SYSTEM="⚠️  CẢNH BÁO: Thao tác này sẽ xóa TẤT CẢ các đối tượng Docker không sử dụng:"
VI_INFO_PRUNE_CONTAINERS="   - Tất cả các container đã dừng."
VI_INFO_PRUNE_NETWORKS="   - Tất cả các network không được sử dụng bởi ít nhất một container."
VI_INFO_PRUNE_IMAGES="   - Tất cả các image không có tên và không được tham chiếu bởi container nào (dangling images)."
VI_INFO_PRUNE_CACHE="   - Tất cả build cache."
VI_PROMPT_PRUNE_CONFIRM="Bạn có chắc chắn muốn tiếp tục dọn dẹp hệ thống Docker không? (y/N): "
VI_INFO_PRUNING_SYSTEM="🔵 Đang dọn dẹp hệ thống Docker..."
VI_MSG_PRUNE_COMPLETE="✅ Hệ thống Docker đã được dọn dẹp."
VI_MSG_PRUNE_CANCELLED="ℹ️  Đã hủy thao tác dọn dẹp."

VI_ERR_CANNOT_ADD_ROOT_USER="⚠️ Không thể thêm người dùng 'root' hoặc người dùng không xác định vào nhóm docker theo cách này."
VI_INFO_ADD_ROOT_MANUALLY="   Nếu bạn đang chạy script với user root, hãy đăng nhập bằng user thường và chạy lại tùy chọn này,"
VI_INFO_ADD_ROOT_MANUALLY_CMD="   hoặc thực hiện thủ công: sudo usermod -aG docker <tên_user_của_bạn>"
VI_MSG_USER_ALREADY_IN_GROUP="✅ Người dùng '%s' đã ở trong nhóm 'docker'." # %s will be username
VI_INFO_ADDING_USER_TO_GROUP="🔵 Đang thêm người dùng '%s' vào nhóm 'docker'..." # %s will be username
VI_MSG_USER_ADDED_TO_GROUP="✅ Người dùng '%s' đã được thêm vào nhóm 'docker'." # %s will be username
VI_INFO_LOGOUT_REQUIRED="   LƯU Ý: Bạn cần ĐĂNG XUẤT và ĐĂNG NHẬP LẠI để thay đổi có hiệu lực,"
VI_INFO_NEWGRP_OPTION="   hoặc chạy lệnh 'newgrp docker' trong terminal hiện tại."
VI_ERR_ADDING_USER_TO_GROUP="❌ Lỗi khi thêm người dùng '%s' vào nhóm 'docker'." # %s will be username

VI_PROMPT_CONTAINER_ID_FOR_LOGS="Nhập ID hoặc Tên của Container để xem log: "
VI_INFO_VIEWING_LOGS="🔵 Log của container '%s' (Nhấn Ctrl+C để thoát):" # %s will be container_id
VI_PROMPT_IMAGE_TO_PULL="Nhập tên image cần pull (ví dụ: ubuntu:latest hoặc nginx): "
VI_ERR_IMAGE_NAME_EMPTY="⚠️ Tên image không được để trống."
VI_INFO_PULLING_IMAGE="🔵 Đang pull image '%s'..." # %s will be image_name


# --- HÀM LẤY CHUỖI THEO NGÔN NGỮ ---
get_string() {
  local key="$1"
  local var_name
  if [ "$SCRIPT_LANG" == "vi" ]; then
    var_name="VI_$key"
  else
    var_name="EN_$key"
  fi
  # Sử dụng indirect expansion để lấy giá trị của biến có tên được lưu trong var_name
  printf "%s" "${!var_name}"
}

# --- HÀM CHỌN NGÔN NGỮ ---
select_language() {
    echo "Choose your language / Chọn ngôn ngữ của bạn:"
    echo "1. English"
    echo "2. Tiếng Việt"
    local choice
    # Đọc trực tiếp từ /dev/tty để đảm bảo hoạt động ngay cả khi stdin được chuyển hướng
    read -r -p "$(get_string "LANG_CHOICE_PROMPT")" choice < /dev/tty
    case "$choice" in
        1) SCRIPT_LANG="en" ;;
        2) SCRIPT_LANG="vi" ;;
        *) echo "$(get_string "LANG_INVALID_CHOICE")"
           SCRIPT_LANG="en" ;; # Mặc định Tiếng Anh nếu lựa chọn không hợp lệ
    esac
    clear # Xóa màn hình sau khi chọn ngôn ngữ
}

# --- KIỂM TRA QUYỀN ROOT (SAU KHI CÓ HÀM get_string) ---
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "$(get_string "ACCESS_DENIED")"
        echo "$(get_string "PROMPT_SUDO_RERUN")"
        exit 1
    fi
}

# --- GỌI HÀM CHỌN NGÔN NGỮ VÀ KIỂM TRA ROOT ---
select_language # Gọi hàm chọn ngôn ngữ trước
check_root      # Sau đó kiểm tra root để các thông báo lỗi có thể đa ngôn ngữ

# --- CÁC HÀM CHỨC NĂNG (SỬ D dụng get_string) ---

# Hàm kiểm tra Docker đã cài đặt chưa
check_docker_installed() {
  if ! command -v docker &> /dev/null; then
    echo "$(get_string "MSG_DOCKER_NOT_INSTALLED_CHOOSE_INSTALL")"
    return 1
  fi
  return 0
}

# 1. Cài đặt Docker
install_docker() {
  echo "$(get_string "INFO_INSTALLING_DOCKER")"
  if command -v docker &> /dev/null; then
    printf "$(get_string "MSG_DOCKER_ALREADY_INSTALLED") %s\n" "$(docker --version)"
    read -r -p "$(get_string "PROMPT_REINSTALL_CONFIRM")" reinstall_confirm < /dev/tty
    if [[ "$reinstall_confirm" != "y" && "$reinstall_confirm" != "Y" ]]; then
      return
    fi
  fi

  echo "$(get_string "INFO_UNINSTALLING_OLD_VERSIONS")"
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
  echo "$(get_string "INFO_INSTALLING_DEPS_REPO")"
  sudo dnf install -y dnf-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
  sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
  echo "$(get_string "INFO_INSTALLING_DOCKER_ENGINE")"
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  if [ $? -eq 0 ]; then
    echo "$(get_string "MSG_DOCKER_INSTALL_SUCCESS")"
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "$(get_string "MSG_DOCKER_SERVICE_STARTED_ENABLED")"
    echo "$(get_string "INFO_ADD_USER_TO_GROUP_POST_INSTALL")"
  else
    echo "$(get_string "ERR_DOCKER_INSTALL_FAILED")"
  fi
}

# 2. Gỡ cài đặt Docker
uninstall_docker() {
  if ! check_docker_installed; then return; fi
  read -r -p "$(get_string "PROMPT_UNINSTALL_CONFIRM")" confirm < /dev/tty
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "$(get_string "INFO_UNINSTALLING_DOCKER")"
    sudo systemctl stop docker
    sudo dnf remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
    echo "$(get_string "MSG_UNINSTALL_COMPLETE")"
  else
    echo "$(get_string "MSG_UNINSTALL_CANCELLED")"
  fi
}

# 3. Khởi động Docker Service
start_docker_service() {
  if ! check_docker_installed; then return; fi
  echo "$(get_string "INFO_STARTING_DOCKER")"
  sudo systemctl start docker
  if sudo systemctl is-active --quiet docker; then
    echo "$(get_string "MSG_DOCKER_SERVICE_STARTED")"
  else
    echo "$(get_string "ERR_STARTING_DOCKER")"
  fi
}

# 4. Dừng Docker Service
stop_docker_service() {
  if ! check_docker_installed; then return; fi
  echo "$(get_string "INFO_STOPPING_DOCKER")"
  sudo systemctl stop docker
  if ! sudo systemctl is-active --quiet docker; then
    echo "$(get_string "MSG_DOCKER_SERVICE_STOPPED")"
  else
    echo "$(get_string "ERR_STOPPING_DOCKER")"
  fi
}

# 5. Khởi động lại Docker Service
restart_docker_service() {
  if ! check_docker_installed; then return; fi
  echo "$(get_string "INFO_RESTARTING_DOCKER")"
  sudo systemctl restart docker
  if sudo systemctl is-active --quiet docker; then
    echo "$(get_string "MSG_DOCKER_SERVICE_RESTARTED")"
  else
    echo "$(get_string "ERR_RESTARTING_DOCKER")"
  fi
}

# 6. Kiểm tra trạng thái Docker Service
status_docker_service() {
  if ! check_docker_installed; then return; fi
  echo "$(get_string "INFO_DOCKER_SERVICE_STATUS")"
  sudo systemctl status docker
}

# 7. Liệt kê Docker Images
list_docker_images() {
  if ! check_docker_installed; then return; fi
  echo "$(get_string "INFO_LISTING_IMAGES")"
  sudo docker images
}

# 8. Liệt kê Docker Containers (đang chạy và đã dừng)
list_docker_containers() {
  if ! check_docker_installed; then return; fi
  echo "$(get_string "INFO_LISTING_CONTAINERS")"
  sudo docker ps -a
}

# 9. Xóa một Docker Image cụ thể
remove_docker_image() {
  if ! check_docker_installed; then return; fi
  list_docker_images
  local image_id
  read -r -p "$(get_string "PROMPT_IMAGE_ID_TO_REMOVE")" image_id < /dev/tty
  if [ -z "$image_id" ]; then
    echo "$(get_string "ERR_IMAGE_ID_EMPTY")"
    return
  fi
  sudo docker rmi "$image_id"
}

# 10. Xóa một Docker Container cụ thể
remove_docker_container() {
  if ! check_docker_installed; then return; fi
  list_docker_containers
  local container_id
  read -r -p "$(get_string "PROMPT_CONTAINER_ID_TO_REMOVE")" container_id < /dev/tty
  if [ -z "$container_id" ]; then
    echo "$(get_string "ERR_CONTAINER_ID_EMPTY")"
    return
  fi
  sudo docker rm "$container_id"
}

# 11. Dọn dẹp Docker (Prune)
prune_docker_system() {
  if ! check_docker_installed; then return; fi
  echo "$(get_string "WARN_PRUNE_SYSTEM")"
  echo "$(get_string "INFO_PRUNE_CONTAINERS")"
  echo "$(get_string "INFO_PRUNE_NETWORKS")"
  echo "$(get_string "INFO_PRUNE_IMAGES")"
  echo "$(get_string "INFO_PRUNE_CACHE")"
  read -r -p "$(get_string "PROMPT_PRUNE_CONFIRM")" confirm < /dev/tty
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "$(get_string "INFO_PRUNING_SYSTEM")"
    sudo docker system prune -a -f --volumes
    echo "$(get_string "MSG_PRUNE_COMPLETE")"
  else
    echo "$(get_string "MSG_PRUNE_CANCELLED")"
  fi
}

# 12. Thêm người dùng hiện tại vào nhóm docker
add_user_to_docker_group() {
  local current_user
  current_user=${SUDO_USER:-$(whoami)}

  if [ -z "$current_user" ] || [ "$current_user" == "root" ]; then
      echo "$(get_string "ERR_CANNOT_ADD_ROOT_USER")"
      echo "$(get_string "INFO_ADD_ROOT_MANUALLY")"
      echo "$(get_string "INFO_ADD_ROOT_MANUALLY_CMD")"
      return
  fi

  if groups "$current_user" | grep -q '\bdocker\b'; then
    printf "$(get_string "MSG_USER_ALREADY_IN_GROUP")\n" "$current_user"
  else
    printf "$(get_string "INFO_ADDING_USER_TO_GROUP")\n" "$current_user"
    sudo usermod -aG docker "$current_user"
    if [ $? -eq 0 ]; then
      printf "$(get_string "MSG_USER_ADDED_TO_GROUP")\n" "$current_user"
      echo "$(get_string "INFO_LOGOUT_REQUIRED")"
      echo "$(get_string "INFO_NEWGRP_OPTION")"
    else
      printf "$(get_string "ERR_ADDING_USER_TO_GROUP")\n" "$current_user"
    fi
  fi
}

# 13. Xem log của một container
view_container_logs() {
  if ! check_docker_installed; then return; fi
  list_docker_containers
  local container_id
  read -r -p "$(get_string "PROMPT_CONTAINER_ID_FOR_LOGS")" container_id < /dev/tty
  if [ -z "$container_id" ]; then
    echo "$(get_string "ERR_CONTAINER_ID_EMPTY")"
    return
  fi
  printf "$(get_string "INFO_VIEWING_LOGS")\n" "$container_id"
  sudo docker logs -f "$container_id"
}

# 14. Pull một image từ Docker Hub
pull_docker_image() {
  if ! check_docker_installed; then return; fi
  local image_name
  read -r -p "$(get_string "PROMPT_IMAGE_TO_PULL")" image_name < /dev/tty
  if [ -z "$image_name" ]; then
    echo "$(get_string "ERR_IMAGE_NAME_EMPTY")"
    return
  fi
  printf "$(get_string "INFO_PULLING_IMAGE")\n" "$image_name"
  sudo docker pull "$image_name"
}

# --- MENU CHÍNH ---
show_menu() {
  echo ""
  echo "=============================================="
  echo "$(get_string "MENU_HEADER")"
  echo "=============================================="
  echo "$(get_string "MENU_OPT_INSTALL_DOCKER")"
  echo "$(get_string "MENU_OPT_UNINSTALL_DOCKER")"
  echo "----------------------------------------------"
  echo "$(get_string "MENU_DOCKER_SERVICE_SUBHEADER")"
  echo "$(get_string "MENU_OPT_START_SERVICE")"
  echo "$(get_string "MENU_OPT_STOP_SERVICE")"
  echo "$(get_string "MENU_OPT_RESTART_SERVICE")"
  echo "$(get_string "MENU_OPT_STATUS_SERVICE")"
  echo "----------------------------------------------"
  echo "$(get_string "MENU_IMG_CONT_SUBHEADER")"
  echo "$(get_string "MENU_OPT_LIST_IMAGES")"
  echo "$(get_string "MENU_OPT_LIST_CONTAINERS")"
  echo "$(get_string "MENU_OPT_REMOVE_IMAGE")"
  echo "$(get_string "MENU_OPT_REMOVE_CONTAINER")"
  echo "$(get_string "MENU_OPT_VIEW_LOGS")"
  echo "$(get_string "MENU_OPT_PULL_IMAGE")"
  echo "----------------------------------------------"
  echo "$(get_string "MENU_UTIL_MAINT_SUBHEADER")"
  echo "$(get_string "MENU_OPT_PRUNE_SYSTEM")"
  echo "$(get_string "MENU_OPT_ADD_USER_GROUP")"
  echo "----------------------------------------------"
  echo "$(get_string "MENU_OPT_EXIT")"
  echo "=============================================="
}

# --- VÒNG LẶP CHÍNH CỦA KỊCH BẢN ---
while true; do
  show_menu
  # Đọc trực tiếp từ /dev/tty để đảm bảo hoạt động ngay cả khi stdin được chuyển hướng
  read -r -p "$(get_string "PROMPT_ENTER_CHOICE_MENU")" choice < /dev/tty

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
    0) echo "$(get_string "MSG_EXITING")"; exit 0 ;;
    *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
  esac
  echo ""
  read -r -p "$(get_string "MSG_PRESS_ENTER_TO_CONTINUE")" < /dev/tty
  clear 
done