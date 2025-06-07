#!/usr/bin/env bash

# --- Định nghĩa các màu ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# --- Hàm hiển thị banner ---
print_banner() {
    echo -e "${BLUE}**********************************************************************${NC}"
    echo -e "${BLUE}*** Kịch bản cài đặt SQL Server 2019 trên Docker                 ***${NC}"
    echo -e "${BLUE}*** Dev By trangc0der - MinhBee                                  ***${NC}"
    echo -e "${BLUE}**********************************************************************${NC}"
    echo # Dòng trống
}

# --- Hàm kiểm tra lỗi ---
# Sử dụng: check_error "Thông điệp lỗi nếu lệnh trước đó thất bại"
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}LỖI: $1${NC}" >&2
        echo -e "${RED}Vui lòng kiểm tra lại thông báo lỗi ở trên. Thoát kịch bản.${NC}" >&2
        exit 1
    fi
}

# --- Hàm kiểm tra và cài đặt Docker ---
install_docker_if_needed() {
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker đã được cài đặt. Bỏ qua bước cài đặt.${NC}"
        # Đảm bảo Docker service đang chạy
        if ! sudo systemctl is-active --quiet docker; then
            echo -e "${YELLOW}Docker service không hoạt động. Đang khởi động...${NC}"
            sudo systemctl start docker
            check_error "Không thể khởi động Docker service."
        fi
    else
        echo -e "${YELLOW}Docker chưa được cài đặt. Bắt đầu cài đặt...${NC}"
        # Sử dụng script tiện lợi của Docker để cài đặt
        curl -fsSL https://get.docker.com -o get-docker.sh
        check_error "Không thể tải về kịch bản cài đặt Docker."
        sudo sh get-docker.sh
        check_error "Cài đặt Docker thất bại."
        sudo systemctl enable docker
        check_error "Không thể kích hoạt Docker service."
        sudo systemctl start docker
        check_error "Không thể khởi động Docker service."
        rm get-docker.sh
        echo -e "${GREEN}Docker đã được cài đặt và khởi động thành công!${NC}"
    fi
    # Đợi Docker sẵn sàng
    echo -e "${CYAN}Đang chờ Docker daemon sẵn sàng...${NC}"
    timeout 30s bash -c 'until sudo docker info &>/dev/null; do sleep 1; done'
    check_error "Docker daemon không khởi động được sau 30 giây."
}

# --- Hàm dọn dẹp container và volume cũ ---
cleanup_instance() {
    echo -e "${PURPLE}--- Dọn dẹp môi trường cũ ---${NC}"
    echo -e "${YELLOW}Bạn có muốn xóa container và volume SQL Server cũ (nếu có) không?${NC}"
    echo -e "${RED}CẢNH BÁO: Thao tác này sẽ XÓA TOÀN BỘ DỮ LIỆU trong container và volume được chỉ định.${NC}"
    echo -e -n "${CYAN}Nhập 'yes' để xác nhận xóa: ${NC}"
    read -r confirm_cleanup < /dev/tty

    if [[ "$confirm_cleanup" == "yes" ]]; then
        echo -e "${YELLOW}Đang dừng và xóa container '${CONTAINER_NAME}'...${NC}"
        sudo docker stop "${CONTAINER_NAME}" > /dev/null 2>&1 || true
        sudo docker rm "${CONTAINER_NAME}" > /dev/null 2>&1 || true
        echo -e "${GREEN}Container đã được dọn dẹp.${NC}"

        echo -e "${YELLOW}Đang xóa volume '${VOLUME_NAME}'...${NC}"
        sudo docker volume rm "${VOLUME_NAME}" > /dev/null 2>&1 || true
        echo -e "${GREEN}Volume đã được dọn dẹp.${NC}"
    else
        echo -e "${CYAN}Bỏ qua việc dọn dẹp. Kịch bản sẽ tiếp tục.${NC}"
    fi
    echo # Dòng trống
}

