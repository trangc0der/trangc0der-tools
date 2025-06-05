#!/bin/bash

# Kịch bản cài đặt Docker Engine trên AlmaLinux 8.10

echo "🔵 Bắt đầu quá trình cài đặt Docker Engine cho AlmaLinux 8.10..."
echo "-----------------------------------------------------"

# --- KIỂM TRA QUYỀN ROOT ---
if [ "$(id -u)" -ne 0 ]; then
  echo "⚠️ Kịch bản này cần được chạy với quyền root hoặc sudo."
  echo "Vui lòng chạy lại với lệnh: sudo $0"
  exit 1
fi

# --- Bước 1: Gỡ cài đặt các phiên bản Docker cũ (nếu có) ---
echo "➡️  Bước 1: Gỡ cài đặt các phiên bản Docker cũ (nếu có)..."
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
echo "✅ Gỡ cài đặt các phiên bản cũ hoàn tất (bỏ qua nếu không có gì để gỡ)."
echo "-----------------------------------------------------"

# --- Bước 2: Cài đặt các gói cần thiết và thiết lập kho lưu trữ Docker ---
echo "➡️  Bước 2: Cài đặt các gói cần thiết và thiết lập kho lưu trữ Docker..."
sudo dnf install -y dnf-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Lỗi khi cài đặt các gói phụ thuộc. Vui lòng kiểm tra và thử lại."
    exit 1
fi

echo "   Thêm kho lưu trữ Docker CE..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
if [ $? -ne 0 ]; then
    echo "❌ Lỗi khi thêm kho lưu trữ Docker CE. Vui lòng kiểm tra và thử lại."
    exit 1
fi
echo "✅ Kho lưu trữ Docker CE đã được thêm."
echo "-----------------------------------------------------"

# --- Bước 3: Cài đặt Docker Engine ---
echo "➡️  Bước 3: Cài đặt Docker Engine, CLI, Containerd, và các plugin..."
# Cài đặt phiên bản ổn định mới nhất
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
if [ $? -ne 0 ]; then
    echo "❌ Lỗi khi cài đặt Docker Engine. Vui lòng kiểm tra và thử lại."
    exit 1
fi
echo "✅ Docker Engine và các thành phần liên quan đã được cài đặt."
echo "-----------------------------------------------------"

# --- Bước 4: Khởi động và kích hoạt Docker service ---
echo "➡️  Bước 4: Khởi động và kích hoạt Docker service..."
sudo systemctl start docker
if [ $? -ne 0 ]; then
    echo "❌ Lỗi khi khởi động Docker service."
    # Có thể thử enable trước rồi start
    sudo systemctl enable docker > /dev/null 2>&1
    sudo systemctl start docker
    if [ $? -ne 0 ]; then
        echo "❌ Vẫn lỗi khi khởi động Docker service sau khi đã enable. Vui lòng kiểm tra thủ công."
        exit 1
    fi
fi

sudo systemctl enable docker > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "⚠️ Cảnh báo: Không thể kích hoạt Docker service để khởi động cùng hệ thống."
fi
echo "✅ Docker service đã được khởi động và kích hoạt (nếu thành công)."
echo "-----------------------------------------------------"

# --- Bước 5: Xác minh cài đặt (tùy chọn) ---
echo "➡️  Bước 5: Xác minh cài đặt Docker..."
docker_version=$(docker --version)
if [ $? -eq 0 ]; then
  echo "🎉 Docker đã được cài đặt thành công! Phiên bản: ${docker_version}"
  echo "   Bạn có thể thử chạy container 'hello-world' để kiểm tra:"
  echo "   sudo docker run hello-world"
else
  echo "⚠️ Không thể xác minh phiên bản Docker. Có thể có lỗi trong quá trình cài đặt."
fi
echo "-----------------------------------------------------"

# --- Bước 6: Hướng dẫn cấu hình sau cài đặt (Chạy Docker không cần sudo) ---
echo "➡️  Bước 6: Hướng dẫn cấu hình sau cài đặt (Tùy chọn)..."
echo "   Để chạy lệnh 'docker' mà không cần 'sudo', bạn cần thêm người dùng của mình vào nhóm 'docker'."
echo "   Thực hiện các lệnh sau (thay thế 'your-user' bằng tên người dùng của bạn):"
echo ""
echo "     sudo groupadd docker  # Lệnh này có thể báo lỗi nếu nhóm đã tồn tại, không sao cả."
echo "     sudo usermod -aG docker \$USER"
echo ""
echo "   LƯU Ý: Sau khi chạy lệnh trên, bạn cần ĐĂNG XUẤT và ĐĂNG NHẬP LẠI (hoặc chạy 'newgrp docker')"
echo "   để các thay đổi về nhóm có hiệu lực."
echo "-----------------------------------------------------"
echo "✅ Hoàn tất kịch bản cài đặt Docker."