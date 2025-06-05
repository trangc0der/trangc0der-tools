#!/bin/bash

# Kịch bản WordPress All-In-One cho AlmaLinux 8.10
# Phiên bản: 1.0
# Hỗ trợ đa ngôn ngữ: Tiếng Việt, Tiếng Anh

# --- BIẾN NGÔN NGỮ TOÀN CỤC ---
SCRIPT_LANG="en" # Mặc định là Tiếng Anh
WEB_USER="nginx" # Người dùng mà Nginx chạy (và WordPress files nên thuộc sở hữu)
WEB_GROUP="nginx"

# --- ĐỊNH NGHĨA CHUỖI VĂN BẢN (TIẾNG ANH) ---
EN_ACCESS_DENIED="ERROR: This script must be run with root or sudo privileges."
EN_PROMPT_SUDO_RERUN="Please try again with: sudo \$0"
EN_LANG_CHOICE_PROMPT="Enter your choice (1-2): "
EN_LANG_INVALID_CHOICE="Invalid choice, defaulting to English."

EN_MAIN_MENU_HEADER="     🛠️ WordPress All-In-One Toolkit (AlmaLinux 8.10) 🛠️     "
EN_MENU_OPT_LEMP_SETUP="1. Setup LEMP Stack (Nginx, MariaDB, PHP)"
EN_MENU_OPT_WPCLI_MGMT="2. Manage WP-CLI (WordPress Command Line Interface)"
EN_MENU_OPT_NEW_WP_SITE="3. Install New WordPress Site"
EN_MENU_OPT_BACKUP_WP_SITE="4. Backup WordPress Site"
EN_MENU_OPT_RESTORE_WP_SITE="5. Restore WordPress Site"
EN_MENU_OPT_UPDATE_WP="6. Update WordPress (Core, Plugins, Themes)"
EN_MENU_OPT_MAINTENANCE_MODE="7. Manage Maintenance Mode"
EN_MENU_OPT_RUN_WPCLI_CMD="8. Run Custom WP-CLI Command"
EN_MENU_OPT_SETUP_SSL="9. Setup SSL with Let's Encrypt (Certbot)"
EN_MENU_OPT_DELETE_WP_SITE="10. Delete WordPress Site (USE WITH CAUTION!)"
EN_MENU_OPT_EXIT="0. Exit"
EN_PROMPT_ENTER_CHOICE="Please select an option: "
EN_ERR_INVALID_OPTION="⚠️  Invalid option. Please try again."
EN_MSG_PRESS_ENTER_TO_CONTINUE="Press Enter to continue..."
EN_MSG_EXITING="👋  Exiting WordPress Toolkit!"
EN_MSG_FEATURE_NOT_FULLY_IMPLEMENTED="ℹ️ This feature is planned. Stay tuned for updates." # Placeholder

# LEMP Setup
EN_INFO_INSTALLING_LEMP="🔵 Installing LEMP Stack (Nginx, MariaDB, PHP)... This may take some time."
EN_INFO_NGINX_INSTALLED="Nginx installed and enabled."
EN_INFO_MARIADB_INSTALLED="MariaDB installed and enabled. Remember to run 'sudo mysql_secure_installation'."
EN_INFO_PHP_INSTALLED="PHP (with FPM and extensions) installed and configured for Nginx."
EN_MSG_LEMP_INSTALL_SUCCESS="✅ LEMP Stack installation completed."
EN_MSG_LEMP_INSTALL_FAIL="❌ LEMP Stack installation failed or some components failed."
EN_PROMPT_PHP_VERSION="Select PHP version to install (e.g., 8.0, 8.1, 8.2 - check availability for AlmaLinux 8): Default [8.1]: "

# WP-CLI
EN_WPCLI_MENU_HEADER="--- WP-CLI Management ---"
EN_WPCLI_OPT_INSTALL="1. Install/Update WP-CLI"
EN_WPCLI_OPT_CHECK_VERSION="2. Check WP-CLI Version"
EN_WPCLI_OPT_UNINSTALL="3. Uninstall WP-CLI"
EN_WPCLI_OPT_BACK="0. Back to Main Menu"
EN_INFO_INSTALLING_WPCLI="🔵 Installing/Updating WP-CLI to /usr/local/bin/wp..."
EN_MSG_WPCLI_INSTALL_SUCCESS="✅ WP-CLI installed/updated successfully."
EN_MSG_WPCLI_INSTALL_FAIL="❌ Failed to install/update WP-CLI."
EN_MSG_WPCLI_NOT_INSTALLED="⚠️ WP-CLI is not installed. Please install it first."
EN_INFO_UNINSTALLING_WPCLI="🔵 Uninstalling WP-CLI..."
EN_MSG_WPCLI_UNINSTALL_SUCCESS="✅ WP-CLI uninstalled successfully."
EN_MSG_WPCLI_UNINSTALL_FAIL="❌ Failed to uninstall WP-CLI (or it was not found)."

# WordPress Install
EN_PROMPT_DOMAIN_NAME="Enter domain name for the new WordPress site (e.g., example.com): "
EN_ERR_DOMAIN_EMPTY="⚠️ Domain name cannot be empty."
EN_PROMPT_WP_PATH="Enter the full web root path for this site (e.g., /var/www/example.com): "
EN_ERR_WP_PATH_EMPTY="⚠️ WordPress path cannot be empty."
EN_ERR_WP_PATH_EXISTS="⚠️ Path '%s' already exists. Please choose a different path or delete existing."
EN_PROMPT_DB_NAME="Enter database name for WordPress (e.g., wp_example): "
EN_PROMPT_DB_USER="Enter database user for WordPress (e.g., wp_user): "
EN_PROMPT_DB_PASS="Enter database password for WordPress user (leave blank for auto-generated): "
EN_INFO_GENERATING_DB_PASS="ℹ️ Auto-generating a strong database password."
EN_INFO_CREATING_DB="🔵 Creating MariaDB database '%s' and user '%s'..."
EN_MSG_DB_CREATE_SUCCESS="✅ Database and user created successfully."
EN_MSG_DB_PASS_GENERATED="   Generated DB Password: %s (SAVE THIS SECURELY!)"
EN_MSG_DB_CREATE_FAIL="❌ Failed to create database or user."
EN_INFO_DOWNLOADING_WP="🔵 Downloading latest WordPress core files..."
EN_MSG_WP_DOWNLOAD_SUCCESS="✅ WordPress downloaded successfully."
EN_MSG_WP_DOWNLOAD_FAIL="❌ Failed to download WordPress."
EN_INFO_CONFIGURING_WP="🔵 Configuring wp-config.php..."
EN_MSG_WP_CONFIG_SUCCESS="✅ wp-config.php configured successfully."
EN_MSG_WP_CONFIG_FAIL="❌ Failed to configure wp-config.php."
EN_INFO_SETTING_PERMISSIONS="🔵 Setting file and directory permissions for WordPress..."
EN_INFO_CONFIGURING_NGINX="🔵 Configuring Nginx server block for %s..."
EN_MSG_NGINX_CONFIG_SUCCESS="✅ Nginx server block created for %s. Please point your domain's DNS to this server's IP."
EN_MSG_NGINX_CONFIG_FAIL="❌ Failed to create Nginx server block for %s."
EN_MSG_WP_INSTALL_COMPLETE_TITLE="🎉 WordPress Installation Complete for %s! 🎉"
EN_MSG_WP_INSTALL_COMPLETE_NEXT_STEPS="   Next steps:"
EN_MSG_WP_INSTALL_COMPLETE_DNS="   1. Ensure your domain '%s' points to this server's IP address: %s"
EN_MSG_WP_INSTALL_COMPLETE_BROWSER="   2. Open http://%s in your browser to complete the WordPress setup (language, site title, admin user)."
EN_MSG_WP_INSTALL_COMPLETE_SSL="   3. Consider setting up SSL using option 9 in the main menu."

