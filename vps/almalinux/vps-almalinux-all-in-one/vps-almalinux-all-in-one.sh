#!/bin/bash

# Kịch bản Quản lý VPS Toàn diện (VPS All-In-One) cho AlmaLinux 8.10
# Phiên bản: 1.0
# Hỗ trợ đa ngôn ngữ: Tiếng Việt, Tiếng Anh

# --- BIẾN NGÔN NGỮ TOÀN CỤC ---
SCRIPT_LANG="en" # Mặc định là Tiếng Anh

# --- ĐỊNH NGHĨA CHUỖI VĂN BẢN (TIẾNG ANH) ---
EN_ACCESS_DENIED="ERROR: This script must be run with root or sudo privileges."
EN_PROMPT_SUDO_RERUN="Please try again with: sudo \$0"
EN_LANG_CHOICE_PROMPT="Enter your choice (1-2): "
EN_LANG_INVALID_CHOICE="Invalid choice, defaulting to English."

EN_MAIN_MENU_HEADER="     🌟 VPS All-In-One Management Script (AlmaLinux 8.10) 🌟     "
EN_MENU_CAT_SYS_INFO="1. System Information"
EN_MENU_CAT_SYS_MAINTENANCE="2. System Maintenance"
EN_MENU_CAT_SERVICE_MGMT="3. Service Management"
EN_MENU_CAT_USER_MGMT="4. User Management"
EN_MENU_CAT_FIREWALL_MGMT="5. Firewall (firewalld) Management"
EN_MENU_OPT_EXIT="0. Exit"
EN_PROMPT_ENTER_CHOICE="Please select an option: "
EN_ERR_INVALID_OPTION="⚠️  Invalid option. Please try again."
EN_MSG_PRESS_ENTER_TO_CONTINUE="Press Enter to continue..."
EN_MSG_EXITING="👋  Exiting script!"

# System Info
EN_INFO_SYS_INFO_HEADER="--- System Information ---"
EN_INFO_HOSTNAME="Hostname:"
EN_INFO_OS_VERSION="OS Version:"
EN_INFO_KERNEL_VERSION="Kernel Version:"
EN_INFO_UPTIME="System Uptime:"
EN_INFO_CPU_LOAD="CPU Load Average (1, 5, 15 min):"
EN_INFO_DISK_USAGE_HEADER="--- Disk Usage ---"
EN_INFO_MEMORY_USAGE_HEADER="--- Memory Usage ---"

# System Maintenance
EN_INFO_UPDATING_SYSTEM="🔵 Updating system packages... This may take a while."
EN_MSG_UPDATE_SUCCESS="✅ System updated successfully."
EN_MSG_UPDATE_FAIL="❌ Failed to update system."
EN_PROMPT_PKG_NAME_INSTALL="Enter the name of the package to install: "
EN_INFO_INSTALLING_PKG="🔵 Installing package '%s'..." # %s is package name
EN_MSG_PKG_INSTALL_SUCCESS="✅ Package '%s' installed successfully."
EN_MSG_PKG_INSTALL_FAIL="❌ Failed to install package '%s'."
EN_ERR_PKG_NAME_EMPTY="⚠️ Package name cannot be empty."
EN_PROMPT_PKG_NAME_REMOVE="Enter the name of the package to remove: "
EN_INFO_REMOVING_PKG="🔵 Removing package '%s'..." # %s is package name
EN_MSG_PKG_REMOVE_SUCCESS="✅ Package '%s' removed successfully."
EN_MSG_PKG_REMOVE_FAIL="❌ Failed to remove package '%s'."
EN_PROMPT_REBOOT_CONFIRM="⚠️  Are you sure you want to reboot the server now? (y/N): "
EN_INFO_REBOOTING="🔵 Rebooting server NOW..."
EN_MSG_REBOOT_CANCELLED="ℹ️  Reboot cancelled."
EN_PROMPT_SHUTDOWN_CONFIRM="⚠️  Are you sure you want to shut down the server now? (y/N): "
EN_INFO_SHUTTING_DOWN="🔵 Shutting down server NOW..."
EN_MSG_SHUTDOWN_CANCELLED="ℹ️  Shutdown cancelled."

# Service Management
EN_SERVICE_MENU_HEADER="--- Service Management Menu ---"
EN_SERVICE_OPT_START="1. Start a Service"
EN_SERVICE_OPT_STOP="2. Stop a Service"
EN_SERVICE_OPT_RESTART="3. Restart a Service"
EN_SERVICE_OPT_STATUS="4. Check Service Status"
EN_SERVICE_OPT_ENABLE="5. Enable a Service (start on boot)"
EN_SERVICE_OPT_DISABLE="6. Disable a Service (don't start on boot)"
EN_SERVICE_OPT_BACK="0. Back to Main Menu"
EN_PROMPT_SERVICE_NAME="Enter the service name (e.g., httpd, sshd): "
EN_ERR_SERVICE_NAME_EMPTY="⚠️ Service name cannot be empty."
EN_INFO_STARTING_SERVICE="🔵 Starting service '%s'..."
EN_MSG_SERVICE_START_SUCCESS="✅ Service '%s' started successfully."
EN_MSG_SERVICE_START_FAIL="❌ Failed to start service '%s'."
EN_INFO_STOPPING_SERVICE="🔵 Stopping service '%s'..."
EN_MSG_SERVICE_STOP_SUCCESS="✅ Service '%s' stopped successfully."
EN_MSG_SERVICE_STOP_FAIL="❌ Failed to stop service '%s'."
EN_INFO_RESTARTING_SERVICE="🔵 Restarting service '%s'..."
EN_MSG_SERVICE_RESTART_SUCCESS="✅ Service '%s' restarted successfully."
EN_MSG_SERVICE_RESTART_FAIL="❌ Failed to restart service '%s'."
EN_INFO_SERVICE_STATUS="🔵 Status of service '%s':"
EN_INFO_ENABLING_SERVICE="🔵 Enabling service '%s'..."
EN_MSG_SERVICE_ENABLE_SUCCESS="✅ Service '%s' enabled."
EN_MSG_SERVICE_ENABLE_FAIL="❌ Failed to enable service '%s'."
EN_INFO_DISABLING_SERVICE="🔵 Disabling service '%s'..."
EN_MSG_SERVICE_DISABLE_SUCCESS="✅ Service '%s' disabled."
EN_MSG_SERVICE_DISABLE_FAIL="❌ Failed to disable service '%s'."

