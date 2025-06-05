#!/bin/bash

# Kịch bản Quản lý VPS Toàn diện (VPS All-In-One) cho AlmaLinux 8.10
# Phiên bản: 1.1 (Thêm chức năng nâng cao)
# Hỗ trợ đa ngôn ngữ: Tiếng Việt, Tiếng Anh

# --- BIẾN NGÔN NGỮ TOÀN CỤC ---
SCRIPT_LANG="en" # Mặc định là Tiếng Anh

# --- ĐỊNH NGHĨA CHUỖI VĂN BẢN (TIẾNG ANH) ---
# ... (Giữ nguyên tất cả các chuỗi EN_ đã có từ phiên bản trước) ...
EN_MAIN_MENU_HEADER="     🌟 VPS All-In-One Management Script (AlmaLinux 8.10) 🌟     " # Đã có
EN_MENU_CAT_ADVANCED_SECURITY="6. Advanced Tools & Security" # Mới

# Advanced Tools & Security Strings
EN_ADV_MENU_HEADER="--- Advanced Tools & Security Menu ---"
EN_ADV_OPT_HTOP="1. Launch htop (Interactive Process Viewer)"
EN_ADV_OPT_IFTOP="2. Launch iftop (Network Bandwidth Monitor)"
EN_ADV_OPT_SELINUX_DENIALS="3. View Recent SELinux Denials"
EN_ADV_OPT_ADD_SSH_KEY="4. Add Public SSH Key for a User"
EN_ADV_OPT_DNF_AUTOMATIC="5. Configure Automatic Security Updates (dnf-automatic)"
EN_ADV_OPT_TAR_BACKUP="6. Create Tar Backup of a Directory"
EN_ADV_OPT_MANAGE_CRON="7. Manage Cron Jobs for a User"
EN_ADV_OPT_BACK="0. Back to Main Menu" # Chung