# --- Hàm chính của chương trình ---
main() {
    set -o errexit  # Thoát ngay khi có lỗi
    set -o nounset  # Báo lỗi khi dùng biến chưa khai báo
    set -o pipefail # Trạng thái thoát của pipe là của lệnh cuối cùng thất bại

    print_banner

    # --- Lấy thông tin cấu hình từ người dùng ---
    echo -e "${PURPLE}Vui lòng cung cấp thông tin để cấu hình SQL Server:${NC}"

    read -p "$(echo -e ${CYAN}"Tên container sẽ tạo (mặc định: sql-server-2019): "${NC})" CONTAINER_NAME < /dev/tty
    CONTAINER_NAME=${CONTAINER_NAME:-sql-server-2019}

    read -p "$(echo -e ${CYAN}"Tên volume lưu dữ liệu (mặc định: sql-data-2019): "${NC})" VOLUME_NAME < /dev/tty
    VOLUME_NAME=${VOLUME_NAME:-sql-data-2019}

    read -p "$(echo -e ${CYAN}"Cổng trên máy host để kết nối (mặc định: 1433): "${NC})" HOST_PORT < /dev/tty
    HOST_PORT=${HOST_PORT:-1433}

    while true; do
        read -s -p "$(echo -e ${CYAN}"Nhập mật khẩu cho tài khoản 'sa' (yêu cầu mật khẩu mạnh): "${NC})" SA_PASSWORD < /dev/tty
        echo
        read -s -p "$(echo -e ${CYAN}"Xác nhận lại mật khẩu: "${NC})" SA_PASSWORD_CONFIRM < /dev/tty
        echo

        if [ "$SA_PASSWORD" = "$SA_PASSWORD_CONFIRM" ] && [ -n "$SA_PASSWORD" ]; then
            break
        else
            echo -e "${RED}Mật khẩu không khớp hoặc để trống. Vui lòng thử lại.${NC}"
        fi
    done
    echo # Dòng trống

    # --- Bắt đầu quá trình chính ---
    echo -e "${PURPLE}Bắt đầu quá trình kiểm tra và cài đặt...${NC}"
    install_docker_if_needed
    check_error "Quá trình kiểm tra/cài đặt Docker thất bại."

    cleanup_instance

    echo -e "${PURPLE}--- Triển khai SQL Server 2019 ---${NC}"
    echo -e "${YELLOW}Đang kéo image mcr.microsoft.com/mssql/server:2019-latest...${NC}"
    sudo docker pull mcr.microsoft.com/mssql/server:2019-latest
    check_error "Không thể kéo image SQL Server từ Microsoft Container Registry."

    echo -e "${YELLOW}Đang tạo và khởi chạy container '${CONTAINER_NAME}'...${NC}"
    sudo docker run --name "${CONTAINER_NAME}" \
        -e "ACCEPT_EULA=Y" \
        -e "MSSQL_SA_PASSWORD=${SA_PASSWORD}" \
        -p "${HOST_PORT}:1433" \
        -v "${VOLUME_NAME}:/var/opt/mssql" \
        -d mcr.microsoft.com/mssql/server:2019-latest
    check_error "Không thể khởi chạy container SQL Server."

    echo -e "${CYAN}Đang chờ container khởi động và ổn định...${NC}"
    sleep 15

    # --- Hiển thị thông tin tổng kết ---
    echo
    echo -e "${GREEN}==================================================="
    echo -e "${GREEN}   CÀI ĐẶT SQL SERVER 2019 THÀNH CÔNG!          "
    echo -e "${GREEN}===================================================${NC}"
    echo -e "Thông tin kết nối:"
    echo -e "${CYAN}  Server/Host:  ${NC} localhost,${HOST_PORT}"
    echo -e "${CYAN}  Tài khoản:    ${NC} sa"
    echo -e "${CYAN}  Mật khẩu:     ${NC} ******* (đã ẩn)"
    echo -e "---------------------------------------------------"
    echo -e "Thông tin Docker:"
    echo -e "${CYAN}  Tên Container:${NC} ${CONTAINER_NAME}"
    echo -e "${CYAN}  Tên Volume:   ${NC} ${VOLUME_NAME} (dữ liệu của bạn được lưu ở đây)"
    echo
    echo -e "${PURPLE}Sử dụng lệnh sau để xem logs: sudo docker logs ${CONTAINER_NAME}${NC}"
    echo -e "${PURPLE}Sử dụng lệnh sau để dừng: sudo docker stop ${CONTAINER_NAME}${NC}"
    echo -e "${PURPLE}Sử dụng lệnh sau để khởi động lại: sudo docker start ${CONTAINER_NAME}${NC}"
    echo
}

# --- Chạy hàm main ---
main