# User Management
EN_USER_MENU_HEADER="--- User Management Menu ---"
EN_USER_OPT_ADD="1. Add a New User"
EN_USER_OPT_DELETE="2. Delete a User"
EN_USER_OPT_ADD_SUDO="3. Add User to Sudoers (wheel group)"
EN_USER_OPT_LIST="4. List All Local Users"
EN_USER_OPT_BACK="0. Back to Main Menu"
EN_PROMPT_USERNAME_ADD="Enter username for the new user: "
EN_ERR_USERNAME_EMPTY="⚠️ Username cannot be empty."
EN_INFO_ADDING_USER="🔵 Adding user '%s'..."
EN_MSG_USER_ADD_SUCCESS="✅ User '%s' added successfully. Please set a password for the user."
EN_MSG_USER_ADD_FAIL="❌ Failed to add user '%s'."
EN_PROMPT_SET_PASSWORD_NOW="Do you want to set password for '%s' now? (y/N): "
EN_PROMPT_USERNAME_DELETE="Enter username to delete: "
EN_PROMPT_DELETE_USER_CONFIRM="⚠️  Are you sure you want to delete user '%s' and their home directory? (y/N): "
EN_INFO_DELETING_USER="🔵 Deleting user '%s'..."
EN_MSG_USER_DELETE_SUCCESS="✅ User '%s' deleted successfully."
EN_MSG_USER_DELETE_FAIL="❌ Failed to delete user '%s'."
EN_PROMPT_USERNAME_SUDO="Enter username to add to sudoers (wheel group): "
EN_INFO_ADDING_USER_SUDO="🔵 Adding user '%s' to wheel group..."
EN_MSG_USER_ADD_SUDO_SUCCESS="✅ User '%s' added to wheel group. They will have sudo privileges on next login."
EN_MSG_USER_ADD_SUDO_FAIL="❌ Failed to add user '%s' to wheel group."
EN_MSG_USER_ALREADY_SUDO="ℹ️  User '%s' is already in the wheel group or has sudo privileges."
EN_INFO_LISTING_USERS="--- Local Users ---"

# Firewall Management
EN_FIREWALL_MENU_HEADER="--- Firewall (firewalld) Management Menu ---"
EN_FIREWALL_OPT_STATUS="1. Check Firewall Status"
EN_FIREWALL_OPT_ADD_SERVICE="2. Add a Service"
EN_FIREWALL_OPT_REMOVE_SERVICE="3. Remove a Service"
EN_FIREWALL_OPT_ADD_PORT="4. Add a Port"
EN_FIREWALL_OPT_REMOVE_PORT="5. Remove a Port"
EN_FIREWALL_OPT_RELOAD="6. Reload Firewall"
EN_FIREWALL_OPT_LIST_ALL="7. List All Rules & Zones"
EN_FIREWALL_OPT_BACK="0. Back to Main Menu"
EN_INFO_FIREWALL_STATUS_HEADER="--- Firewall Status ---"
EN_MSG_FIREWALL_NOT_RUNNING="⚠️ Firewalld is not running."
EN_PROMPT_SERVICE_FIREWALL_ADD="Enter service name to add (e.g., http, https, ssh): "
EN_ERR_SERVICE_FW_NAME_EMPTY="⚠️ Service name cannot be empty."
EN_INFO_ADDING_SERVICE_FW="🔵 Adding service '%s' to firewall (permanent)..."
EN_MSG_SERVICE_FW_ADD_SUCCESS="✅ Service '%s' added. Reload firewall to apply changes."
EN_MSG_SERVICE_FW_ADD_FAIL="❌ Failed to add service '%s'."
EN_PROMPT_SERVICE_FIREWALL_REMOVE="Enter service name to remove: "
EN_INFO_REMOVING_SERVICE_FW="🔵 Removing service '%s' from firewall (permanent)..."
EN_MSG_SERVICE_FW_REMOVE_SUCCESS="✅ Service '%s' removed. Reload firewall to apply changes."
EN_MSG_SERVICE_FW_REMOVE_FAIL="❌ Failed to remove service '%s'."
EN_PROMPT_PORT_FIREWALL_ADD="Enter port to add (e.g., 8080/tcp or 53/udp): "
EN_ERR_PORT_FW_EMPTY_INVALID="⚠️ Port cannot be empty and should be in format port/protocol (e.g., 8080/tcp)."
EN_INFO_ADDING_PORT_FW="🔵 Adding port '%s' to firewall (permanent)..."
EN_MSG_PORT_FW_ADD_SUCCESS="✅ Port '%s' added. Reload firewall to apply changes."
EN_MSG_PORT_FW_ADD_FAIL="❌ Failed to add port '%s'."
EN_PROMPT_PORT_FIREWALL_REMOVE="Enter port to remove (e.g., 8080/tcp): "
EN_INFO_REMOVING_PORT_FW="🔵 Removing port '%s' from firewall (permanent)..."
EN_MSG_PORT_FW_REMOVE_SUCCESS="✅ Port '%s' removed. Reload firewall to apply changes."
EN_MSG_PORT_FW_REMOVE_FAIL="❌ Failed to remove port '%s'."
EN_INFO_RELOADING_FIREWALL="🔵 Reloading firewall..."
EN_MSG_FIREWALL_RELOAD_SUCCESS="✅ Firewall reloaded successfully."
EN_MSG_FIREWALL_RELOAD_FAIL="❌ Failed to reload firewall."
EN_INFO_LISTING_FIREWALL_RULES="--- Current Firewall Configuration ---"