EN_MSG_PKG_NOT_FOUND_INSTALL_PROMPT="Package '%s' not found. Do you want to install it? (y/N): "
EN_INFO_INSTALLING_PKG_FOR_TOOL="🔵 Installing '%s' to use this tool..."
EN_ERR_PKG_INSTALL_FAILED_FOR_TOOL="❌ Failed to install '%s'. Cannot proceed."
EN_INFO_LAUNCHING_HTOP="🔵 Launching htop... Press 'q' or Ctrl+C to exit htop."
EN_INFO_LAUNCHING_IFTOP="🔵 Launching iftop... Press 'q' or Ctrl+C to exit iftop. (You might need to specify an interface, e.g., iftop -i eth0)"
EN_INFO_SELINUX_DENIALS_HEADER="--- Recent SELinux Denials (via ausearch) ---"
EN_MSG_NO_SELINUX_DENIALS="✅ No recent SELinux denials found or auditd service not running/configured properly."
EN_ERR_AUSEARCH_NOT_FOUND="⚠️ 'ausearch' command not found. It is part of the 'audit' package."
EN_PROMPT_USERNAME_FOR_SSH_KEY="Enter username to add SSH key for: "
EN_PROMPT_PUBLIC_SSH_KEY="Paste the public SSH key here: "
EN_ERR_PUBLIC_KEY_EMPTY="⚠️ Public SSH key cannot be empty."
EN_INFO_CREATING_SSH_DIR="🔵 Creating .ssh directory for user '%s'..."
EN_INFO_SETTING_SSH_PERMISSIONS="🔵 Setting permissions for .ssh directory and authorized_keys file..."
EN_MSG_SSH_KEY_ADD_SUCCESS="✅ Public SSH key added successfully for user '%s'."
EN_MSG_SSH_KEY_ADD_FAIL="❌ Failed to add public SSH key for user '%s'."
EN_ERR_USER_NOT_FOUND="⚠️ User '%s' not found."
EN_INFO_CONFIGURING_DNF_AUTOMATIC="🔵 Configuring dnf-automatic for security updates..."
EN_MSG_DNF_AUTOMATIC_CONFIG_SUCCESS="✅ dnf-automatic configured for security updates. Timer enabled and started."
EN_MSG_DNF_AUTOMATIC_CONFIG_FAIL="❌ Failed to configure dnf-automatic."
EN_PROMPT_SOURCE_DIR_BACKUP="Enter the full path of the directory to backup: "
EN_PROMPT_DEST_FILE_BACKUP="Enter the full path for the destination backup file (e.g., /backup/myarchive.tar.gz): "
EN_ERR_SOURCE_DIR_NOT_EXIST="⚠️ Source directory '%s' does not exist."
EN_ERR_DEST_PATH_INVALID="⚠️ Destination path for backup is invalid or not writable."
EN_INFO_CREATING_BACKUP="🔵 Creating backup of '%s' to '%s'..."
EN_MSG_BACKUP_SUCCESS="✅ Backup created successfully: %s"
EN_MSG_BACKUP_FAIL="❌ Failed to create backup."
EN_CRON_MENU_HEADER="--- Cron Job Management for User '%s' ---"
EN_CRON_OPT_LIST="1. List Cron Jobs"
EN_CRON_OPT_ADD="2. Add New Cron Job"
EN_PROMPT_USERNAME_FOR_CRON="Enter username to manage cron jobs for (leave blank for current sudo user): "
EN_INFO_LISTING_CRON_JOBS="🔵 Cron jobs for user '%s':"
EN_MSG_NO_CRON_JOBS="ℹ️  No cron jobs found for user '%s'."
EN_PROMPT_CRON_ENTRY="Enter the full cron job line (e.g., '0 2 * * * /usr/bin/mycommand'): "
EN_ERR_CRON_ENTRY_EMPTY="⚠️ Cron job entry cannot be empty."
EN_INFO_ADDING_CRON_JOB="🔵 Adding cron job for user '%s'..."
EN_MSG_CRON_JOB_ADD_SUCCESS="✅ Cron job added successfully for user '%s'."
EN_MSG_CRON_JOB_ADD_FAIL="❌ Failed to add cron job for user '%s'."


# --- ĐỊNH NGHĨA CHUỖI VĂN BẢN (TIẾNG VIỆT) ---
# ... (Giữ nguyên tất cả các chuỗi VI_ đã có từ phiên bản trước) ...
VI_MAIN_MENU_HEADER="     🌟 Kịch Bản Quản Lý VPS Toàn Diện (AlmaLinux 8.10) 🌟     " # Đã có
VI_MENU_CAT_ADVANCED_SECURITY="6. Công cụ Nâng cao & Bảo mật" # Mới

# Advanced Tools & Security Strings
VI_ADV_MENU_HEADER="--- Menu Công cụ Nâng cao & Bảo mật ---"
VI_ADV_OPT_HTOP="1. Chạy htop (Theo dõi Tiến trình Tương tác)"
VI_ADV_OPT_IFTOP="2. Chạy iftop (Theo dõi Băng thông Mạng)"
VI_ADV_OPT_SELINUX_DENIALS="3. Xem các Từ chối SELinux Gần đây"
VI_ADV_OPT_ADD_SSH_KEY="4. Thêm Public SSH Key cho Người dùng"
VI_ADV_OPT_DNF_AUTOMATIC="5. Cấu hình Cập nhật Bảo mật Tự động (dnf-automatic)"
VI_ADV_OPT_TAR_BACKUP="6. Tạo Sao lưu Tar cho Thư mục"
VI_ADV_OPT_MANAGE_CRON="7. Quản lý Cron Jobs cho Người dùng"
VI_ADV_OPT_BACK="0. Quay lại Menu Chính" # Chung