# Backup & Restore
EN_PROMPT_SITE_PATH_BACKUP="Enter the full web root path of the WordPress site to backup: "
EN_PROMPT_BACKUP_DIR="Enter the directory path to store backups (e.g., /var/backups/wordpress): "
EN_ERR_SITE_PATH_NOT_WP="⚠️ Path '%s' does not appear to be a WordPress installation (wp-config.php not found)."
EN_INFO_CREATING_BACKUP_FILES="🔵 Backing up WordPress files for '%s'..."
EN_INFO_CREATING_BACKUP_DB="🔵 Backing up WordPress database for '%s'..."
EN_MSG_BACKUP_SUCCESS="✅ Backup for '%s' completed successfully. Files are in: %s"
EN_MSG_BACKUP_FAIL="❌ Backup for '%s' failed."
EN_PROMPT_BACKUP_FILE_FILES_RESTORE="Enter the full path to the WordPress files backup (.tar.gz): "
EN_PROMPT_BACKUP_FILE_DB_RESTORE="Enter the full path to the WordPress database backup (.sql or .sql.gz): "
EN_PROMPT_SITE_PATH_RESTORE="Enter the full web root path of the WordPress site to restore to: "
EN_PROMPT_RESTORE_CONFIRM="⚠️  This will overwrite existing files and database for the site at '%s'. Are you sure? (y/N): "
EN_INFO_RESTORING_FILES="🔵 Restoring WordPress files to '%s'..."
EN_INFO_RESTORING_DB="🔵 Restoring WordPress database..."
EN_MSG_RESTORE_SUCCESS="✅ WordPress site at '%s' restored successfully."
EN_MSG_RESTORE_FAIL="❌ WordPress site restoration failed."

# Update WP
EN_UPDATE_WP_MENU_HEADER="--- WordPress Update Menu ---"
EN_UPDATE_OPT_CORE="1. Update WordPress Core"
EN_UPDATE_OPT_ALL_PLUGINS="2. Update All Plugins"
EN_UPDATE_OPT_ALL_THEMES="3. Update All Themes"
EN_PROMPT_SITE_PATH_FOR_WPCLI="Enter the WordPress site path for WP-CLI commands: "
EN_INFO_UPDATING_WP_CORE="🔵 Updating WordPress Core for site at '%s'..."
EN_INFO_UPDATING_ALL_PLUGINS="🔵 Updating all plugins for site at '%s'..."
EN_INFO_UPDATING_ALL_THEMES="🔵 Updating all themes for site at '%s'..."
EN_MSG_WPCLI_SUCCESS="✅ WP-CLI command executed successfully."
EN_MSG_WPCLI_FAIL="❌ WP-CLI command failed."

# Maintenance Mode
EN_PROMPT_MAINTENANCE_ACTION="Select action: (1 for Enable, 2 for Disable): "
EN_INFO_ENABLING_MAINTENANCE="🔵 Enabling maintenance mode for site at '%s'..."
EN_INFO_DISABLING_MAINTENANCE="🔵 Disabling maintenance mode for site at '%s'..."
EN_MSG_MAINTENANCE_ENABLED="✅ Maintenance mode enabled."
EN_MSG_MAINTENANCE_DISABLED="✅ Maintenance mode disabled."

# Run WP-CLI
EN_PROMPT_WPCLI_COMMAND="Enter the WP-CLI command to run (e.g., 'plugin list --status=active'): "
EN_INFO_RUNNING_WPCLI_COMMAND="🔵 Running WP-CLI command for site at '%s': wp %s"

# SSL (Certbot)
EN_INFO_INSTALLING_CERTBOT="🔵 Installing Certbot and Nginx plugin..."
EN_MSG_CERTBOT_INSTALL_SUCCESS="✅ Certbot installed successfully."
EN_MSG_CERTBOT_INSTALL_FAIL="❌ Failed to install Certbot."
EN_PROMPT_DOMAIN_FOR_SSL="Enter the domain name for SSL setup (must be live and pointing to this server): "
EN_PROMPT_EMAIL_FOR_SSL="Enter your email address for Let's Encrypt registration and recovery: "
EN_INFO_REQUESTING_SSL_CERT="🔵 Requesting SSL certificate for %s via Certbot..."
EN_MSG_SSL_SETUP_SUCCESS="✅ SSL certificate obtained and configured for %s successfully!"
EN_MSG_SSL_SETUP_FAIL="❌ SSL certificate setup failed for %s."

# Delete WP
EN_PROMPT_SITE_PATH_DELETE="Enter the full web root path of the WordPress site to DELETE: "
EN_PROMPT_DELETE_WP_CONFIRM1="⚠️  EXTREME CAUTION! This will PERMANENTLY DELETE all files for the site at '%s'."
EN_PROMPT_DELETE_WP_CONFIRM2="   It will also attempt to delete the Nginx config and the associated database and user."
EN_PROMPT_DELETE_WP_CONFIRM3="   There is NO UNDO. Type 'YESIDOITTODELETE' to confirm: " # Extra confirmation
EN_INFO_DELETING_WP_FILES="🔵 Deleting WordPress files at '%s'..."
EN_INFO_DELETING_NGINX_CONF="🔵 Deleting Nginx configuration for the site..."
EN_INFO_DELETING_DB_USER="🔵 Deleting database '%s' and user '%s'..."
EN_MSG_WP_DELETE_COMPLETE="✅ WordPress site '%s' has been deleted."
EN_MSG_WP_DELETE_ABORTED="ℹ️  WordPress site deletion aborted."


# --- ĐỊNH NGHĨA CHUỖI VĂN BẢN (TIẾNG VIỆT) ---
VI_ACCESS_DENIED="⚠️  LỖI: Kịch bản này cần được chạy với quyền root hoặc sudo."
VI_PROMPT_SUDO_RERUN="Vui lòng chạy lại với lệnh: sudo \$0"
VI_LANG_CHOICE_PROMPT="Nhập lựa chọn của bạn (1-2): "
VI_LANG_INVALID_CHOICE="Lựa chọn không hợp lệ, mặc định Tiếng Anh."

VI_MAIN_MENU_HEADER="     🛠️ Bộ Công Cụ WordPress Toàn Diện (AlmaLinux 8.10) 🛠️     "
VI_MENU_OPT_LEMP_SETUP="1. Cài đặt LEMP Stack (Nginx, MariaDB, PHP)"
VI_MENU_OPT_WPCLI_MGMT="2. Quản lý WP-CLI (Giao diện dòng lệnh WordPress)"
VI_MENU_OPT_NEW_WP_SITE="3. Cài đặt Trang WordPress Mới"
VI_MENU_OPT_BACKUP_WP_SITE="4. Sao lưu Trang WordPress"
VI_MENU_OPT_RESTORE_WP_SITE="5. Phục hồi Trang WordPress"
VI_MENU_OPT_UPDATE_WP="6. Cập nhật WordPress (Core, Plugins, Themes)"
VI_MENU_OPT_MAINTENANCE_MODE="7. Quản lý Chế độ Bảo trì"
VI_MENU_OPT_RUN_WPCLI_CMD="8. Chạy Lệnh WP-CLI Tùy chỉnh"
VI_MENU_OPT_SETUP_SSL="9. Cài đặt SSL với Let's Encrypt (Certbot)"
VI_MENU_OPT_DELETE_WP_SITE="10. Xóa Trang WordPress (CẨN THẬN TUYỆT ĐỐI!)"
VI_MENU_OPT_EXIT="0. Thoát"
VI_PROMPT_ENTER_CHOICE="Vui lòng chọn một tùy chọn: "
VI_ERR_INVALID_OPTION="⚠️  Lựa chọn không hợp lệ. Vui lòng thử lại."
VI_MSG_PRESS_ENTER_TO_CONTINUE="Nhấn Enter để tiếp tục..."
VI_MSG_EXITING="👋  Thoát Bộ công cụ WordPress!"
VI_MSG_FEATURE_NOT_FULLY_IMPLEMENTED="ℹ️ Tính năng này đang được lên kế hoạch. Vui lòng chờ cập nhật." # Placeholder

