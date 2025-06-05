#!/bin/bash

# Kịch bản cài đặt VPS AlmaLinux 8.10 cho mục đích chạy web (LEMP Stack)

# Ngừng thực thi nếu có lỗi
set -e

# Biến cho phiên bản PHP mong muốn (ví dụ: php:8.0, php:8.1, php:8.2)
# Kiểm tra các module có sẵn bằng: sudo dnf module list php
PHP_MODULE_STREAM="php:8.1"

echo "Bắt đầu quá trình cài đặt VPS AlmaLinux cho web..."
echo "LƯU Ý: Kịch bản này sẽ cài đặt Nginx, MariaDB, và PHP (sử dụng stream $PHP_MODULE_STREAM)."

# -----------------------------------------------------------------------------
# 1. CẬP NHẬT HỆ THỐNG
# -----------------------------------------------------------------------------
echo ""
echo "Bước 1: Đang cập nhật hệ thống..."
sudo dnf update -y
sudo dnf upgrade -y
echo "Hệ thống đã được cập nhật."

# -----------------------------------------------------------------------------
# 2. CÀI ĐẶT EPEL REPOSITORY
# -----------------------------------------------------------------------------
echo ""
echo "Bước 2: Đang cài đặt EPEL repository..."
sudo dnf install -y epel-release
echo "EPEL repository đã được cài đặt."

# -----------------------------------------------------------------------------
# 3. CÀI ĐẶT CÁC GÓI TIỆN ÍCH CƠ BẢN
# -----------------------------------------------------------------------------
echo ""
echo "Bước 3: Đang cài đặt các gói tiện ích cơ bản..."
sudo dnf install -y wget curl git zip unzip htop vim nano net-tools bind-utils policycoreutils-python-utils setools
echo "Các gói tiện ích cơ bản đã được cài đặt."

# -----------------------------------------------------------------------------
# 4. CÀI ĐẶT NGINX (WEB SERVER)
# -----------------------------------------------------------------------------
echo ""
echo "Bước 4: Đang cài đặt Nginx..."
sudo dnf install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "Nginx đã được cài đặt và khởi động."

# -----------------------------------------------------------------------------
# 5. CÀI ĐẶT MARIADB (DATABASE SERVER)
# -----------------------------------------------------------------------------
echo ""
echo "Bước 5: Đang cài đặt MariaDB..."
sudo dnf install -y mariadb-server mariadb
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo "MariaDB đã được cài đặt và khởi động."
echo "LƯU Ý QUAN TRỌNG: Sau khi kịch bản hoàn tất, hãy chạy 'sudo mysql_secure_installation' để bảo mật MariaDB."

# -----------------------------------------------------------------------------
# 6. CÀI ĐẶT PHP VÀ CÁC PHẦN MỞ RỘNG
# -----------------------------------------------------------------------------
echo ""
echo "Bước 6: Đang cài đặt PHP (sử dụng stream $PHP_MODULE_STREAM) và các phần mở rộng..."
echo "Kích hoạt module PHP stream: $PHP_MODULE_STREAM"
sudo dnf module reset php -y
sudo dnf module enable $PHP_MODULE_STREAM -y

echo "Cài đặt PHP-FPM và các phần mở rộng phổ biến..."
sudo dnf install -y php php-fpm php-cli php-mysqlnd php-gd php-xml php-mbstring php-json php-opcache php-zip php-curl php-intl php-bcmath
# php-cli: cho chạy PHP từ dòng lệnh
# php-mysqlnd: để PHP kết nối MySQL/MariaDB
# php-gd: xử lý hình ảnh
# php-xml: xử lý XML
# php-mbstring: xử lý chuỗi đa byte (unicode)
# php-json: xử lý JSON
# php-opcache: tăng tốc PHP
# php-zip: xử lý file zip
# php-curl: thư viện cURL
# php-intl: cho quốc tế hóa
# php-bcmath: cho tính toán số với độ chính xác tùy ý

echo "PHP và các phần mở rộng đã được cài đặt."

# -----------------------------------------------------------------------------
# 7. CẤU HÌNH PHP-FPM CHO NGINX
# -----------------------------------------------------------------------------
echo ""
echo "Bước 7: Đang cấu hình PHP-FPM để hoạt động với Nginx..."
PHP_FPM_WWW_CONF="/etc/php-fpm.d/www.conf"
if [ -f "$PHP_FPM_WWW_CONF" ]; then
    # Đổi user và group của PHP-FPM thành 'nginx'
    sudo sed -i 's/user = apache/user = nginx/g' $PHP_FPM_WWW_CONF
    sudo sed -i 's/group = apache/group = nginx/g' $PHP_FPM_WWW_CONF
    echo "Đã cập nhật user/group trong $PHP_FPM_WWW_CONF thành nginx."
else
    echo "CẢNH BÁO: Không tìm thấy file cấu hình $PHP_FPM_WWW_CONF. Cần kiểm tra lại cấu hình PHP-FPM thủ công."
fi

echo "Khởi động và kích hoạt PHP-FPM..."
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
echo "PHP-FPM đã được khởi động và kích hoạt."