VI_MSG_PKG_NOT_FOUND_INSTALL_PROMPT="Gói '%s' không được tìm thấy. Bạn có muốn cài đặt nó không? (y/N): "
VI_INFO_INSTALLING_PKG_FOR_TOOL="🔵 Đang cài đặt '%s' để sử dụng công cụ này..."
VI_ERR_PKG_INSTALL_FAILED_FOR_TOOL="❌ Cài đặt '%s' thất bại. Không thể tiếp tục."
VI_INFO_LAUNCHING_HTOP="🔵 Đang chạy htop... Nhấn 'q' hoặc Ctrl+C để thoát htop."
VI_INFO_LAUNCHING_IFTOP="🔵 Đang chạy iftop... Nhấn 'q' hoặc Ctrl+C để thoát iftop. (Bạn có thể cần chỉ định interface, ví dụ: iftop -i eth0)"
VI_INFO_SELINUX_DENIALS_HEADER="--- Các Từ chối SELinux Gần đây (qua ausearch) ---"
VI_MSG_NO_SELINUX_DENIALS="✅ Không tìm thấy từ chối SELinux gần đây hoặc dịch vụ auditd không chạy/cấu hình đúng."
VI_ERR_AUSEARCH_NOT_FOUND="⚠️ Lệnh 'ausearch' không tìm thấy. Nó là một phần của gói 'audit'."
VI_PROMPT_USERNAME_FOR_SSH_KEY="Nhập tên người dùng để thêm SSH key: "
VI_PROMPT_PUBLIC_SSH_KEY="Dán public SSH key vào đây: "
VI_ERR_PUBLIC_KEY_EMPTY="⚠️ Public SSH key không được để trống."
VI_INFO_CREATING_SSH_DIR="🔵 Đang tạo thư mục .ssh cho người dùng '%s'..."
VI_INFO_SETTING_SSH_PERMISSIONS="🔵 Đang thiết lập quyền cho thư mục .ssh và file authorized_keys..."
VI_MSG_SSH_KEY_ADD_SUCCESS="✅ Đã thêm public SSH key thành công cho người dùng '%s'."
VI_MSG_SSH_KEY_ADD_FAIL="❌ Thêm public SSH key cho người dùng '%s' thất bại."
VI_ERR_USER_NOT_FOUND="⚠️ Không tìm thấy người dùng '%s'."
VI_INFO_CONFIGURING_DNF_AUTOMATIC="🔵 Đang cấu hình dnf-automatic cho cập nhật bảo mật tự động..."
VI_MSG_DNF_AUTOMATIC_CONFIG_SUCCESS="✅ dnf-automatic đã được cấu hình cho cập nhật bảo mật. Timer đã được kích hoạt và bắt đầu."
VI_MSG_DNF_AUTOMATIC_CONFIG_FAIL="❌ Cấu hình dnf-automatic thất bại."
VI_PROMPT_SOURCE_DIR_BACKUP="Nhập đường dẫn đầy đủ của thư mục cần sao lưu: "
VI_PROMPT_DEST_FILE_BACKUP="Nhập đường dẫn đầy đủ cho file sao lưu đích (ví dụ: /backup/myarchive.tar.gz): "
VI_ERR_SOURCE_DIR_NOT_EXIST="⚠️ Thư mục nguồn '%s' không tồn tại."
VI_ERR_DEST_PATH_INVALID="⚠️ Đường dẫn đích cho sao lưu không hợp lệ hoặc không có quyền ghi."
VI_INFO_CREATING_BACKUP="🔵 Đang tạo bản sao lưu của '%s' tới '%s'..."
VI_MSG_BACKUP_SUCCESS="✅ Sao lưu thành công: %s"
VI_MSG_BACKUP_FAIL="❌ Tạo sao lưu thất bại."
VI_CRON_MENU_HEADER="--- Quản lý Cron Job cho Người dùng '%s' ---"
VI_CRON_OPT_LIST="1. Liệt kê Cron Jobs"
VI_CRON_OPT_ADD="2. Thêm Cron Job Mới"
VI_PROMPT_USERNAME_FOR_CRON="Nhập tên người dùng để quản lý cron jobs (để trống cho người dùng sudo hiện tại): "
VI_INFO_LISTING_CRON_JOBS="🔵 Các cron job của người dùng '%s':"
VI_MSG_NO_CRON_JOBS="ℹ️  Không tìm thấy cron job nào cho người dùng '%s'."
VI_PROMPT_CRON_ENTRY="Nhập đầy đủ dòng cron job (ví dụ: '0 2 * * * /usr/bin/mycommand'): "
VI_ERR_CRON_ENTRY_EMPTY="⚠️ Dòng cron job không được để trống."
VI_INFO_ADDING_CRON_JOB="🔵 Đang thêm cron job cho người dùng '%s'..."
VI_MSG_CRON_JOB_ADD_SUCCESS="✅ Đã thêm cron job thành công cho người dùng '%s'."
VI_MSG_CRON_JOB_ADD_FAIL="❌ Thêm cron job cho người dùng '%s' thất bại."

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