# LEMP Setup
VI_INFO_INSTALLING_LEMP="🔵 Đang cài đặt LEMP Stack (Nginx, MariaDB, PHP)... Việc này có thể mất một lúc."
VI_INFO_NGINX_INSTALLED="Nginx đã được cài đặt và kích hoạt."
VI_INFO_MARIADB_INSTALLED="MariaDB đã được cài đặt và kích hoạt. Hãy nhớ chạy 'sudo mysql_secure_installation'."
VI_INFO_PHP_INSTALLED="PHP (với FPM và các extension) đã được cài đặt và cấu hình cho Nginx."
VI_MSG_LEMP_INSTALL_SUCCESS="✅ Cài đặt LEMP Stack hoàn tất."
VI_MSG_LEMP_INSTALL_FAIL="❌ Cài đặt LEMP Stack thất bại hoặc một số thành phần bị lỗi."
VI_PROMPT_PHP_VERSION="Chọn phiên bản PHP để cài đặt (ví dụ: 8.0, 8.1, 8.2 - kiểm tra tính khả dụng cho AlmaLinux 8): Mặc định [8.1]: "

# WP-CLI
VI_WPCLI_MENU_HEADER="--- Quản lý WP-CLI ---"
VI_WPCLI_OPT_INSTALL="1. Cài đặt/Cập nhật WP-CLI"
VI_WPCLI_OPT_CHECK_VERSION="2. Kiểm tra Phiên bản WP-CLI"
VI_WPCLI_OPT_UNINSTALL="3. Gỡ cài đặt WP-CLI"
VI_WPCLI_OPT_BACK="0. Quay lại Menu Chính"
VI_INFO_INSTALLING_WPCLI="🔵 Đang cài đặt/cập nhật WP-CLI vào /usr/local/bin/wp..."
VI_MSG_WPCLI_INSTALL_SUCCESS="✅ WP-CLI đã được cài đặt/cập nhật thành công."
VI_MSG_WPCLI_INSTALL_FAIL="❌ Cài đặt/cập nhật WP-CLI thất bại."
VI_MSG_WPCLI_NOT_INSTALLED="⚠️ WP-CLI chưa được cài đặt. Vui lòng cài đặt trước."
VI_INFO_UNINSTALLING_WPCLI="🔵 Đang gỡ cài đặt WP-CLI..."
VI_MSG_WPCLI_UNINSTALL_SUCCESS="✅ WP-CLI đã được gỡ cài đặt thành công."
VI_MSG_WPCLI_UNINSTALL_FAIL="❌ Gỡ cài đặt WP-CLI thất bại (hoặc không tìm thấy)."

# WordPress Install
VI_PROMPT_DOMAIN_NAME="Nhập tên miền cho trang WordPress mới (ví dụ: example.com): "
VI_ERR_DOMAIN_EMPTY="⚠️ Tên miền không được để trống."
VI_PROMPT_WP_PATH="Nhập đường dẫn web root đầy đủ cho trang này (ví dụ: /var/www/example.com): "
VI_ERR_WP_PATH_EMPTY="⚠️ Đường dẫn WordPress không được để trống."
VI_ERR_WP_PATH_EXISTS="⚠️ Đường dẫn '%s' đã tồn tại. Vui lòng chọn đường dẫn khác hoặc xóa cái hiện có."
VI_PROMPT_DB_NAME="Nhập tên database cho WordPress (ví dụ: wp_example): "
VI_PROMPT_DB_USER="Nhập user database cho WordPress (ví dụ: wp_user): "
VI_PROMPT_DB_PASS="Nhập mật khẩu database cho user WordPress (để trống để tự động tạo): "
VI_INFO_GENERATING_DB_PASS="ℹ️ Đang tự động tạo mật khẩu database mạnh."
VI_INFO_CREATING_DB="🔵 Đang tạo database MariaDB '%s' và user '%s'..."
VI_MSG_DB_CREATE_SUCCESS="✅ Database và user đã được tạo thành công."
VI_MSG_DB_PASS_GENERATED="   Mật khẩu DB được tạo: %s (LƯU LẠI CẨN THẬN!)"
VI_MSG_DB_CREATE_FAIL="❌ Tạo database hoặc user thất bại."
VI_INFO_DOWNLOADING_WP="🔵 Đang tải xuống phiên bản WordPress mới nhất..."
VI_MSG_WP_DOWNLOAD_SUCCESS="✅ Tải xuống WordPress thành công."
VI_MSG_WP_DOWNLOAD_FAIL="❌ Tải xuống WordPress thất bại."
VI_INFO_CONFIGURING_WP="🔵 Đang cấu hình wp-config.php..."
VI_MSG_WP_CONFIG_SUCCESS="✅ wp-config.php đã được cấu hình thành công."
VI_MSG_WP_CONFIG_FAIL="❌ Cấu hình wp-config.php thất bại."
VI_INFO_SETTING_PERMISSIONS="🔵 Đang thiết lập quyền cho file và thư mục WordPress..."
VI_INFO_CONFIGURING_NGINX="🔵 Đang cấu hình Nginx server block cho %s..."
VI_MSG_NGINX_CONFIG_SUCCESS="✅ Nginx server block đã được tạo cho %s. Vui lòng trỏ DNS của tên miền về IP của máy chủ này."
VI_MSG_NGINX_CONFIG_FAIL="❌ Tạo Nginx server block cho %s thất bại."
VI_MSG_WP_INSTALL_COMPLETE_TITLE="🎉 Cài đặt WordPress cho %s Hoàn tất! 🎉"
VI_MSG_WP_INSTALL_COMPLETE_NEXT_STEPS="   Các bước tiếp theo:"
VI_MSG_WP_INSTALL_COMPLETE_DNS="   1. Đảm bảo tên miền '%s' của bạn trỏ về địa chỉ IP của máy chủ này: %s"
VI_MSG_WP_INSTALL_COMPLETE_BROWSER="   2. Mở http://%s trong trình duyệt để hoàn tất cài đặt WordPress (ngôn ngữ, tiêu đề trang, user admin)."
VI_MSG_WP_INSTALL_COMPLETE_SSL="   3. Cân nhắc cài đặt SSL bằng tùy chọn 9 trong menu chính."

