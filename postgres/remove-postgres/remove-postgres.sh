#!/bin/bash

# =================================================================
# Script gỡ cài đặt PostgreSQL hoàn toàn khỏi AlmaLinux 8.x
# CẢNH BÁO: Script này sẽ XÓA VĨNH VIỄN tất cả dữ liệu PostgreSQL.
# Hãy chắc chắn bạn đã sao lưu trước khi chạy.
# =================================================================

echo "--- Bắt đầu quá trình gỡ cài đặt PostgreSQL ---"

# Bước 1: Dừng và vô hiệu hóa dịch vụ PostgreSQL
# Lệnh này sẽ tìm bất kỳ dịch vụ nào có tên 'postgresql' và dừng nó.
echo "--- Đang dừng và vô hiệu hóa dịch vụ PostgreSQL... ---"
sudo systemctl stop $(systemctl list-units --type=service --all | grep 'postgresql' | awk '{print $1}') 2>/dev/null || true
sudo systemctl disable $(systemctl list-units --type=service --all | grep 'postgresql' | awk '{print $1}') 2>/dev/null || true
echo "Dịch vụ đã được dừng."

# Bước 2: Gỡ cài đặt tất cả các gói liên quan đến PostgreSQL
# Sử dụng ký tự đại diện (*) để đảm bảo xóa tất cả các gói (server, libs, contrib, v.v.).
echo "--- Đang gỡ cài đặt các gói PostgreSQL... ---"
sudo dnf remove -y postgresql*
echo "Các gói đã được gỡ bỏ."

# Bước 3: Xóa thư mục dữ liệu và cấu hình của PostgreSQL
# Đây là bước quan trọng để xóa tất cả cơ sở dữ liệu và cấu hình còn lại.
echo "--- Đang xóa thư mục dữ liệu và cấu hình... ---"
sudo rm -rf /var/lib/pgsql
echo "Thư mục /var/lib/pgsql đã được xóa."

# Bước 4: Xóa người dùng hệ thống 'postgres'
# Gỡ cài đặt sẽ không tự động xóa người dùng này.
echo "--- Đang xóa người dùng hệ thống 'postgres'... ---"
# Lệnh 'userdel' có thể báo lỗi nếu người dùng không tồn tại, điều này là bình thường.
sudo userdel -r postgres 2>/dev/null || true
echo "Người dùng 'postgres' đã được xóa (nếu tồn tại)."

echo ""
echo "--- ✅ Quá trình gỡ cài đặt PostgreSQL đã hoàn tất! ---"