# Hàm kiểm tra và đề nghị cài đặt gói
check_and_install_pkg() {
    local pkg_name="$1"
    local tool_name="$2" # Tên công cụ để hiển thị trong thông báo
    if ! command -v "$pkg_name" &> /dev/null; then
        local confirm_install
        printf "$(get_string "MSG_PKG_NOT_FOUND_INSTALL_PROMPT")" "$tool_name"
        read -r confirm_install < /dev/tty
        if [[ "$confirm_install" == "y" || "$confirm_install" == "Y" ]]; then
            printf "$(get_string "INFO_INSTALLING_PKG_FOR_TOOL")\n" "$tool_name"
            if sudo dnf install -y "$pkg_name"; then
                echo "✅ $tool_name installed successfully." # Thông báo chung
            else
                printf "$(get_string "ERR_PKG_INSTALL_FAILED_FOR_TOOL")\n" "$tool_name"
                return 1
            fi
        else
            return 1 # Người dùng không muốn cài
        fi
    fi
    return 0
}


# --- CÁC HÀM CHỨC NĂNG CHÍNH (GIỮ NGUYÊN CÁC HÀM CŨ) ---
# ... (Toàn bộ các hàm: show_system_information, update_system, install_package, remove_package, reboot_server, shutdown_server, manage_system_maintenance, manage_one_service, manage_services_menu, add_new_user, delete_user, add_user_to_sudo, list_local_users, manage_users_menu, check_firewall_status, add_firewall_service, remove_firewall_service, add_firewall_port, remove_firewall_port, reload_firewall, list_firewall_rules, manage_firewall_menu TỪ PHIÊN BẢN TRƯỚC GIỮ NGUYÊN Ở ĐÂY) ...
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
        # Sử dụng các key đã được dịch cho tiêu đề menu con
        local title_update; title_update=$(get_string "INFO_UPDATING_SYSTEM" | sed 's/🔵 Đang //; s/\.\.\. This may take a while//; s/packages//; s/🔵 Updating //; s/\.\.\. This may take a while//; s/ system packages//')
        local title_install; title_install=$(get_string "PROMPT_PKG_NAME_INSTALL" | sed 's/Enter the name of the //; s/to install: //; s/: //; s/Nhập tên gói cần //; s/: //')
        local title_remove; title_remove=$(get_string "PROMPT_PKG_NAME_REMOVE" | sed 's/Enter the name of the //; s/to remove: //; s/: //; s/Nhập tên gói cần //; s/: //')
        local title_reboot; title_reboot=$(get_string "PROMPT_REBOOT_CONFIRM" | sed 's/⚠️  Are you sure you want to //; s/the server now? (y\/N): //; s/? (y\/N): //; s/⚠️  Bạn có chắc chắn muốn //; s/máy chủ ngay bây giờ không? (y\/N): //')
        local title_shutdown; title_shutdown=$(get_string "PROMPT_SHUTDOWN_CONFIRM" | sed 's/⚠️  Are you sure you want to //; s/the server now? (y\/N): //; s/? (y\/N): //; s/⚠️  Bạn có chắc chắn muốn //; s/máy chủ ngay bây giờ không? (y\/N): //')


        echo "       $(get_string "MENU_CAT_SYS_MAINTENANCE")"
        echo "=============================================="
        echo "1. $title_update"
        echo "2. $title_install"
        echo "3. $title_remove"
        echo "4. $title_reboot"
        echo "5. $title_shutdown"
        echo "0. $(get_string "SERVICE_OPT_BACK")"
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
    if sudo useradd "$username" -m; then # -m to create home directory
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
        # Re-use and adapt a string if possible, or define a new one
        echo "⚠️  $(get_string "ERR_CANNOT_ADD_ROOT_USER" | sed 's/add/delete/g; s/to docker group this way/this way/g' )"
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
        # Re-use and adapt a string if possible
        echo "$(get_string "MSG_UNINSTALL_CANCELLED" | sed 's/Docker uninstallation/User deletion/g')"
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
        echo "ℹ️  User 'root' already has all privileges." # Simple EN string, add VI if needed
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
        printf "$(get_string "ERR_USER_NOT_FOUND")\n" "$username" # User does not exist
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
        echo "$(get_string "SERVICE_OPT_BACK")"
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
        echo "--- $(get_string "INFO_LISTING_FIREWALL_RULES" | sed 's/Current Firewall Configuration/Active Zone Details/g' | sed 's/Cấu hình Tường lửa Hiện tại/Chi tiết Khu vực Hoạt động/g' ) ---"
        sudo firewall-cmd --get-active-zones
        local default_zone
        default_zone=$(sudo firewall-cmd --get-default-zone)
        echo "Default zone: $default_zone" # Simple EN, add VI if needed
        echo "Services in default zone ($default_zone):" # Simple EN
        sudo firewall-cmd --zone="$default_zone" --list-services
        echo "Ports in default zone ($default_zone):" # Simple EN
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
        echo "$(get_string "ERR_SERVICE_FW_NAME_EMPTY")"
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
        echo "$(get_string "ERR_PORT_FW_EMPTY_INVALID" | sed 's/add/remove/g')"
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
    echo "--- Active Zones ---" # Simple EN
    sudo firewall-cmd --get-active-zones
    echo ""
    echo "--- Default Zone ---" # Simple EN
    sudo firewall-cmd --get-default-zone
    echo ""
    echo "--- All Zones Configuration (Services & Ports) ---" # Simple EN
    # This provides a more readable output than --list-all-zones directly for services/ports
    for zone in $(sudo firewall-cmd --get-zones); do
        echo "Zone: $zone"
        echo "  Services: $(sudo firewall-cmd --zone="$zone" --list-services)"
        echo "  Ports: $(sudo firewall-cmd --zone="$zone" --list-ports)"
        echo "  Interfaces: $(sudo firewall-cmd --zone="$zone" --list-interfaces)"
        echo "  Sources: $(sudo firewall-cmd --zone="$zone" --list-sources)"
        echo "----"
    done
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
        echo "$(get_string "SERVICE_OPT_BACK")"
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