# Backup & Restore
VI_PROMPT_SITE_PATH_BACKUP="Nhập đường dẫn web root đầy đủ của trang WordPress cần sao lưu: "
VI_PROMPT_BACKUP_DIR="Nhập đường dẫn thư mục để lưu trữ bản sao lưu (ví dụ: /var/backups/wordpress): "
VI_ERR_SITE_PATH_NOT_WP="⚠️ Đường dẫn '%s' không giống một cài đặt WordPress (không tìm thấy wp-config.php)."
VI_INFO_CREATING_BACKUP_FILES="🔵 Đang sao lưu file WordPress cho '%s'..."
VI_INFO_CREATING_BACKUP_DB="🔵 Đang sao lưu database WordPress cho '%s'..."
VI_MSG_BACKUP_SUCCESS="✅ Sao lưu cho '%s' hoàn tất. File được lưu tại: %s"
VI_MSG_BACKUP_FAIL="❌ Sao lưu cho '%s' thất bại."
VI_PROMPT_BACKUP_FILE_FILES_RESTORE="Nhập đường dẫn đầy đủ đến file sao lưu file WordPress (.tar.gz): "
VI_PROMPT_BACKUP_FILE_DB_RESTORE="Nhập đường dẫn đầy đủ đến file sao lưu database WordPress (.sql hoặc .sql.gz): "
VI_PROMPT_SITE_PATH_RESTORE="Nhập đường dẫn web root đầy đủ của trang WordPress cần phục hồi: "
VI_PROMPT_RESTORE_CONFIRM="⚠️  Thao tác này sẽ ghi đè file và database hiện tại của trang tại '%s'. Bạn có chắc chắn không? (y/N): "
VI_INFO_RESTORING_FILES="🔵 Đang phục hồi file WordPress tới '%s'..."
VI_INFO_RESTORING_DB="🔵 Đang phục hồi database WordPress..."
VI_MSG_RESTORE_SUCCESS="✅ Trang WordPress tại '%s' đã được phục hồi thành công."
VI_MSG_RESTORE_FAIL="❌ Phục hồi trang WordPress thất bại."

# Update WP
VI_UPDATE_WP_MENU_HEADER="--- Menu Cập nhật WordPress ---"
VI_UPDATE_OPT_CORE="1. Cập nhật WordPress Core"
VI_UPDATE_OPT_ALL_PLUGINS="2. Cập nhật Tất cả Plugins"
VI_UPDATE_OPT_ALL_THEMES="3. Cập nhật Tất cả Themes"
VI_PROMPT_SITE_PATH_FOR_WPCLI="Nhập đường dẫn trang WordPress cho lệnh WP-CLI: "
VI_INFO_UPDATING_WP_CORE="🔵 Đang cập nhật WordPress Core cho trang tại '%s'..."
VI_INFO_UPDATING_ALL_PLUGINS="🔵 Đang cập nhật tất cả plugin cho trang tại '%s'..."
VI_INFO_UPDATING_ALL_THEMES="🔵 Đang cập nhật tất cả theme cho trang tại '%s'..."
VI_MSG_WPCLI_SUCCESS="✅ Lệnh WP-CLI thực thi thành công."
VI_MSG_WPCLI_FAIL="❌ Lệnh WP-CLI thất bại."

# Maintenance Mode
VI_PROMPT_MAINTENANCE_ACTION="Chọn hành động: (1 để Bật, 2 để Tắt): "
VI_INFO_ENABLING_MAINTENANCE="🔵 Đang bật chế độ bảo trì cho trang tại '%s'..."
VI_INFO_DISABLING_MAINTENANCE="🔵 Đang tắt chế độ bảo trì cho trang tại '%s'..."
VI_MSG_MAINTENANCE_ENABLED="✅ Chế độ bảo trì đã được bật."
VI_MSG_MAINTENANCE_DISABLED="✅ Chế độ bảo trì đã được tắt."

# Run WP-CLI
VI_PROMPT_WPCLI_COMMAND="Nhập lệnh WP-CLI cần chạy (ví dụ: 'plugin list --status=active'): "
VI_INFO_RUNNING_WPCLI_COMMAND="🔵 Đang chạy lệnh WP-CLI cho trang tại '%s': wp %s"

# SSL (Certbot)
VI_INFO_INSTALLING_CERTBOT="🔵 Đang cài đặt Certbot và plugin Nginx..."
VI_MSG_CERTBOT_INSTALL_SUCCESS="✅ Certbot đã được cài đặt thành công."
VI_MSG_CERTBOT_INSTALL_FAIL="❌ Cài đặt Certbot thất bại."
VI_PROMPT_DOMAIN_FOR_SSL="Nhập tên miền để cài đặt SSL (phải đang hoạt động và trỏ về máy chủ này): "
VI_PROMPT_EMAIL_FOR_SSL="Nhập địa chỉ email của bạn để đăng ký Let's Encrypt và khôi phục: "
VI_INFO_REQUESTING_SSL_CERT="🔵 Đang yêu cầu chứng chỉ SSL cho %s qua Certbot..."
VI_MSG_SSL_SETUP_SUCCESS="✅ Chứng chỉ SSL đã được lấy và cấu hình cho %s thành công!"
VI_MSG_SSL_SETUP_FAIL="❌ Cài đặt chứng chỉ SSL cho %s thất bại."

# Delete WP
VI_PROMPT_SITE_PATH_DELETE="Nhập đường dẫn web root đầy đủ của trang WordPress cần XÓA: "
VI_PROMPT_DELETE_WP_CONFIRM1="⚠️  CẨN THẬN TUYỆT ĐỐI! Thao tác này sẽ XÓA VĨNH VIỄN tất cả file của trang tại '%s'."
VI_PROMPT_DELETE_WP_CONFIRM2="   Nó cũng sẽ cố gắng xóa cấu hình Nginx và database cũng như user liên quan."
VI_PROMPT_DELETE_WP_CONFIRM3="   KHÔNG CÓ CÁCH HOÀN TÁC. Gõ 'YESIDOITTODELETE' để xác nhận: "
VI_INFO_DELETING_WP_FILES="🔵 Đang xóa file WordPress tại '%s'..."
VI_INFO_DELETING_NGINX_CONF="🔵 Đang xóa cấu hình Nginx cho trang..."
VI_INFO_DELETING_DB_USER="🔵 Đang xóa database '%s' và user '%s'..."
VI_MSG_WP_DELETE_COMPLETE="✅ Trang WordPress '%s' đã được xóa."
VI_MSG_WP_DELETE_ABORTED="ℹ️  Đã hủy xóa trang WordPress."


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
    if ! command -v "$pkg_name" &> /dev/null && ! rpm -q "$pkg_name" &>/dev/null ; then # Check command and installed package
        local confirm_install
        printf "$(get_string "MSG_PKG_NOT_FOUND_INSTALL_PROMPT" "$tool_name")" # Sử dụng key mới
        read -r confirm_install < /dev/tty
        if [[ "$confirm_install" == "y" || "$confirm_install" == "Y" ]]; then
            printf "$(get_string "INFO_INSTALLING_PKG_FOR_TOOL" "$tool_name")\n" # Sử dụng key mới
            if sudo dnf install -y "$pkg_name"; then
                echo "✅ $pkg_name installed successfully."
            else
                printf "$(get_string "ERR_PKG_INSTALL_FAILED_FOR_TOOL" "$tool_name")\n" # Sử dụng key mới
                return 1
            fi
        else
            return 1 # Người dùng không muốn cài
        fi
    fi
    return 0
}

# Hàm tạo mật khẩu ngẫu nhiên
generate_password() {
    openssl rand -base64 16
}

# Hàm chạy lệnh WP-CLI cho một trang cụ thể
run_wp_cli() {
    local wp_path="$1"
    local wp_command="$2"
    local run_as_user="$WEB_USER" # Chạy với người dùng web server

    if [ ! -f "$wp_path/wp-config.php" ]; then
        printf "$(get_string "ERR_SITE_PATH_NOT_WP")\n" "$wp_path"
        return 1
    fi
    if ! command -v wp &> /dev/null; then
        echo "$(get_string "MSG_WPCLI_NOT_INSTALLED")"
        return 1
    fi

    echo "🔵 $(get_string "INFO_RUNNING_WPCLI_COMMAND" | sed "s/%s/$wp_path/1" | sed "s/%s/$wp_command/1")"
    # printf "$(get_string "INFO_RUNNING_WPCLI_COMMAND")\n" "$wp_path" "$wp_command" # This would print path and command on separate lines due to formatting
    # The above sed is a bit hacky for string replacement, ideally get_string would support parameters
    if sudo -u "$run_as_user" wp "$wp_command" --path="$wp_path" --allow-root; then # --allow-root for wp-cli if script is run as root
        echo "$(get_string "MSG_WPCLI_SUCCESS")"
        return 0
    else
        echo "$(get_string "MSG_WPCLI_FAIL")"
        return 1
    fi
}