# -----------------------------------------------------------------------------
# 8. CẤU HÌNH NGINX ĐỂ XỬ LÝ PHP
# -----------------------------------------------------------------------------
echo ""
echo "Bước 8: Đang cấu hình Nginx để xử lý PHP..."
NGINX_DEFAULT_CONF="/etc/nginx/conf.d/default.conf"
NGINX_DEFAULT_CONF_BACKUP="/etc/nginx/conf.d/default.conf.backup.$(date +%s)"

if [ -f "$NGINX_DEFAULT_CONF" ]; then
    echo "Sao lưu file cấu hình Nginx mặc định hiện tại sang $NGINX_DEFAULT_CONF_BACKUP..."
    sudo cp $NGINX_DEFAULT_CONF $NGINX_DEFAULT_CONF_BACKUP
fi

echo "Tạo/Ghi đè file cấu hình Nginx mặc định ($NGINX_DEFAULT_CONF) với hỗ trợ PHP..."
sudo tee $NGINX_DEFAULT_CONF > /dev/null <<EOF
server {
    listen       80;
    listen       [::]:80;
    server_name  _; # Thay _ bằng tên miền của bạn hoặc để _ cho default
    root         /usr/share/nginx/html; # Thư mục gốc mặc định của Nginx

    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string; # Cho phép URL rewriting cho các framework PHP
    }

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_pass unix:/run/php-fpm/www.sock; # Socket mặc định của PHP-FPM trên AlmaLinux
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    # Chặn truy cập các file ẩn như .htaccess (nếu có từ Apache)
    location ~ /\.ht {
        deny all;
    }

    error_page 404 /404.html;
    location = /404.html {
        internal; # Chỉ phục vụ nội bộ
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        internal; # Chỉ phục vụ nội bộ
    }
}
EOF

echo "Kiểm tra cú pháp cấu hình Nginx..."
if sudo nginx -t; then
    echo "Cú pháp Nginx OK. Khởi động lại Nginx..."
    sudo systemctl restart nginx
else
    echo "LỖI CẤU HÌNH NGINX! Vui lòng kiểm tra file $NGINX_DEFAULT_CONF."
    echo "Bạn có thể khôi phục từ $NGINX_DEFAULT_CONF_BACKUP nếu cần."
    # exit 1 # Có thể thêm exit ở đây nếu muốn dừng script khi Nginx config lỗi
fi
echo "Nginx đã được cấu hình để xử lý PHP."

# -----------------------------------------------------------------------------
# 9. CẤU HÌNH FIREWALLD
# -----------------------------------------------------------------------------
echo ""
echo "Bước 9: Đang cài đặt và cấu hình Firewalld..."
sudo dnf install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld

echo "Mở cổng cho SSH, HTTP, và HTTPS trên Firewalld..."
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
echo "Firewalld đã được cấu hình."

# -----------------------------------------------------------------------------
# 10. (TÙY CHỌN) CÀI ĐẶT FAIL2BAN
# -----------------------------------------------------------------------------
echo ""
echo "Bước 10: Đang cài đặt Fail2ban..."
sudo dnf install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

if [ ! -f /etc/fail2ban/jail.local ]; then
    echo "Đang tạo file cấu hình jail.local cho Fail2ban..."
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    # Kích hoạt bảo vệ cho sshd trong jail.local
    sudo sed -i '/^\[sshd\]$/,/^\[/ s/enabled = false/enabled = true/' /etc/fail2ban/jail.local
    echo "File jail.local đã được tạo và kích hoạt bảo vệ SSHD. Vui lòng tùy chỉnh thêm nếu cần."
else
    echo "File jail.local đã tồn tại. Đảm bảo bạn đã cấu hình bảo vệ SSHD."
fi
sudo systemctl restart fail2ban # Khởi động lại để áp dụng jail.local nếu mới tạo hoặc thay đổi
echo "Fail2ban đã được cài đặt và cấu hình cơ bản."

# -----------------------------------------------------------------------------
# HOÀN TẤT
# -----------------------------------------------------------------------------
echo ""
echo "***********************************************************************"
echo "HOÀN TẤT QUÁ TRÌNH CÀI ĐẶT VPS CHO WEB (LEMP STACK)!"
echo "***********************************************************************"
echo ""
echo "CÁC BƯỚC QUAN TRỌNG TIẾP THEO:"
echo "1. CHẠY 'sudo mysql_secure_installation' để bảo mật MariaDB."
echo "2. Tải mã nguồn website của bạn lên thư mục '/usr/share/nginx/html' (hoặc thư mục root bạn đã cấu hình)."
echo "3. Nếu sử dụng tên miền, hãy cập nhật 'server_name' trong file '$NGINX_DEFAULT_CONF' và trỏ DNS về IP của VPS."
echo "4. Kiểm tra hoạt động của PHP bằng cách tạo file test.php trong thư mục root với nội dung: <?php phpinfo(); ?>"
echo "   Sau đó truy cập http://IP_VPS_CUA_BAN/test.php"
echo "5. Tùy chỉnh chi tiết Fail2ban trong /etc/fail2ban/jail.local nếu cần."
echo "6. Xem xét các biện pháp bảo mật bổ sung (ví dụ: chứng chỉ SSL Let's Encrypt, cấu hình Nginx hardening,...)."
echo ""