# --- CÁC HÀM CHỨC NĂNG NÂNG CAO MỚI ---

# 6.1 Chạy htop
run_htop() {
    if check_and_install_pkg "htop" "htop"; then
        echo "$(get_string "INFO_LAUNCHING_HTOP")"
        htop # htop is interactive, user exits it
    fi
}

# 6.2 Chạy iftop
run_iftop() {
    if check_and_install_pkg "iftop" "iftop"; then
        echo "$(get_string "INFO_LAUNCHING_IFTOP")"
        sudo iftop # iftop usually needs root and can be interactive
    fi
}

# 6.3 Xem từ chối SELinux
view_selinux_denials() {
    echo "$(get_string "INFO_SELINUX_DENIALS_HEADER")"
    if ! command -v ausearch &> /dev/null; then
        echo "$(get_string "ERR_AUSEARCH_NOT_FOUND")"
        if check_and_install_pkg "audit" "audit (for ausearch)"; then
             echo "ℹ️ Please try running this option again." # Simple EN
        fi
        return
    fi
    # -i for interpreted mode (human-readable)
    # -ts recent for recent entries (e.g., last 10 minutes, or specific time)
    # We use a simple check for any output.
    if sudo ausearch -m avc -m user_avc -m selinux_err -m user_selinux_err -ts recent -i --just-one &>/dev/null; then
      sudo ausearch -m avc -m user_avc -m selinux_err -m user_selinux_err -ts recent -i | less
    else
      echo "$(get_string "MSG_NO_SELINUX_DENIALS")"
    fi
}