# --- CÁC HÀM CHỨC NĂNG CHÍNH ---

# 1. Cài đặt LEMP Stack
install_lemp_stack() {
    echo "$(get_string "INFO_INSTALLING_LEMP")"
    local php_version_input
    local php_version="8.1" # Mặc định

    read -r -p "$(get_string "PROMPT_PHP_VERSION")" php_version_input < /dev/tty
    if [ -n "$php_version_input" ]; then
        php_version="$php_version_input"
    fi

    # Cài đặt Nginx
    if ! sudo dnf install -y nginx; then echo "❌ Nginx installation failed."; press_enter_to_continue; return 1; fi
    sudo systemctl enable --now nginx
    echo "$(get_string "INFO_NGINX_INSTALLED")"

    # Cài đặt MariaDB
    if ! sudo dnf install -y mariadb-server mariadb; then echo "❌ MariaDB installation failed."; press_enter_to_continue; return 1; fi
    sudo systemctl enable --now mariadb
    echo "$(get_string "INFO_MARIADB_INSTALLED")"
    echo "   $(get_string "MSG_PRESS_ENTER_TO_CONTINUE") $(get_string "EN_INFO_MARIADB_INSTALLED" | grep "mysql_secure_installation")" # Show mysql_secure_installation reminder
    # read -r temp < /dev/tty # Pause for user to see the mysql_secure_installation note

    # Cài đặt PHP và các extensions cần thiết
    # Ví dụ: sudo dnf module enable php:remi-8.1 -y (nếu dùng Remi repo)
    # Hoặc dùng AppStream: sudo dnf module reset php -y; sudo dnf module enable php:${php_version} -y
    echo "   Installing PHP ${php_version} and extensions..."
    sudo dnf module reset php -y >/dev/null 2>&1
    if ! sudo dnf module enable php:"${php_version}" -y ; then
        echo "❌ Failed to enable PHP ${php_version} module. Please check available PHP versions with 'dnf module list php'."
        press_enter_to_continue
        return 1
    fi
    if ! sudo dnf install -y php php-fpm php-mysqlnd php-gd php-xml php-mbstring php-json php-opcache php-zip php-curl php-intl php-bcmath php-pecl-imagick; then
         echo "❌ PHP or some extensions installation failed."
         press_enter_to_continue
         return 1
    fi

    # Cấu hình PHP-FPM cho Nginx
    sudo sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
    sudo sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
    sudo sed -i 's/listen.owner = nobody/listen.owner = nginx/g' /etc/php-fpm.d/www.conf
    sudo sed -i 's/listen.group = nobody/listen.group = nginx/g' /etc/php-fpm.d/www.conf
    sudo systemctl enable --now php-fpm
    echo "$(get_string "INFO_PHP_INSTALLED")"

    # Mở port HTTP, HTTPS trên firewall
    echo "   Opening HTTP and HTTPS ports on firewall..."
    sudo firewall-cmd --permanent --add-service=http >/dev/null 2>&1
    sudo firewall-cmd --permanent --add-service=https >/dev/null 2>&1
    sudo firewall-cmd --reload >/dev/null 2>&1

    echo "$(get_string "MSG_LEMP_INSTALL_SUCCESS")"
}

# 2. Quản lý WP-CLI
manage_wpcli() {
    while true; do
        clear
        echo "=============================================="
        echo "$(get_string "WPCLI_MENU_HEADER")"
        echo "=============================================="
        echo "$(get_string "WPCLI_OPT_INSTALL")"
        echo "$(get_string "WPCLI_OPT_CHECK_VERSION")"
        echo "$(get_string "WPCLI_OPT_UNINSTALL")"
        echo "$(get_string "WPCLI_OPT_BACK")"
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty
        case $choice in
            1)
                echo "$(get_string "INFO_INSTALLING_WPCLI")"
                if curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
                   chmod +x wp-cli.phar && \
                   sudo mv wp-cli.phar /usr/local/bin/wp; then
                    echo "$(get_string "MSG_WPCLI_INSTALL_SUCCESS")"
                    wp --info --allow-root
                else
                    echo "$(get_string "MSG_WPCLI_INSTALL_FAIL")"
                fi
                ;;
            2)
                if command -v wp &> /dev/null; then
                    wp --info --allow-root
                else
                    echo "$(get_string "MSG_WPCLI_NOT_INSTALLED")"
                fi
                ;;
            3)
                if command -v wp &> /dev/null; then
                    echo "$(get_string "INFO_UNINSTALLING_WPCLI")"
                    if sudo rm -f /usr/local/bin/wp; then
                         echo "$(get_string "MSG_WPCLI_UNINSTALL_SUCCESS")"
                    else
                         echo "$(get_string "MSG_WPCLI_UNINSTALL_FAIL")"
                    fi
                else
                    echo "$(get_string "MSG_WPCLI_NOT_INSTALLED")"
                fi
                ;;
            0) break ;;
            *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
        esac
        press_enter_to_continue
    done
}