# --- ĐỊNH NGHĨA CHUỖI VĂN BẢN (TIẾNG VIỆT) ---
VI_ACCESS_DENIED="⚠️  LỖI: Kịch bản này cần được chạy với quyền root hoặc sudo."
VI_PROMPT_SUDO_RERUN="Vui lòng chạy lại với lệnh: sudo \$0"
VI_LANG_CHOICE_PROMPT="Nhập lựa chọn của bạn (1-2): "
VI_LANG_INVALID_CHOICE="Lựa chọn không hợp lệ, mặc định Tiếng Anh."

VI_MAIN_MENU_HEADER="     🌟 Kịch Bản Quản Lý VPS Toàn Diện (AlmaLinux 8.10) 🌟     "
VI_MENU_CAT_SYS_INFO="1. Thông tin Hệ thống"
VI_MENU_CAT_SYS_MAINTENANCE="2. Bảo trì Hệ thống"
VI_MENU_CAT_SERVICE_MGMT="3. Quản lý Dịch vụ"
VI_MENU_CAT_USER_MGMT="4. Quản lý Người dùng"
VI_MENU_CAT_FIREWALL_MGMT="5. Quản lý Tường lửa (firewalld)"
VI_MENU_OPT_EXIT="0. Thoát"
VI_PROMPT_ENTER_CHOICE="Vui lòng chọn một tùy chọn: "
VI_ERR_INVALID_OPTION="⚠️  Lựa chọn không hợp lệ. Vui lòng thử lại."
VI_MSG_PRESS_ENTER_TO_CONTINUE="Nhấn Enter để tiếp tục..."
VI_MSG_EXITING="👋  Thoát kịch bản!"

# System Info
VI_INFO_SYS_INFO_HEADER="--- Thông tin Hệ thống ---"
VI_INFO_HOSTNAME="Tên máy (Hostname):"
VI_INFO_OS_VERSION="Phiên bản HĐH:"
VI_INFO_KERNEL_VERSION="Phiên bản Kernel:"
VI_INFO_UPTIME="Thời gian hoạt động:"
VI_INFO_CPU_LOAD="Tải CPU trung bình (1, 5, 15 phút):"
VI_INFO_DISK_USAGE_HEADER="--- Dung lượng Đĩa ---"
VI_INFO_MEMORY_USAGE_HEADER="--- Bộ nhớ (RAM) ---"

# System Maintenance
VI_INFO_UPDATING_SYSTEM="🔵 Đang cập nhật các gói hệ thống... Việc này có thể mất một lúc."
VI_MSG_UPDATE_SUCCESS="✅ Hệ thống đã được cập nhật thành công."
VI_MSG_UPDATE_FAIL="❌ Cập nhật hệ thống thất bại."
VI_PROMPT_PKG_NAME_INSTALL="Nhập tên gói cần cài đặt: "
VI_INFO_INSTALLING_PKG="🔵 Đang cài đặt gói '%s'..."
VI_MSG_PKG_INSTALL_SUCCESS="✅ Gói '%s' đã được cài đặt thành công."
VI_MSG_PKG_INSTALL_FAIL="❌ Cài đặt gói '%s' thất bại."
VI_ERR_PKG_NAME_EMPTY="⚠️ Tên gói không được để trống."
VI_PROMPT_PKG_NAME_REMOVE="Nhập tên gói cần gỡ bỏ: "
VI_INFO_REMOVING_PKG="🔵 Đang gỡ bỏ gói '%s'..."
VI_MSG_PKG_REMOVE_SUCCESS="✅ Gói '%s' đã được gỡ bỏ thành công."
VI_MSG_PKG_REMOVE_FAIL="❌ Gỡ bỏ gói '%s' thất bại."
VI_PROMPT_REBOOT_CONFIRM="⚠️  Bạn có chắc chắn muốn khởi động lại máy chủ ngay bây giờ không? (y/N): "
VI_INFO_REBOOTING="🔵 Đang khởi động lại máy chủ NGAY BÂY GIỜ..."
VI_MSG_REBOOT_CANCELLED="ℹ️  Đã hủy khởi động lại."
VI_PROMPT_SHUTDOWN_CONFIRM="⚠️  Bạn có chắc chắn muốn tắt máy chủ ngay bây giờ không? (y/N): "
VI_INFO_SHUTTING_DOWN="🔵 Đang tắt máy chủ NGAY BÂY GIỜ..."
VI_MSG_SHUTDOWN_CANCELLED="ℹ️  Đã hủy tắt máy."