# 6.4 Thêm Public SSH Key
add_public_ssh_key() {
    local username
    local pub_key
    local user_home
    local ssh_dir
    local auth_keys_file

    read -r -p "$(get_string "PROMPT_USERNAME_FOR_SSH_KEY")" username < /dev/tty
    if [ -z "$username" ]; then
        echo "$(get_string "ERR_USERNAME_EMPTY")"; return
    fi

    if ! id "$username" &>/dev/null; then
        printf "$(get_string "ERR_USER_NOT_FOUND")\n" "$username"
        return
    fi
    user_home=$(eval echo "~$username")

    echo "$(get_string "PROMPT_PUBLIC_SSH_KEY")"
    read -r pub_key < /dev/tty # Read the key
    if [ -z "$pub_key" ]; then
        echo "$(get_string "ERR_PUBLIC_KEY_EMPTY")"; return
    fi

    ssh_dir="$user_home/.ssh"
    auth_keys_file="$ssh_dir/authorized_keys"

    if [ ! -d "$ssh_dir" ]; then
        printf "$(get_string "INFO_CREATING_SSH_DIR")\n" "$username"
        sudo mkdir -p "$ssh_dir"
        if [ $? -ne 0 ]; then printf "$(get_string "MSG_SSH_KEY_ADD_FAIL")\n" "$username"; return; fi
        sudo chown "$username":"$username" "$ssh_dir"
        sudo chmod 700 "$ssh_dir"
    fi

    echo "$pub_key" | sudo tee -a "$auth_keys_file" > /dev/null
    if [ $? -eq 0 ]; then
        printf "$(get_string "INFO_SETTING_SSH_PERMISSIONS")\n"
        sudo chown "$username":"$username" "$auth_keys_file"
        sudo chmod 600 "$auth_keys_file"
        printf "$(get_string "MSG_SSH_KEY_ADD_SUCCESS")\n" "$username"
    else
        printf "$(get_string "MSG_SSH_KEY_ADD_FAIL")\n" "$username"
    fi
}