# 3. Cài đặt trang WordPress mới
install_new_wp_site() {
    local domain wp_path db_name db_user db_pass db_pass_final nginx_conf_file
    local salt_keys wp_salts

    echo "--- $(get_string "MENU_OPT_NEW_WP_SITE") ---"
    read -r -p "$(get_string "PROMPT_DOMAIN_NAME")" domain < /dev/tty
    if [ -z "$domain" ]; then echo "$(get_string "ERR_DOMAIN_EMPTY")"; return; fi

    read -r -p "$(get_string "PROMPT_WP_PATH")" wp_path < /dev/tty
    if [ -z "$wp_path" ]; then echo "$(get_string "ERR_WP_PATH_EMPTY")"; return; fi
    if [ -d "$wp_path" ]; then printf "$(get_string "ERR_WP_PATH_EXISTS")\n" "$wp_path"; return; fi

    read -r -p "$(get_string "PROMPT_DB_NAME")" db_name < /dev/tty
    if [ -z "$db_name" ]; then db_name="${domain//./_}_wp"; echo "ℹ️ DB Name defaulted to: $db_name"; fi # Default DB name

    read -r -p "$(get_string "PROMPT_DB_USER")" db_user < /dev/tty
    if [ -z "$db_user" ]; then db_user="${domain//./_}_usr"; echo "ℹ️ DB User defaulted to: $db_user"; fi # Default DB user (max 16 chars for MariaDB user)
    db_user=$(echo "$db_user" | cut -c 1-16)


    read -r -s -p "$(get_string "PROMPT_DB_PASS")" db_pass < /dev/tty
    echo "" # Newline after password input
    if [ -z "$db_pass" ]; then
        echo "$(get_string "INFO_GENERATING_DB_PASS")"
        db_pass_final=$(generate_password)
        printf "$(get_string "MSG_DB_PASS_GENERATED")\n" "$db_pass_final"
    else
        db_pass_final="$db_pass"
    fi

    # Tạo database và user
    echo "$(get_string "INFO_CREATING_DB" | sed "s/%s/$db_name/1" | sed "s/%s/$db_user/1")"
    # printf "$(get_string "INFO_CREATING_DB")\n" "$db_name" "$db_user" # This will print on two lines
    SQL_COMMAND="CREATE DATABASE IF NOT EXISTS \`$db_name\`; GRANT ALL PRIVILEGES ON \`$db_name\`.* TO \`$db_user\`@'localhost' IDENTIFIED BY '$db_pass_final'; FLUSH PRIVILEGES;"
    if sudo mysql -e "$SQL_COMMAND"; then
        echo "$(get_string "MSG_DB_CREATE_SUCCESS")"
    else
        echo "$(get_string "MSG_DB_CREATE_FAIL")"
        echo "   SQL executed: $SQL_COMMAND (password hidden)"
        press_enter_to_continue
        return 1
    fi

    # Tải WordPress
    echo "$(get_string "INFO_DOWNLOADING_WP")"
    sudo mkdir -p "$wp_path"
    if sudo curl -sSL https://wordpress.org/latest.tar.gz -o "/tmp/latest.tar.gz" && \
       sudo tar -xzf "/tmp/latest.tar.gz" -C "$wp_path" --strip-components=1 && \
       sudo rm "/tmp/latest.tar.gz"; then
        echo "$(get_string "MSG_WP_DOWNLOAD_SUCCESS")"
    else
        echo "$(get_string "MSG_WP_DOWNLOAD_FAIL")"
        sudo rm -rf "$wp_path" # Clean up failed download
        press_enter_to_continue
        return 1
    fi

    # Cấu hình wp-config.php
    echo "$(get_string "INFO_CONFIGURING_WP")"
    sudo cp "$wp_path/wp-config-sample.php" "$wp_path/wp-config.php"
    # Lấy salt keys
    wp_salts=$(curl -sS https://api.wordpress.org/secret-key/1.1/salt/)
    if [ -n "$wp_salts" ]; then
        # Xóa các dòng salt key mẫu
        sudo sed -i "/AUTH_KEY/d" "$wp_path/wp-config.php"
        sudo sed -i "/SECURE_AUTH_KEY/d" "$wp_path/wp-config.php"
        sudo sed -i "/LOGGED_IN_KEY/d" "$wp_path/wp-config.php"
        sudo sed -i "/NONCE_KEY/d" "$wp_path/wp-config.php"
        sudo sed -i "/AUTH_SALT/d" "$wp_path/wp-config.php"
        sudo sed -i "/SECURE_AUTH_SALT/d" "$wp_path/wp-config.php"
        sudo sed -i "/LOGGED_IN_SALT/d" "$wp_path/wp-config.php"
        sudo sed -i "/NONCE_SALT/d" "$wp_path/wp-config.php"
        # Chèn salt keys mới vào trước dòng `\$table_prefix`
        sudo sed -i "/\$table_prefix/i $wp_salts" "$wp_path/wp-config.php"
    else
        echo "⚠️ Could not fetch WordPress salts. Please add them manually to wp-config.php."
    fi

    sudo sed -i "s/database_name_here/$db_name/g" "$wp_path/wp-config.php"
    sudo sed -i "s/username_here/$db_user/g" "$wp_path/wp-config.php"
    sudo sed -i "s/password_here/$db_pass_final/g" "$wp_path/wp-config.php"
    # Thêm FS_METHOD direct để tránh hỏi FTP credentials khi update/install plugin/theme
    echo "define('FS_METHOD', 'direct');" | sudo tee -a "$wp_path/wp-config.php" > /dev/null


    if [ $? -eq 0 ]; then
        echo "$(get_string "MSG_WP_CONFIG_SUCCESS")"
    else
        echo "$(get_string "MSG_WP_CONFIG_FAIL")"
        press_enter_to_continue
        return 1
    fi

    # Thiết lập quyền
    echo "$(get_string "INFO_SETTING_PERMISSIONS")"
    sudo chown -R "$WEB_USER":"$WEB_GROUP" "$wp_path"
    sudo find "$wp_path" -type d -exec chmod 755 {} \;
    sudo find "$wp_path" -type f -exec chmod 644 {} \;
    sudo chmod 640 "$wp_path/wp-config.php" # Harden wp-config.php

    # Cấu hình Nginx
    echo "$(get_string "INFO_CONFIGURING_NGINX" | sed "s/%s/$domain/g")"
    nginx_conf_file="/etc/nginx/conf.d/${domain}.conf"
    sudo bash -c "cat > $nginx_conf_file" <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    root $wp_path;

    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php-fpm/www.sock; # Hoặc TCP/IP nếu PHP-FPM cấu hình khác
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }

    location ~ /\.ht {
        deny all;
    }

    # Directives to send expires headers and turn off 404 error logging.
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 30d;
        log_not_found off;
    }
}
EOF
    if sudo nginx -t && sudo systemctl reload nginx; then
        echo "$(get_string "MSG_NGINX_CONFIG_SUCCESS" | sed "s/%s/$domain/g")"
    else
        echo "$(get_string "MSG_NGINX_CONFIG_FAIL" | sed "s/%s/$domain/g")"
        echo "   Please check Nginx configuration manually: sudo nginx -t"
        press_enter_to_continue
        # return 1 # Don't necessarily fail the whole WP install for this
    fi

    # Hoàn tất
    server_ip=$(hostname -I | awk '{print $1}')
    echo ""
    echo "$(get_string "MSG_WP_INSTALL_COMPLETE_TITLE" | sed "s/%s/$domain/g")"
    echo "$(get_string "MSG_WP_INSTALL_COMPLETE_NEXT_STEPS")"
    echo "$(get_string "MSG_WP_INSTALL_COMPLETE_DNS" | sed "s/%s/$domain/1" | sed "s/%s/$server_ip/1")"
    echo "$(get_string "MSG_WP_INSTALL_COMPLETE_BROWSER" | sed "s/%s/$domain/g")"
    echo "$(get_string "MSG_WP_INSTALL_COMPLETE_SSL")"
}