# Service Management
VI_SERVICE_MENU_HEADER="--- Menu Quản lý Dịch vụ ---"
VI_SERVICE_OPT_START="1. Khởi động Dịch vụ"
VI_SERVICE_OPT_STOP="2. Dừng Dịch vụ"
VI_SERVICE_OPT_RESTART="3. Khởi động lại Dịch vụ"
VI_SERVICE_OPT_STATUS="4. Kiểm tra Trạng thái Dịch vụ"
VI_SERVICE_OPT_ENABLE="5. Kích hoạt Dịch vụ (khởi động cùng hệ thống)"
VI_SERVICE_OPT_DISABLE="6. Vô hiệu hóa Dịch vụ (không khởi động cùng hệ thống)"
VI_SERVICE_OPT_BACK="0. Quay lại Menu Chính"
VI_PROMPT_SERVICE_NAME="Nhập tên dịch vụ (ví dụ: httpd, sshd): "
VI_ERR_SERVICE_NAME_EMPTY="⚠️ Tên dịch vụ không được để trống."
VI_INFO_STARTING_SERVICE="🔵 Đang khởi động dịch vụ '%s'..."
VI_MSG_SERVICE_START_SUCCESS="✅ Dịch vụ '%s' đã được khởi động."
VI_MSG_SERVICE_START_FAIL="❌ Khởi động dịch vụ '%s' thất bại."
VI_INFO_STOPPING_SERVICE="🔵 Đang dừng dịch vụ '%s'..."
VI_MSG_SERVICE_STOP_SUCCESS="✅ Dịch vụ '%s' đã được dừng."
VI_MSG_SERVICE_STOP_FAIL="❌ Dừng dịch vụ '%s' thất bại."
VI_INFO_RESTARTING_SERVICE="🔵 Đang khởi động lại dịch vụ '%s'..."
VI_MSG_SERVICE_RESTART_SUCCESS="✅ Dịch vụ '%s' đã được khởi động lại."
VI_MSG_SERVICE_RESTART_FAIL="❌ Khởi động lại dịch vụ '%s' thất bại."
VI_INFO_SERVICE_STATUS="🔵 Trạng thái của dịch vụ '%s':"
VI_INFO_ENABLING_SERVICE="🔵 Đang kích hoạt dịch vụ '%s'..."
VI_MSG_SERVICE_ENABLE_SUCCESS="✅ Dịch vụ '%s' đã được kích hoạt."
VI_MSG_SERVICE_ENABLE_FAIL="❌ Kích hoạt dịch vụ '%s' thất bại."
VI_INFO_DISABLING_SERVICE="🔵 Đang vô hiệu hóa dịch vụ '%s'..."
VI_MSG_SERVICE_DISABLE_SUCCESS="✅ Dịch vụ '%s' đã được vô hiệu hóa."
VI_MSG_SERVICE_DISABLE_FAIL="❌ Vô hiệu hóa dịch vụ '%s' thất bại."

# User Management
VI_USER_MENU_HEADER="--- Menu Quản lý Người dùng ---"
VI_USER_OPT_ADD="1. Thêm Người dùng Mới"
VI_USER_OPT_DELETE="2. Xóa Người dùng"
VI_USER_OPT_ADD_SUDO="3. Thêm Người dùng vào nhóm Sudo (wheel)"
VI_USER_OPT_LIST="4. Liệt kê Tất cả Người dùng Nội bộ"
VI_USER_OPT_BACK="0. Quay lại Menu Chính"
VI_PROMPT_USERNAME_ADD="Nhập tên người dùng mới: "
VI_ERR_USERNAME_EMPTY="⚠️ Tên người dùng không được để trống."
VI_INFO_ADDING_USER="🔵 Đang thêm người dùng '%s'..."
VI_MSG_USER_ADD_SUCCESS="✅ Người dùng '%s' đã được thêm. Vui lòng đặt mật khẩu cho người dùng."
VI_MSG_USER_ADD_FAIL="❌ Thêm người dùng '%s' thất bại."
VI_PROMPT_SET_PASSWORD_NOW="Bạn có muốn đặt mật khẩu cho '%s' ngay bây giờ không? (y/N): "
VI_PROMPT_USERNAME_DELETE="Nhập tên người dùng cần xóa: "
VI_PROMPT_DELETE_USER_CONFIRM="⚠️  Bạn có chắc chắn muốn xóa người dùng '%s' và thư mục nhà của họ không? (y/N): "
VI_INFO_DELETING_USER="🔵 Đang xóa người dùng '%s'..."
VI_MSG_USER_DELETE_SUCCESS="✅ Người dùng '%s' đã được xóa."
VI_MSG_USER_DELETE_FAIL="❌ Xóa người dùng '%s' thất bại."
VI_PROMPT_USERNAME_SUDO="Nhập tên người dùng cần thêm vào nhóm sudo (wheel): "
VI_INFO_ADDING_USER_SUDO="🔵 Đang thêm người dùng '%s' vào nhóm wheel..."
VI_MSG_USER_ADD_SUDO_SUCCESS="✅ Người dùng '%s' đã được thêm vào nhóm wheel. Họ sẽ có quyền sudo ở lần đăng nhập tới."
VI_MSG_USER_ADD_SUDO_FAIL="❌ Thêm người dùng '%s' vào nhóm wheel thất bại."
VI_MSG_USER_ALREADY_SUDO="ℹ️  Người dùng '%s' đã ở trong nhóm wheel hoặc có quyền sudo."
VI_INFO_LISTING_USERS="--- Người dùng Nội bộ ---"