# 6.5 Cấu hình dnf-automatic
configure_dnf_automatic() {
    echo "$(get_string "INFO_CONFIGURING_DNF_AUTOMATIC")"
    if ! command -v dnf-automatic &> /dev/null; then
      if ! check_and_install_pkg "dnf-automatic" "dnf-automatic"; then
        return
      fi
    fi

    # Configure /etc/dnf/automatic.conf
    # A simple approach: ensure apply_updates = yes and upgrade_type = security
    # More robust would be to check if lines exist first.
    if sudo grep -q "^apply_updates = yes" /etc/dnf/automatic.conf; then
        echo "ℹ️ apply_updates is already set to yes." # Simple EN
    else
        sudo sed -i 's/^apply_updates = .*/apply_updates = yes/' /etc/dnf/automatic.conf
        # If not found, append it under [commands] section, crude but often works
        if ! sudo grep -q "^apply_updates = yes" /etc/dnf/automatic.conf; then
             sudo sed -i '/^\[commands\]/a apply_updates = yes' /etc/dnf/automatic.conf
        fi
    fi

    if sudo grep -q "^upgrade_type = security" /etc/dnf/automatic.conf; then
        echo "ℹ️ upgrade_type is already set to security." # Simple EN
    else
        sudo sed -i 's/^upgrade_type = .*/upgrade_type = security/' /etc/dnf/automatic.conf
        if ! sudo grep -q "^upgrade_type = security" /etc/dnf/automatic.conf; then
            sudo sed -i '/^\[commands\]/a upgrade_type = security' /etc/dnf/automatic.conf
        fi
    fi
    
    # Ensure download_updates is also yes
    if sudo grep -q "^download_updates = yes" /etc/dnf/automatic.conf; then
        echo "ℹ️ download_updates is already set to yes." # Simple EN
    else
        sudo sed -i 's/^download_updates = .*/download_updates = yes/' /etc/dnf/automatic.conf
        if ! sudo grep -q "^download_updates = yes" /etc/dnf/automatic.conf; then
            sudo sed -i '/^\[commands\]/a download_updates = yes' /etc/dnf/automatic.conf
        fi
    fi


    if sudo systemctl enable --now dnf-automatic.timer; then
        echo "$(get_string "MSG_DNF_AUTOMATIC_CONFIG_SUCCESS")"
    else
        echo "$(get_string "MSG_DNF_AUTOMATIC_CONFIG_FAIL")"
    fi
}

# 6.6 Sao lưu Tar
create_tar_backup() {
    local source_dir
    local dest_file
    read -r -p "$(get_string "PROMPT_SOURCE_DIR_BACKUP")" source_dir < /dev/tty
    if [ -z "$source_dir" ]; then echo "$(get_string "ERR_PKG_NAME_EMPTY" | sed 's/Package name/Source directory/g')"; return; fi # Re-use
    if [ ! -d "$source_dir" ]; then
        printf "$(get_string "ERR_SOURCE_DIR_NOT_EXIST")\n" "$source_dir"
        return
    fi

    read -r -p "$(get_string "PROMPT_DEST_FILE_BACKUP")" dest_file < /dev/tty
    if [ -z "$dest_file" ]; then echo "$(get_string "ERR_PKG_NAME_EMPTY" | sed 's/Package name/Destination file/g')"; return; fi # Re-use

    local dest_dir
    dest_dir=$(dirname "$dest_file")
    if [ ! -d "$dest_dir" ] || [ ! -w "$dest_dir" ]; then # Check if dir exists and is writable
        # A more robust check: sudo -u "$(stat -c %U "$dest_dir")" test -w "$dest_dir"
        # For simplicity, just check if the script (running as root) can write.
        # This might not be enough if the path itself is invalid.
        if ! sudo touch "$dest_dir/.tmp_write_test" 2>/dev/null ; then
             echo "$(get_string "ERR_DEST_PATH_INVALID")"
             return
        else
             sudo rm -f "$dest_dir/.tmp_write_test"
        fi
    fi


    printf "$(get_string "INFO_CREATING_BACKUP")\n" "$source_dir" "$dest_file"
    if sudo tar -czvf "$dest_file" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"; then
    # Using -C to change directory helps avoid leading paths in tar if source_dir is absolute
    # Example: if source_dir is /var/www/html, tar will store www/html/*
    # A simpler tar: sudo tar -czvf "$dest_file" "$source_dir"
    # Using the simpler tar for now to avoid complexity with basename/dirname if path ends with /
    # if sudo tar -czvf "$dest_file" "$source_dir"; then
        printf "$(get_string "MSG_BACKUP_SUCCESS")\n" "$dest_file"
        ls -lh "$dest_file"
    else
        echo "$(get_string "MSG_BACKUP_FAIL")"
    fi
}