# 4. Sao lưu WordPress
backup_wp_site() {
    local site_path backup_dir timestamp db_name db_user db_pass wp_config_path db_backup_file files_backup_file

    echo "--- $(get_string "MENU_OPT_BACKUP_WP_SITE") ---"
    read -r -p "$(get_string "PROMPT_SITE_PATH_BACKUP")" site_path < /dev/tty
    wp_config_path="$site_path/wp-config.php"
    if [ ! -f "$wp_config_path" ]; then
        printf "$(get_string "ERR_SITE_PATH_NOT_WP")\n" "$site_path"
        return
    fi

    read -r -p "$(get_string "PROMPT_BACKUP_DIR")" backup_dir < /dev/tty
    if [ -z "$backup_dir" ]; then backup_dir="/var/backups/wordpress_$(basename "$site_path")"; fi
    sudo mkdir -p "$backup_dir"

    timestamp=$(date +"%Y%m%d_%H%M%S")

    # Lấy thông tin DB từ wp-config.php
    # Cần cẩn thận với các ký tự đặc biệt trong password
    db_name=$(sudo grep DB_NAME "$wp_config_path" | cut -d \' -f4)
    db_user=$(sudo grep DB_USER "$wp_config_path" | cut -d \' -f4)
    db_pass=$(sudo grep DB_PASSWORD "$wp_config_path" | cut -d \' -f4)


    # Sao lưu database
    db_backup_file="$backup_dir/db_${db_name}_${timestamp}.sql.gz"
    printf "$(get_string "INFO_CREATING_BACKUP_DB")\n" "$site_path"
    if sudo mysqldump -u "$db_user" -p"$db_pass" "$db_name" | gzip > "$db_backup_file"; then
        echo "   ✅ DB backup successful: $db_backup_file"
    else
        echo "   ❌ DB backup failed."
        # sudo rm -f "$db_backup_file" # Xóa file rỗng nếu lỗi
        press_enter_to_continue
        return 1
    fi

    # Sao lưu files
    files_backup_file="$backup_dir/files_$(basename "$site_path")_${timestamp}.tar.gz"
    printf "$(get_string "INFO_CREATING_BACKUP_FILES")\n" "$site_path"
    # -C để thay đổi thư mục, giúp loại bỏ đường dẫn tuyệt đối không cần thiết trong tar
    if sudo tar -czf "$files_backup_file" -C "$(dirname "$site_path")" "$(basename "$site_path")"; then
        echo "   ✅ Files backup successful: $files_backup_file"
    else
        echo "   ❌ Files backup failed."
        # sudo rm -f "$files_backup_file" # Xóa file rỗng nếu lỗi
        press_enter_to_continue
        return 1
    fi
    printf "$(get_string "MSG_BACKUP_SUCCESS")\n" "$site_path" "$backup_dir"
}

# 5. Phục hồi WordPress
restore_wp_site() {
    local site_path files_backup db_backup db_name db_user db_pass wp_config_path tmp_db_name

    echo "--- $(get_string "MENU_OPT_RESTORE_WP_SITE") ---"
    read -r -p "$(get_string "PROMPT_SITE_PATH_RESTORE")" site_path < /dev/tty
    wp_config_path="$site_path/wp-config.php" # Giả định wp-config.php tồn tại hoặc sẽ được phục hồi

    read -r -p "$(get_string "PROMPT_BACKUP_FILE_FILES_RESTORE")" files_backup < /dev/tty
    if [ ! -f "$files_backup" ]; then echo "❌ Files backup '$files_backup' not found."; return; fi

    read -r -p "$(get_string "PROMPT_BACKUP_FILE_DB_RESTORE")" db_backup < /dev/tty
    if [ ! -f "$db_backup" ]; then echo "❌ DB backup '$db_backup' not found."; return; fi

    local confirm_restore
    printf "$(get_string "PROMPT_RESTORE_CONFIRM")\n" "$site_path"
    read -r confirm_restore < /dev/tty
    if [[ "$confirm_restore" != "y" && "$confirm_restore" != "Y" ]]; then
        echo "$(get_string "MSG_UNINSTALL_CANCELLED" | sed 's/Docker uninstallation/Restore operation/g')"; return
    fi

    # Tạo thư mục nếu chưa có
    sudo mkdir -p "$site_path"

    # Phục hồi files
    printf "$(get_string "INFO_RESTORING_FILES")\n" "$site_path"
    # Xóa nội dung cũ trước khi giải nén để tránh conflict, hoặc giải nén vào thư mục tạm rồi di chuyển
    # For simplicity, just extract, assuming user knows what they are doing or site_path is empty
    if sudo tar -xzf "$files_backup" -C "$site_path" --strip-components=1; then # Giả sử backup được tạo với --strip-components=1
        echo "   ✅ Files restored."
        # Cần thiết lập lại quyền sau khi phục hồi
        sudo chown -R "$WEB_USER":"$WEB_GROUP" "$site_path"
        sudo find "$site_path" -type d -exec chmod 755 {} \;
        sudo find "$site_path" -type f -exec chmod 644 {} \;
        if [ -f "$wp_config_path" ]; then sudo chmod 640 "$wp_config_path"; fi
    else
        echo "   ❌ Files restoration failed."
        press_enter_to_continue
        return 1
    fi

    # Phục hồi database
    # Lấy thông tin DB từ wp-config.php (đã được phục hồi từ backup files)
    if [ ! -f "$wp_config_path" ]; then
        echo "❌ wp-config.php not found in the restored files. Cannot proceed with DB restore without DB credentials."
        return 1
    fi
    db_name=$(sudo grep DB_NAME "$wp_config_path" | cut -d \' -f4)
    db_user=$(sudo grep DB_USER "$wp_config_path" | cut -d \' -f4)
    db_pass=$(sudo grep DB_PASSWORD "$wp_config_path" | cut -d \' -f4)

    if [ -z "$db_name" ] || [ -z "$db_user" ] || [ -z "$db_pass" ]; then
        echo "❌ Could not read DB credentials from restored wp-config.php. Cannot restore database."
        return 1
    fi

    printf "$(get_string "INFO_RESTORING_DB")\n"
    # Drop existing tables or drop and recreate database might be needed for a clean restore
    # For now, just import. User should ensure DB is clean or backup is designed for overwrite.
    # Check if DB exists, create if not (though wp-config has it, so it should exist or be created by user)
    sudo mysql -e "CREATE DATABASE IF NOT EXISTS \`$db_name\`;"

    local import_cmd
    if [[ "$db_backup" == *.gz ]]; then
        import_cmd="gzip -dc \"$db_backup\" | sudo mysql -u \"$db_user\" -p\"$db_pass\" \"$db_name\""
    else
        import_cmd="sudo mysql -u \"$db_user\" -p\"$db_pass\" \"$db_name\" < \"$db_backup\""
    fi

    if eval "$import_cmd"; then
        echo "   ✅ Database restored."
    else
        echo "   ❌ Database restoration failed."
        press_enter_to_continue
        return 1
    fi

    printf "$(get_string "MSG_RESTORE_SUCCESS")\n" "$site_path"
}


# 6. Cập nhật WordPress
update_wordpress_menu() {
    local site_path
    read -r -p "$(get_string "PROMPT_SITE_PATH_FOR_WPCLI")" site_path < /dev/tty
    if [ -z "$site_path" ]; then echo "$(get_string "ERR_WP_PATH_EMPTY")"; return; fi

    while true; do
        clear
        echo "=============================================="
        echo "$(get_string "UPDATE_WP_MENU_HEADER") - $site_path"
        echo "=============================================="
        echo "$(get_string "UPDATE_OPT_CORE")"
        echo "$(get_string "UPDATE_OPT_ALL_PLUGINS")"
        echo "$(get_string "UPDATE_OPT_ALL_THEMES")"
        echo "$(get_string "WPCLI_OPT_BACK")" # Re-use "Back" string
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty

        case $choice in
            1) printf "$(get_string "INFO_UPDATING_WP_CORE")\n" "$site_path"; run_wp_cli "$site_path" "core update" ;;
            2) printf "$(get_string "INFO_UPDATING_ALL_PLUGINS")\n" "$site_path"; run_wp_cli "$site_path" "plugin update --all" ;;
            3) printf "$(get_string "INFO_UPDATING_ALL_THEMES")\n" "$site_path"; run_wp_cli "$site_path" "theme update --all" ;;
            0) break ;;
            *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
        esac
        press_enter_to_continue
    done
}

# 7. Quản lý Maintenance Mode
manage_maintenance_mode() {
    local site_path action
    read -r -p "$(get_string "PROMPT_SITE_PATH_FOR_WPCLI")" site_path < /dev/tty
    if [ -z "$site_path" ]; then echo "$(get_string "ERR_WP_PATH_EMPTY")"; return; fi

    read -r -p "$(get_string "PROMPT_MAINTENANCE_ACTION")" action < /dev/tty
    case $action in
        1)
            printf "$(get_string "INFO_ENABLING_MAINTENANCE")\n" "$site_path"
            if run_wp_cli "$site_path" "maintenance-mode activate"; then
                echo "$(get_string "MSG_MAINTENANCE_ENABLED")"
            fi
            ;;
        2)
            printf "$(get_string "INFO_DISABLING_MAINTENANCE")\n" "$site_path"
            if run_wp_cli "$site_path" "maintenance-mode deactivate"; then
                echo "$(get_string "MSG_MAINTENANCE_DISABLED")"
            fi
            ;;
        *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
    esac
}

# 8. Chạy lệnh WP-CLI tùy chỉnh
run_custom_wpcli_command() {
    local site_path wp_cmd
    read -r -p "$(get_string "PROMPT_SITE_PATH_FOR_WPCLI")" site_path < /dev/tty
    if [ -z "$site_path" ]; then echo "$(get_string "ERR_WP_PATH_EMPTY")"; return; fi

    read -r -p "$(get_string "PROMPT_WPCLI_COMMAND")" wp_cmd < /dev/tty
    if [ -z "$wp_cmd" ]; then echo "$(get_string "ERR_CRON_ENTRY_EMPTY" | sed 's/Cron job entry/WP-CLI command/g')"; return; fi # Re-use

    run_wp_cli "$site_path" "$wp_cmd"
}