# Firewall Management
VI_FIREWALL_MENU_HEADER="--- Menu Quản lý Tường lửa (firewalld) ---"
VI_FIREWALL_OPT_STATUS="1. Kiểm tra Trạng thái Tường lửa"
VI_FIREWALL_OPT_ADD_SERVICE="2. Thêm Dịch vụ"
VI_FIREWALL_OPT_REMOVE_SERVICE="3. Xóa Dịch vụ"
VI_FIREWALL_OPT_ADD_PORT="4. Thêm Cổng"
VI_FIREWALL_OPT_REMOVE_PORT="5. Xóa Cổng"
VI_FIREWALL_OPT_RELOAD="6. Tải lại Tường lửa"
VI_FIREWALL_OPT_LIST_ALL="7. Liệt kê Tất cả Quy tắc & Khu vực"
VI_FIREWALL_OPT_BACK="0. Quay lại Menu Chính"
VI_INFO_FIREWALL_STATUS_HEADER="--- Trạng thái Tường lửa ---"
VI_MSG_FIREWALL_NOT_RUNNING="⚠️ Firewalld không hoạt động."
VI_PROMPT_SERVICE_FIREWALL_ADD="Nhập tên dịch vụ cần thêm (ví dụ: http, https, ssh): "
VI_ERR_SERVICE_FW_NAME_EMPTY="⚠️ Tên dịch vụ không được để trống."
VI_INFO_ADDING_SERVICE_FW="🔵 Đang thêm dịch vụ '%s' vào tường lửa (vĩnh viễn)..."
VI_MSG_SERVICE_FW_ADD_SUCCESS="✅ Dịch vụ '%s' đã được thêm. Tải lại tường lửa để áp dụng thay đổi."
VI_MSG_SERVICE_FW_ADD_FAIL="❌ Thêm dịch vụ '%s' thất bại."
VI_PROMPT_SERVICE_FIREWALL_REMOVE="Nhập tên dịch vụ cần xóa: "
VI_INFO_REMOVING_SERVICE_FW="🔵 Đang xóa dịch vụ '%s' khỏi tường lửa (vĩnh viễn)..."
VI_MSG_SERVICE_FW_REMOVE_SUCCESS="✅ Dịch vụ '%s' đã được xóa. Tải lại tường lửa để áp dụng thay đổi."
VI_MSG_SERVICE_FW_REMOVE_FAIL="❌ Xóa dịch vụ '%s' thất bại."
VI_PROMPT_PORT_FIREWALL_ADD="Nhập cổng cần thêm (ví dụ: 8080/tcp hoặc 53/udp): "
VI_ERR_PORT_FW_EMPTY_INVALID="⚠️ Cổng không được để trống và phải theo định dạng cổng/giao_thức (ví dụ: 8080/tcp)."
VI_INFO_ADDING_PORT_FW="🔵 Đang thêm cổng '%s' vào tường lửa (vĩnh viễn)..."
VI_MSG_PORT_FW_ADD_SUCCESS="✅ Cổng '%s' đã được thêm. Tải lại tường lửa để áp dụng thay đổi."
VI_MSG_PORT_FW_ADD_FAIL="❌ Thêm cổng '%s' thất bại."
VI_PROMPT_PORT_FIREWALL_REMOVE="Nhập cổng cần xóa (ví dụ: 8080/tcp): "
VI_INFO_REMOVING_PORT_FW="🔵 Đang xóa cổng '%s' khỏi tường lửa (vĩnh viễn)..."
VI_MSG_PORT_FW_REMOVE_SUCCESS="✅ Cổng '%s' đã được xóa. Tải lại tường lửa để áp dụng thay đổi."
VI_MSG_PORT_FW_REMOVE_FAIL="❌ Xóa cổng '%s' thất bại."
VI_INFO_RELOADING_FIREWALL="🔵 Đang tải lại tường lửa..."
VI_MSG_FIREWALL_RELOAD_SUCCESS="✅ Tường lửa đã được tải lại thành công."
VI_MSG_FIREWALL_RELOAD_FAIL="❌ Tải lại tường lửa thất bại."
VI_INFO_LISTING_FIREWALL_RULES="--- Cấu hình Tường lửa Hiện tại ---"


# --- HÀM LẤY CHUỖI THEO NGÔN NGỮ ---
get_string() {
  local key="$1"
  local var_name
  if [ "$SCRIPT_LANG" == "vi" ]; then
    var_name="VI_$key"
  else
    var_name="EN_$key"
  fi
  printf "%s" "${!var_name}"
}

# --- HÀM CHỌN NGÔN NGỮ ---
select_language() {
    echo "Choose your language / Chọn ngôn ngữ của bạn:"
    echo "1. English"
    echo "2. Tiếng Việt"
    local choice
    read -r -p "$(get_string "LANG_CHOICE_PROMPT")" choice < /dev/tty
    case "$choice" in
        1) SCRIPT_LANG="en" ;;
        2) SCRIPT_LANG="vi" ;;
        *) SCRIPT_LANG="en"; echo "$(get_string "LANG_INVALID_CHOICE")" ;;
    esac
    clear
}

# --- KIỂM TRA QUYỀN ROOT ---
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "$(get_string "ACCESS_DENIED")"
        echo "$(get_string "PROMPT_SUDO_RERUN")"
        exit 1
    fi
}

# --- GỌI HÀM CHỌN NGÔN NGỮ VÀ KIỂM TRA ROOT ---
select_language
check_root

# --- CÁC HÀM TIỆN ÍCH ---
press_enter_to_continue() {
    read -r -p "$(get_string "MSG_PRESS_ENTER_TO_CONTINUE")" < /dev/tty
}

# --- CÁC HÀM CHỨC NĂNG CHÍNH ---

# == 1. Thông tin Hệ thống ==
show_system_information() {
    echo "$(get_string "INFO_SYS_INFO_HEADER")"
    echo "  $(get_string "INFO_HOSTNAME") $(hostname)"
    echo "  $(get_string "INFO_OS_VERSION") $(cat /etc/almalinux-release)"
    echo "  $(get_string "INFO_KERNEL_VERSION") $(uname -r)"
    echo "  $(get_string "INFO_UPTIME") $(uptime -p)"
    echo "  $(get_string "INFO_CPU_LOAD") $(uptime | awk -F'load average:' '{ print $2 }' | sed 's/^[ \t]*//')" # Trim leading space
    echo ""
    echo "$(get_string "INFO_DISK_USAGE_HEADER")"
    df -h
    echo ""
    echo "$(get_string "INFO_MEMORY_USAGE_HEADER")"
    free -h
}

# == 2. Bảo trì Hệ thống ==
update_system() {
    echo "$(get_string "INFO_UPDATING_SYSTEM")"
    if sudo dnf update -y && sudo dnf upgrade -y; then
        echo "$(get_string "MSG_UPDATE_SUCCESS")"
    else
        echo "$(get_string "MSG_UPDATE_FAIL")"
    fi
}

install_package() {
    local pkg_name
    read -r -p "$(get_string "PROMPT_PKG_NAME_INSTALL")" pkg_name < /dev/tty
    if [ -z "$pkg_name" ]; then
        echo "$(get_string "ERR_PKG_NAME_EMPTY")"
        return
    fi
    printf "$(get_string "INFO_INSTALLING_PKG")\n" "$pkg_name"
    if sudo dnf install -y "$pkg_name"; then
        printf "$(get_string "MSG_PKG_INSTALL_SUCCESS")\n" "$pkg_name"
    else
        printf "$(get_string "MSG_PKG_INSTALL_FAIL")\n" "$pkg_name"
    fi
}