# 6.7 Quản lý Cron
manage_user_cron_jobs() {
    local username
    local current_script_user=${SUDO_USER:-$(whoami)} # User running this script

    read -r -p "$(get_string "PROMPT_USERNAME_FOR_CRON")" username < /dev/tty
    if [ -z "$username" ]; then
        username="$current_script_user"
    fi
    
    if [ "$username" == "root" ] && [ "$current_script_user" != "root" ]; then
        echo "⚠️ Managing root's cron jobs directly is powerful. Ensure you know what you are doing."
    elif ! id "$username" &>/dev/null; then
        printf "$(get_string "ERR_USER_NOT_FOUND")\n" "$username"
        return
    fi

    while true; do
        clear
        printf "$(get_string "CRON_MENU_HEADER")\n" "$username"
        echo "=============================================="
        echo "$(get_string "CRON_OPT_LIST")"
        echo "$(get_string "CRON_OPT_ADD")"
        echo "$(get_string "SERVICE_OPT_BACK")" # Re-use "Back" string
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty

        case $choice in
            1) # List cron jobs
                printf "$(get_string "INFO_LISTING_CRON_JOBS")\n" "$username"
                if sudo crontab -l -u "$username" 2>/dev/null; then
                    : # Output is already on stdout
                else
                    printf "$(get_string "MSG_NO_CRON_JOBS")\n" "$username"
                fi
                ;;
            2) # Add cron job
                local cron_entry
                read -r -p "$(get_string "PROMPT_CRON_ENTRY")" cron_entry < /dev/tty
                if [ -z "$cron_entry" ]; then
                    echo "$(get_string "ERR_CRON_ENTRY_EMPTY")"
                else
                    printf "$(get_string "INFO_ADDING_CRON_JOB")\n" "$username"
                    # This is a common way to add a job without overwriting existing ones
                    # It redirects stderr to /dev/null for crontab -l if no crontab exists
                    if (sudo crontab -l -u "$username" 2>/dev/null; echo "$cron_entry") | sudo crontab -u "$username" - ; then
                        printf "$(get_string "MSG_CRON_JOB_ADD_SUCCESS")\n" "$username"
                    else
                        printf "$(get_string "MSG_CRON_JOB_ADD_FAIL")\n" "$username"
                    fi
                fi
                ;;
            0) break;;
            *) echo "$(get_string "ERR_INVALID_OPTION")";;
        esac
        press_enter_to_continue
    done
}


manage_advanced_security_menu() {
    while true; do
        clear
        echo "=============================================="
        echo "       $(get_string "ADV_MENU_HEADER")"
        echo "=============================================="
        echo "$(get_string "ADV_OPT_HTOP")"
        echo "$(get_string "ADV_OPT_IFTOP")"
        echo "$(get_string "ADV_OPT_SELINUX_DENIALS")"
        echo "$(get_string "ADV_OPT_ADD_SSH_KEY")"
        echo "$(get_string "ADV_OPT_DNF_AUTOMATIC")"
        echo "$(get_string "ADV_OPT_TAR_BACKUP")"
        echo "$(get_string "ADV_OPT_MANAGE_CRON")"
        echo "$(get_string "ADV_OPT_BACK")"
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty

        case $choice in
            1) run_htop ;;
            2) run_iftop ;;
            3) view_selinux_denials ;;
            4) add_public_ssh_key ;;
            5) configure_dnf_automatic ;;
            6) create_tar_backup ;;
            7) manage_user_cron_jobs ;;
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
        echo "$(get_string "MENU_CAT_ADVANCED_SECURITY")" # Mục menu mới
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
            6) manage_advanced_security_menu ;; # Gọi menu con mới
            0) echo "$(get_string "MSG_EXITING")"; exit 0 ;;
            *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
        esac
        press_enter_to_continue
    done
}

# --- BẮT ĐẦU KỊCH BẢN ---
main_menu