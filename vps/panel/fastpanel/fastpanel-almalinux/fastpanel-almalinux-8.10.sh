#!/bin/bash

# Kịch bản cài đặt FastPanel chi tiết cho AlmaLinux 8.10
# Website: https://fastpanel.direct/

echo "=================================================="
echo "  Kịch bản Cài đặt FastPanel cho AlmaLinux 8.10  "
echo "=================================================="
echo ""
echo "LƯU Ý QUAN TRỌNG:"
echo "- Kịch bản này được thiết kế cho AlmaLinux 8.10."
echo "- Nên chạy trên một hệ thống AlmaLinux 8.10 mới cài đặt (sạch) để tránh xung đột."
echo "- Toàn bộ quá trình cài đặt FastPanel sẽ do kịch bản chính thức của FastPanel xử lý."
echo "- Bạn sẽ cần kết nối Internet ổn định."
echo "- Quá trình cài đặt FastPanel có thể yêu cầu bạn nhập một số thông tin (ví dụ: email)."
echo ""

# Kiểm tra xem người dùng có phải là root hoặc có quyền sudo không
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ LỖI: Kịch bản này cần được chạy với quyền root hoặc sudo."
  echo "Vui lòng thử lại với lệnh: sudo $0"
  exit 1
fi

# Xác nhận trước khi tiếp tục
read -r -p "Bạn có chắc chắn muốn tiếp tục cài đặt FastPanel trên VPS AlmaLinux 8.10 này không? (y/N): " confirmation
if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
  echo "ℹ️  Đã hủy bởi người dùng. Thoát."
  exit 0
fi

echo ""
echo "▶️ Bước 1: Cập nhật hệ thống AlmaLinux 8.10..."
echo "   (Quá trình này có thể mất vài phút)"
sudo dnf update -y && sudo dnf upgrade -y
if [ $? -eq 0 ]; then
  echo "✅ Hệ thống đã được cập nhật thành công."
else
  echo "⚠️ CẢNH BÁO: Có lỗi xảy ra trong quá trình cập nhật hệ thống. Vui lòng kiểm tra và thử lại."
  # Mặc dù có lỗi cập nhật, vẫn có thể hỏi người dùng muốn tiếp tục không
  read -r -p "Bạn có muốn tiếp tục cài đặt FastPanel dù cập nhật hệ thống có lỗi không? (y/N): " continue_on_update_error
  if [[ "$continue_on_update_error" != "y" && "$continue_on_update_error" != "Y" ]]; then
    echo "ℹ️  Đã hủy cài đặt do lỗi cập nhật. Thoát."
    exit 1
  fi
  echo "ℹ️  Tiếp tục cài đặt FastPanel theo yêu cầu của người dùng dù có lỗi cập nhật."
fi

echo ""
echo "▶️ Bước 2: Kiểm tra và cài đặt 'wget' nếu cần..."
if ! command -v wget &> /dev/null; then
  echo "   'wget' không được tìm thấy. Đang tiến hành cài đặt..."
  sudo dnf install -y wget
  if [ $? -eq 0 ]; then
    echo "✅ 'wget' đã được cài đặt thành công."
  else
    echo "❌ LỖI: Không thể cài đặt 'wget'. Vui lòng cài đặt thủ công và chạy lại kịch bản."
    exit 1
  fi
else
  echo "✅ 'wget' đã có sẵn trên hệ thống."
fi

echo ""
echo "▶️ Bước 3: Tải về và thực thi kịch bản cài đặt chính thức của FastPanel..."
echo "   LƯU Ý: Quá trình này sẽ được thực hiện bởi kịch bản của FastPanel."
echo "   Vui lòng theo dõi kỹ các thông báo và hướng dẫn trên màn hình."
echo "   Bạn có thể sẽ cần nhập địa chỉ email để nhận thông tin quản trị."
echo ""
echo "   Nhấn ENTER để bắt đầu quá trình tải và cài đặt FastPanel..."
read -r
# Lệnh cài đặt chính thức từ FastPanel
wget http://installer.fastpanel.direct/install.sh -O - | bash

# Sau khi lệnh trên chạy, quyền kiểm soát sẽ thuộc về kịch bản của FastPanel.
# Kịch bản này sẽ kết thúc sau khi trình cài đặt của FastPanel được gọi.

echo ""
echo "=================================================="
echo "  Hoàn tất Khởi chạy Trình Cài đặt FastPanel  "
echo "=================================================="
echo ""
echo "ℹ️  Trình cài đặt FastPanel đã được khởi chạy."
echo "    Nếu quá trình tải kịch bản thành công, bạn sẽ thấy các bước cài đặt của FastPanel."
echo ""
echo "Sau khi FastPanel cài đặt hoàn tất:"
echo "  1. Bạn thường sẽ nhận được thông tin đăng nhập (URL, Tên người dùng, Mật khẩu)"
echo "     qua email đã đăng ký hoặc hiển thị trực tiếp trên màn hình."
echo "  2. Truy cập vào URL được cung cấp để bắt đầu sử dụng FastPanel."
echo ""
echo "Nếu có bất kỳ vấn đề nào với trình cài đặt của FastPanel, vui lòng tham khảo:"
echo "  - Tài liệu chính thức: https://fastpanel.direct/wiki/en"
echo "  - Hỗ trợ của FastPanel: https://fastpanel.direct/support"
echo ""
echo "Chúc bạn thành công!"
echo "=================================================="

exit 0