remove_package() {
    local pkg_name
    read -r -p "$(get_string "PROMPT_PKG_NAME_REMOVE")" pkg_name < /dev/tty
    if [ -z "$pkg_name" ]; then
        echo "$(get_string "ERR_PKG_NAME_EMPTY")"
        return
    fi
    printf "$(get_string "INFO_REMOVING_PKG")\n" "$pkg_name"
    if sudo dnf remove -y "$pkg_name"; then
        printf "$(get_string "MSG_PKG_REMOVE_SUCCESS")\n" "$pkg_name"
    else
        printf "$(get_string "MSG_PKG_REMOVE_FAIL")\n" "$pkg_name"
    fi
}

reboot_server() {
    read -r -p "$(get_string "PROMPT_REBOOT_CONFIRM")" confirm < /dev/tty
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        echo "$(get_string "INFO_REBOOTING")"
        sudo reboot
    else
        echo "$(get_string "MSG_REBOOT_CANCELLED")"
    fi
}

shutdown_server() {
    read -r -p "$(get_string "PROMPT_SHUTDOWN_CONFIRM")" confirm < /dev/tty
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        echo "$(get_string "INFO_SHUTTING_DOWN")"
        sudo shutdown now
    else
        echo "$(get_string "MSG_SHUTDOWN_CANCELLED")"
    fi
}

manage_system_maintenance() {
    while true; do
        clear
        echo "=============================================="
        echo "       $(get_string "MENU_CAT_SYS_MAINTENANCE")"
        echo "=============================================="
        echo "1. $(get_string "INFO_UPDATING_SYSTEM" | sed 's/🔵 Đang //; s/\.\.\. This may take a while//; s/packages//')" # Tóm tắt
        echo "2. $(get_string "PROMPT_PKG_NAME_INSTALL" | sed 's/Enter the name of the //; s/to install: //; s/: //')"
        echo "3. $(get_string "PROMPT_PKG_NAME_REMOVE" | sed 's/Enter the name of the //; s/to remove: //; s/: //')"
        echo "4. $(get_string "PROMPT_REBOOT_CONFIRM" | sed 's/⚠️  Are you sure you want to //; s/the server now? (y\/N): //; s/? (y\/N): //')"
        echo "5. $(get_string "PROMPT_SHUTDOWN_CONFIRM" | sed 's/⚠️  Are you sure you want to //; s/the server now? (y\/N): //; s/? (y\/N): //')"
        echo "0. $(get_string "SERVICE_OPT_BACK")" # Mượn chuỗi "Back to Main Menu"
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty

        case $choice in
            1) update_system ;;
            2) install_package ;;
            3) remove_package ;;
            4) reboot_server ;;
            5) shutdown_server ;;
            0) break ;;
            *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
        esac
        press_enter_to_continue
    done
}


# == 3. Quản lý Dịch vụ ==
manage_one_service() {
    local action="$1" # start, stop, restart, status, enable, disable
    local service_name
    read -r -p "$(get_string "PROMPT_SERVICE_NAME")" service_name < /dev/tty
    if [ -z "$service_name" ]; then
        echo "$(get_string "ERR_SERVICE_NAME_EMPTY")"
        return
    fi

    case "$action" in
        start)
            printf "$(get_string "INFO_STARTING_SERVICE")\n" "$service_name"
            if sudo systemctl start "$service_name"; then
                printf "$(get_string "MSG_SERVICE_START_SUCCESS")\n" "$service_name"
            else
                printf "$(get_string "MSG_SERVICE_START_FAIL")\n" "$service_name"
            fi
            ;;
        stop)
            printf "$(get_string "INFO_STOPPING_SERVICE")\n" "$service_name"
            if sudo systemctl stop "$service_name"; then
                printf "$(get_string "MSG_SERVICE_STOP_SUCCESS")\n" "$service_name"
            else
                printf "$(get_string "MSG_SERVICE_STOP_FAIL")\n" "$service_name"
            fi
            ;;
        restart)
            printf "$(get_string "INFO_RESTARTING_SERVICE")\n" "$service_name"
            if sudo systemctl restart "$service_name"; then
                printf "$(get_string "MSG_SERVICE_RESTART_SUCCESS")\n" "$service_name"
            else
                printf "$(get_string "MSG_SERVICE_RESTART_FAIL")\n" "$service_name"
            fi
            ;;
        status)
            printf "$(get_string "INFO_SERVICE_STATUS")\n" "$service_name"
            sudo systemctl status "$service_name"
            ;;
        enable)
            printf "$(get_string "INFO_ENABLING_SERVICE")\n" "$service_name"
            if sudo systemctl enable "$service_name"; then
                printf "$(get_string "MSG_SERVICE_ENABLE_SUCCESS")\n" "$service_name"
            else
                printf "$(get_string "MSG_SERVICE_ENABLE_FAIL")\n" "$service_name"
            fi
            ;;
        disable)
            printf "$(get_string "INFO_DISABLING_SERVICE")\n" "$service_name"
            if sudo systemctl disable "$service_name"; then
                printf "$(get_string "MSG_SERVICE_DISABLE_SUCCESS")\n" "$service_name"
            else
                printf "$(get_string "MSG_SERVICE_DISABLE_FAIL")\n" "$service_name"
            fi
            ;;
    esac
}

manage_services_menu() {
    while true; do
        clear
        echo "=============================================="
        echo "       $(get_string "SERVICE_MENU_HEADER")"
        echo "=============================================="
        echo "$(get_string "SERVICE_OPT_START")"
        echo "$(get_string "SERVICE_OPT_STOP")"
        echo "$(get_string "SERVICE_OPT_RESTART")"
        echo "$(get_string "SERVICE_OPT_STATUS")"
        echo "$(get_string "SERVICE_OPT_ENABLE")"
        echo "$(get_string "SERVICE_OPT_DISABLE")"
        echo "$(get_string "SERVICE_OPT_BACK")"
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty

        case $choice in
            1) manage_one_service "start" ;;
            2) manage_one_service "stop" ;;
            3) manage_one_service "restart" ;;
            4) manage_one_service "status" ;;
            5) manage_one_service "enable" ;;
            6) manage_one_service "disable" ;;
            0) break ;;
            *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
        esac
        press_enter_to_continue
    done
}