# 9. Cài đặt SSL với Certbot
setup_ssl_certbot() {
    local domain email nginx_conf_path
    echo "--- $(get_string "MENU_OPT_SETUP_SSL") ---"

    if ! command -v certbot &> /dev/null; then
        echo "$(get_string "INFO_INSTALLING_CERTBOT")"
        if sudo dnf install -y certbot python3-certbot-nginx; then
            echo "$(get_string "MSG_CERTBOT_INSTALL_SUCCESS")"
        else
            echo "$(get_string "MSG_CERTBOT_INSTALL_FAIL")"
            return 1
        fi
    fi

    read -r -p "$(get_string "PROMPT_DOMAIN_FOR_SSL")" domain < /dev/tty
    if [ -z "$domain" ]; then echo "$(get_string "ERR_DOMAIN_EMPTY")"; return; fi

    nginx_conf_path="/etc/nginx/conf.d/${domain}.conf"
    if [ ! -f "$nginx_conf_path" ]; then
        echo "⚠️ Nginx config file $nginx_conf_path not found. Please install the WordPress site first or ensure the domain matches the Nginx config file name."
        return
    fi

    read -r -p "$(get_string "PROMPT_EMAIL_FOR_SSL")" email < /dev/tty
    if [ -z "$email" ]; then echo "⚠️ Email cannot be empty for Let's Encrypt."; return; fi


    echo "$(get_string "INFO_REQUESTING_SSL_CERT" | sed "s/%s/$domain/g")"
    # Certbot command might need adjustment based on Nginx config.
    # --nginx attempts to auto-configure Nginx.
    # --agree-tos and -n for non-interactive (but email is required for -n with register-unsafely-without-email)
    # We make it interactive for TOS.
    if sudo certbot --nginx -d "$domain" -d "www.$domain" --email "$email" --agree-tos --no-eff-email --redirect; then
        echo "$(get_string "MSG_SSL_SETUP_SUCCESS" | sed "s/%s/$domain/g")"
        echo "   Testing Nginx configuration..."
        if sudo nginx -t; then
            sudo systemctl reload nginx
            echo "   ✅ Nginx reloaded."
        else
            echo "   ❌ Nginx configuration test failed after SSL setup. Please check manually."
        fi
    else
        echo "$(get_string "MSG_SSL_SETUP_FAIL" | sed "s/%s/$domain/g")"
    fi
}

# 10. Xóa trang WordPress
delete_wp_site() {
    local site_path domain db_name db_user wp_config_path confirm_dangerous

    echo "--- $(get_string "MENU_OPT_DELETE_WP_SITE") ---"
    read -r -p "$(get_string "PROMPT_SITE_PATH_DELETE")" site_path < /dev/tty
    if [ -z "$site_path" ] || [ ! -d "$site_path" ]; then
        echo "⚠️ Site path is empty or does not exist: $site_path"; return
    fi
    wp_config_path="$site_path/wp-config.php"

    printf "$(get_string "PROMPT_DELETE_WP_CONFIRM1")\n" "$site_path"
    echo "$(get_string "PROMPT_DELETE_WP_CONFIRM2")"
    read -r -p "$(get_string "PROMPT_DELETE_WP_CONFIRM3")" confirm_dangerous < /dev/tty

    if [ "$confirm_dangerous" != "YESIDOITTODELETE" ]; then
        echo "$(get_string "MSG_WP_DELETE_ABORTED")"
        return
    fi

    # Lấy thông tin DB từ wp-config.php trước khi xóa
    if [ -f "$wp_config_path" ]; then
        db_name=$(sudo grep DB_NAME "$wp_config_path" | cut -d \' -f4)
        db_user=$(sudo grep DB_USER "$wp_config_path" | cut -d \' -f4)
        # Domain might be derivable from path or Nginx config if needed later for Nginx conf removal
        domain=$(basename "$site_path") # Simple assumption
        if [[ "$site_path" == *"/var/www/"* ]]; then # Try to get domain from path if it's /var/www/domain
            domain=$(echo "$site_path" | sed 's|/var/www/||' | cut -d'/' -f1)
        fi
    else
        echo "⚠️ wp-config.php not found at $site_path. Cannot determine DB details for deletion automatically. Skipping DB/User deletion."
        db_name=""
        db_user=""
        domain=$(basename "$site_path") # Fallback for Nginx config name
    fi


    printf "$(get_string "INFO_DELETING_WP_FILES")\n" "$site_path"
    sudo rm -rf "$site_path"

    local nginx_conf_file="/etc/nginx/conf.d/${domain}.conf"
    if [ -f "$nginx_conf_file" ]; then
        echo "$(get_string "INFO_DELETING_NGINX_CONF")"
        sudo rm -f "$nginx_conf_file"
        sudo nginx -t && sudo systemctl reload nginx
    else
        echo "ℹ️ Nginx config file for $domain ($nginx_conf_file) not found, skipping."
    fi

    if [ -n "$db_name" ] && [ -n "$db_user" ]; then
        printf "$(get_string "INFO_DELETING_DB_USER")\n" "$db_name" "$db_user"
        SQL_COMMAND_DELETE="DROP DATABASE IF EXISTS \`$db_name\`; DROP USER IF EXISTS \`$db_user\`@'localhost'; FLUSH PRIVILEGES;"
        if sudo mysql -e "$SQL_COMMAND_DELETE"; then
             echo "   ✅ Database '$db_name' and user '$db_user' deleted."
        else
             echo "   ⚠️ Failed to delete database '$db_name' or user '$db_user'. Please check manually."
        fi
    fi
    printf "$(get_string "MSG_WP_DELETE_COMPLETE")\n" "$site_path"
}


# --- MENU CHÍNH ---
main_menu() {
    while true; do
        clear
        echo "=============================================="
        echo "$(get_string "MAIN_MENU_HEADER")"
        echo "=============================================="
        echo "$(get_string "MENU_OPT_LEMP_SETUP")"
        echo "$(get_string "MENU_OPT_WPCLI_MGMT")"
        echo "$(get_string "MENU_OPT_NEW_WP_SITE")"
        echo "$(get_string "MENU_OPT_BACKUP_WP_SITE")"
        echo "$(get_string "MENU_OPT_RESTORE_WP_SITE")"
        echo "$(get_string "MENU_OPT_UPDATE_WP")"
        echo "$(get_string "MENU_OPT_MAINTENANCE_MODE")"
        echo "$(get_string "MENU_OPT_RUN_WPCLI_CMD")"
        echo "$(get_string "MENU_OPT_SETUP_SSL")"
        echo "$(get_string "MENU_OPT_DELETE_WP_SITE")"
        echo ""
        echo "$(get_string "MENU_OPT_EXIT")"
        echo "=============================================="
        local choice
        read -r -p "$(get_string "PROMPT_ENTER_CHOICE")" choice < /dev/tty

        case $choice in
            1) install_lemp_stack ;;
            2) manage_wpcli ;;
            3) install_new_wp_site ;;
            4) backup_wp_site ;;
            5) restore_wp_site ;;
            6) update_wordpress_menu ;;
            7) manage_maintenance_mode ;;
            8) run_custom_wpcli_command ;;
            9) setup_ssl_certbot ;;
            10) delete_wp_site ;;
            0) echo "$(get_string "MSG_EXITING")"; exit 0 ;;
            *) echo "$(get_string "ERR_INVALID_OPTION")" ;;
        esac
        press_enter_to_continue
    done
}

# --- BẮT ĐẦU KỊCH BẢN ---
main_menu