# == 4. Quản lý Người dùng ==
add_new_user() {
    local username
    read -r -p "$(get_string "PROMPT_USERNAME_ADD")" username < /dev/tty
    if [ -z "$username" ]; then
        echo "$(get_string "ERR_USERNAME_EMPTY")"
        return
    fi
    printf "$(get_string "INFO_ADDING_USER")\n" "$username"
    if sudo useradd "$username"; then
        printf "$(get_string "MSG_USER_ADD_SUCCESS")\n" "$username"
        local set_pass_now
        read -r -p "$(printf "$(get_string "PROMPT_SET_PASSWORD_NOW")" "$username")" set_pass_now < /dev/tty
        if [[ "$set_pass_now" == "y" || "$set_pass_now" == "Y" ]]; then
            sudo passwd "$username"
        fi
    else
        printf "$(get_string "MSG_USER_ADD_FAIL")\n" "$username"
    fi
}

delete_user() {
    local username
    read -r -p "$(get_string "PROMPT_USERNAME_DELETE")" username < /dev/tty
    if [ -z "$username" ]; then
        echo "$(get_string "ERR_USERNAME_EMPTY")"
        return
    fi
    if [ "$username" == "root" ]; then
        echo "⚠️  $(get_string "ERR_CANNOT_ADD_ROOT_USER" | sed 's/add/delete/g; s/to docker group//g' )" # Tái sử dụng và chỉnh sửa chuỗi
        return
    fi
    local confirm_delete
    read -r -p "$(printf "$(get_string "PROMPT_DELETE_USER_CONFIRM")" "$username")" confirm_delete < /dev/tty
    if [[ "$confirm_delete" == "y" || "$confirm_delete" == "Y" ]]; then
        printf "$(get_string "INFO_DELETING_USER")\n" "$username"
        if sudo userdel -r "$username"; then # -r to remove home directory
            printf "$(get_string "MSG_USER_DELETE_SUCCESS")\n" "$username"
        else
            printf "$(get_string "MSG_USER_DELETE_FAIL")\n" "$username"
        fi
    else
        echo "$(get_string "MSG_ACTION_CANCELLED" | sed 's/Docker uninstallation/User deletion/g')" # Tái sử dụng
    fi
}

add_user_to_sudo() {
    local username
    read -r -p "$(get_string "PROMPT_USERNAME_SUDO")" username < /dev/tty
    if [ -z "$username" ]; then
        echo "$(get_string "ERR_USERNAME_EMPTY")"
        return
    fi
    if [ "$username" == "root" ]; then
        echo "ℹ️  User 'root' already has all privileges."
        return
    fi
    if id "$username" &>/dev/null; then
        if groups "$username" | grep -q '\bwheel\b'; then
            printf "$(get_string "MSG_USER_ALREADY_SUDO")\n" "$username"
        else
            printf "$(get_string "INFO_ADDING_USER_SUDO")\n" "$username"
            if sudo usermod -aG wheel "$username"; then
                printf "$(get_string "MSG_USER_ADD_SUDO_SUCCESS")\n" "$username"
            else
                printf "$(get_string "MSG_USER_ADD_SUDO_FAIL")\n" "$username"
            fi
        fi
    else
        echo "⚠️  User '$username' does not exist."
    fi
}

list_local_users() {
    echo "$(get_string "INFO_LISTING_USERS")"
    awk -F':' '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd # UID >= 1000 for regular users
}


manage_users_menu() {
    while true; do
        clear
        echo "=============================================="
        echo "       $(get_string "USER_MENU_HEADER")"
        echo "=============================================="
        echo "$(get_string "USER_OPT_ADD")"
        echo "$(get_string "USER_OPT_DELETE")"
        echo "$(get_string "USER_OPT_ADD_SUDO")"
        echo "$(get_string "USER_OPT_LIST")"
        echo "$(get_string "SERVICE_OPT_BACK")" # Mượn chuỗi "Back to Main Menu"
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty

        case $choice in
            1) add_new_user ;;
            2) delete_user ;;
            3) add_user_to_sudo ;;
            4) list_local_users ;;
            0) break ;;
            *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
        esac
        press_enter_to_continue
    done
}

# == 5. Quản lý Tường lửa (firewalld) ==
check_firewall_status() {
    echo "$(get_string "INFO_FIREWALL_STATUS_HEADER")"
    if sudo systemctl is-active --quiet firewalld; then
        sudo firewall-cmd --state
        echo "--- $(get_string "EN_INFO_LISTING_FIREWALL_RULES" | sed 's/Current Firewall Configuration/Active Zone Details/g') ---" # Tạm
        sudo firewall-cmd --get-active-zones
        # Lấy zone mặc định nếu không có active zone cụ thể
        local default_zone
        default_zone=$(sudo firewall-cmd --get-default-zone)
        echo "Default zone: $default_zone"
        echo "Services in default zone ($default_zone):"
        sudo firewall-cmd --zone="$default_zone" --list-services
        echo "Ports in default zone ($default_zone):"
        sudo firewall-cmd --zone="$default_zone" --list-ports
    else
        echo "$(get_string "MSG_FIREWALL_NOT_RUNNING")"
    fi
}

add_firewall_service() {
    local service_name
    read -r -p "$(get_string "PROMPT_SERVICE_FIREWALL_ADD")" service_name < /dev/tty
    if [ -z "$service_name" ]; then
        echo "$(get_string "ERR_SERVICE_FW_NAME_EMPTY")"
        return
    fi
    printf "$(get_string "INFO_ADDING_SERVICE_FW")\n" "$service_name"
    if sudo firewall-cmd --permanent --add-service="$service_name"; then
        printf "$(get_string "MSG_SERVICE_FW_ADD_SUCCESS")\n" "$service_name"
    else
        printf "$(get_string "MSG_SERVICE_FW_ADD_FAIL")\n" "$service_name"
    fi
}

remove_firewall_service() {
    local service_name
    read -r -p "$(get_string "PROMPT_SERVICE_FIREWALL_REMOVE")" service_name < /dev/tty
    if [ -z "$service_name" ]; then
        echo "$(get_string "ERR_SERVICE_FW_NAME_EMPTY")" # Tái sử dụng
        return
    fi
    printf "$(get_string "INFO_REMOVING_SERVICE_FW")\n" "$service_name"
    if sudo firewall-cmd --permanent --remove-service="$service_name"; then
        printf "$(get_string "MSG_SERVICE_FW_REMOVE_SUCCESS")\n" "$service_name"
    else
        printf "$(get_string "MSG_SERVICE_FW_REMOVE_FAIL")\n" "$service_name"
    fi
}

add_firewall_port() {
    local port_proto
    read -r -p "$(get_string "PROMPT_PORT_FIREWALL_ADD")" port_proto < /dev/tty
    if [[ ! "$port_proto" =~ ^[0-9]+/(tcp|udp)$ ]]; then
        echo "$(get_string "ERR_PORT_FW_EMPTY_INVALID")"
        return
    fi
    printf "$(get_string "INFO_ADDING_PORT_FW")\n" "$port_proto"
    if sudo firewall-cmd --permanent --add-port="$port_proto"; then
        printf "$(get_string "MSG_PORT_FW_ADD_SUCCESS")\n" "$port_proto"
    else
        printf "$(get_string "MSG_PORT_FW_ADD_FAIL")\n" "$port_proto"
    fi
}

remove_firewall_port() {
    local port_proto
    read -r -p "$(get_string "PROMPT_PORT_FIREWALL_REMOVE")" port_proto < /dev/tty
     if [[ ! "$port_proto" =~ ^[0-9]+/(tcp|udp)$ ]]; then
        echo "$(get_string "ERR_PORT_FW_EMPTY_INVALID" | sed 's/add/remove/g')" # Tái sử dụng
        return
    fi
    printf "$(get_string "INFO_REMOVING_PORT_FW")\n" "$port_proto"
    if sudo firewall-cmd --permanent --remove-port="$port_proto"; then
        printf "$(get_string "MSG_PORT_FW_REMOVE_SUCCESS")\n" "$port_proto"
    else
        printf "$(get_string "MSG_PORT_FW_REMOVE_FAIL")\n" "$port_proto"
    fi
}

reload_firewall() {
    echo "$(get_string "INFO_RELOADING_FIREWALL")"
    if sudo firewall-cmd --reload; then
        echo "$(get_string "MSG_FIREWALL_RELOAD_SUCCESS")"
    else
        echo "$(get_string "MSG_FIREWALL_RELOAD_FAIL")"
    fi
}

list_firewall_rules() {
    echo "$(get_string "INFO_LISTING_FIREWALL_RULES")"
    echo "--- Active Zones ---"
    sudo firewall-cmd --get-active-zones
    echo ""
    echo "--- Default Zone ---"
    sudo firewall-cmd --get-default-zone
    echo ""
    echo "--- All Zones Configuration ---"
    sudo firewall-cmd --list-all-zones | grep -E '^[a-zA-Z]|services:|ports:' --color=never
}


manage_firewall_menu() {
     while true; do
        clear
        echo "=============================================="
        echo "       $(get_string "FIREWALL_MENU_HEADER")"
        echo "=============================================="
        echo "$(get_string "FIREWALL_OPT_STATUS")"
        echo "$(get_string "FIREWALL_OPT_ADD_SERVICE")"
        echo "$(get_string "FIREWALL_OPT_REMOVE_SERVICE")"
        echo "$(get_string "FIREWALL_OPT_ADD_PORT")"
        echo "$(get_string "FIREWALL_OPT_REMOVE_PORT")"
        echo "$(get_string "FIREWALL_OPT_RELOAD")"
        echo "$(get_string "FIREWALL_OPT_LIST_ALL")"
        echo "$(get_string "SERVICE_OPT_BACK")" # Mượn chuỗi "Back to Main Menu"
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty

        case $choice in
            1) check_firewall_status ;;
            2) add_firewall_service ;;
            3) remove_firewall_service ;;
            4) add_firewall_port ;;
            5) remove_firewall_port ;;
            6) reload_firewall ;;
            7) list_firewall_rules ;;
            0) break ;;
            *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
        esac
        press_enter_to_continue
    done
}


# --- MENU CHÍNH ---
main_menu() {
    while true; do
        clear
        echo "=============================================="
        echo "$(get_string "MAIN_MENU_HEADER")"
        echo "=============================================="
        echo "$(get_string "MENU_CAT_SYS_INFO")"
        echo "$(get_string "MENU_CAT_SYS_MAINTENANCE")"
        echo "$(get_string "MENU_CAT_SERVICE_MGMT")"
        echo "$(get_string "MENU_CAT_USER_MGMT")"
        echo "$(get_string "MENU_CAT_FIREWALL_MGMT")"
        echo ""
        echo "$(get_string "MENU_OPT_EXIT")"
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty

        case $choice in
            1) show_system_information ;;
            2) manage_system_maintenance ;;
            3) manage_services_menu ;;
            4) manage_users_menu ;;
            5) manage_firewall_menu ;;
            0) echo "$(get_string "MSG_EXITING")"; exit 0 ;;
            *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
        esac
        press_enter_to_continue
    done
}

# --- BẮT ĐẦU KỊCH BẢN ---
main_menu