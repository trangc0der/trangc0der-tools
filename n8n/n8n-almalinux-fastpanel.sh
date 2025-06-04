#!/usr/bin/env bash

# Dinh nghia cac mau
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Hien thi banner
print_banner() {
    echo -e "${BLUE}**********************************************************************${NC}"
    echo -e "${BLUE}*** Kich ban cai dat n8n (Docker) cho may chu co FastPanel      ***${NC}"
    echo -e "${BLUE}*** Dev By trangc0der - MinhBee (modified)                     ***${NC}"
    echo -e "${BLUE}**********************************************************************${NC}"
}

# Ham kiem tra va xu ly loi
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Loi: $1${NC}"
        echo -e "${RED}Nhan Enter de thoat.${NC}"
        read < /dev/tty
        exit 1
    fi
}

# Ham cai dat Docker va Docker Compose
install_docker() {
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker da duoc cai dat.${NC}"
    else
        echo -e "${YELLOW}Dang cai dat Docker...${NC}"
        sudo dnf install -y dnf-utils
        check_error "Khong the cai dat dnf-utils"
        sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        check_error "Khong the them Docker repo"
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        check_error "Khong the cai dat Docker (bao gom docker-compose-plugin)"
        sudo systemctl enable docker
        check_error "Khong the kich hoat Docker service"
        sudo systemctl start docker
        check_error "Khong the khoi dong Docker service"
        echo -e "${CYAN}Dang cho Docker khoi dong...${NC}"
        timeout 30s bash -c 'until sudo docker info &>/dev/null; do sleep 2; done'
        check_error "Docker khong khoi dong duoc sau 30 giay"
        echo -e "${GREEN}Docker da san sang!${NC}"
    fi

    if ! sudo docker compose version &>/dev/null || ! command -v /usr/local/bin/docker-compose &>/dev/null ; then
        echo -e "${YELLOW}Dang cai dat/kiem tra Docker Compose (standalone)...${NC}"
        sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        check_error "Khong the tai Docker Compose (standalone)"
        sudo chmod +x /usr/local/bin/docker-compose
        check_error "Khong the cap quyen thuc thi cho Docker Compose (standalone)"
        echo -e "${GREEN}Docker Compose (standalone) da san sang tai /usr/local/bin/docker-compose!${NC}"
    else
        if sudo docker compose version &>/dev/null; then
             echo -e "${GREEN}Docker Compose plugin (docker compose) da duoc cai dat va chay duoc voi sudo.${NC}"
        fi
        if command -v /usr/local/bin/docker-compose &>/dev/null; then
            echo -e "${GREEN}Docker Compose (standalone) da duoc cai dat tai /usr/local/bin/docker-compose.${NC}"
        fi
    fi
}

# Ham dung va xoa container/volume (neu can)
cleanup_services_data() {
    echo -e "${YELLOW}Ban co muon xoa sach du lieu PostgreSQL cu va container de khoi tao lai?${NC}"
    echo -e "${RED}CANH BAO: Thao tac nay se XOA TOAN BO DU LIEU n8n va PostgreSQL hien tai (neu co).${NC}"
    echo -e -n "${CYAN}Chon (y/n): ${NC}"
    read -r confirm_cleanup < /dev/tty

    if [[ "$confirm_cleanup" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Dang dung va xoa cac container cu...${NC}"
        if sudo docker compose version &>/dev/null; then
            sudo docker compose down -v --remove-orphans # -v se xoa volume
        elif command -v /usr/local/bin/docker-compose &>/dev/null; then
            sudo /usr/local/bin/docker-compose down -v --remove-orphans # -v se xoa volume
        else
            echo -e "${RED}Khong tim thay lenh docker compose/docker-compose de dung service.${NC}"
        fi
        echo -e "${GREEN}Da dung va xoa container cung volume (neu co).${NC}"
        # Xoa thu muc data tren host de dam bao sach se
        if [ -d "./postgres_data" ]; then
            echo -e "${YELLOW}Dang xoa thu muc ./postgres_data tren host...${NC}"
            sudo rm -rf ./postgres_data
        fi
        if [ -d "./n8n_local_data" ]; then
            echo -e "${YELLOW}Dang xoa thu muc ./n8n_local_data tren host...${NC}"
            sudo rm -rf ./n8n_local_data
        fi
        echo -e "${GREEN}Da xoa thu muc data tren host.${NC}"
    else
        echo -e "${CYAN}Bo qua viec xoa du lieu cu. Se co gang khoi dong lai service.${NC}"
    fi
}


# Ham cau hinh va khoi chay n8n
configure_n8n() {
    echo -e "${YELLOW}Dang cau hinh n8n...${NC}"
    
    cd ~/n8n_data || { echo -e "${RED}Khong tim thay thu muc ~/n8n_data. Tao moi..."; mkdir -p ~/n8n_data; cd ~/n8n_data || exit 1; }

    # Hoi nguoi dung co muon xoa data cu khong
    cleanup_services_data

    # Luon tao lai file docker-compose.yml de dam bao cau hinh moi nhat
    echo -e "${CYAN}Tao/Cap nhat file docker-compose.yml...${NC}"
cat > docker-compose.yml <<EOL
services:
  postgres:
    image: postgres:15
    container_name: postgres_n8n
    restart: always
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASS}
      POSTGRES_DB: ${DB_NAME}
      TZ: Asia/Ho_Chi_Minh
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
    networks:
      - n8n-network

  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: always
    ports:
      - "127.0.0.1:5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${N8N_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_PASS}
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres_n8n
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${DB_NAME}
      - DB_POSTGRESDB_USER=${DB_USER}
      - DB_POSTGRESDB_PASSWORD=${DB_PASS}
      - N8N_HOST=${DOMAIN}
      - N8N_PROTOCOL=https
      - N8N_PORT=5678
      - WEBHOOK_URL=https://${DOMAIN}/
      - GENERIC_TIMEZONE=Asia/Ho_Chi_Minh
      - TZ=Asia/Ho_Chi_Minh
      - N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false # Bo qua canh bao quyen file config
    depends_on:
      - postgres
    volumes:
      - ./n8n_local_data:/home/node/.n8n 
    networks:
      - n8n-network

networks:
  n8n-network:

volumes:
  postgres_data: # Docker se tu tao volume nay neu no la named volume
  n8n_local_data: # Tuong tu
EOL
    
    # Tao thu muc data tren host NEU CHUA CO va set quyen
    echo -e "${CYAN}Dam bao quyen cho thu muc data...${NC}"
    if [ ! -d "./n8n_local_data" ]; then
        mkdir -p ./n8n_local_data # Them -p de tao neu parent chua co
        check_error "Khong the tao thu muc ./n8n_local_data"
    fi
    sudo chown -R 1000:1000 ./n8n_local_data
    check_error "Khong the thay doi quyen so huu cho ./n8n_local_data (cho user UID 1000)"

    if [ ! -d "./postgres_data" ]; then
        mkdir -p ./postgres_data
        check_error "Khong the tao thu muc ./postgres_data"
    fi
    # Khong can chown cho postgres_data, image postgres tu xu ly

    echo -e "${CYAN}Khoi chay/khoi dong lai n8n va postgres...${NC}"
    if sudo docker compose version &>/dev/null; then
        sudo docker compose up -d --remove-orphans --force-recreate # Them --force-recreate de dam bao container postgres duoc tao lai
    elif command -v /usr/local/bin/docker-compose &>/dev/null; then
        sudo /usr/local/bin/docker-compose up -d --remove-orphans --force-recreate
    else
        check_error "Khong tim thay lenh docker compose hoac docker-compose de khoi chay container."
    fi
    check_error "Khong the khoi chay cac container"
    
    echo -e "${GREEN}Cai dat/Khoi dong container n8n thanh cong!${NC}"
    echo -e "${YELLOW}Luu y: PostgreSQL co the can vai phut de khoi tao database lan dau.${NC}"
}

# Ham chinh
main() {
    set -e # Thoat ngay neu co loi
    print_banner
    
    echo -e "${PURPLE}Vui long nhap cac thong tin de cau hinh n8n:${NC}"

    echo -e -n "${CYAN}Nhap domain ban se su dung (vi du: n8n.yourdomain.com): ${NC}"
    read DOMAIN < /dev/tty
    
    echo -e -n "${CYAN}Nhap n8n user: ${NC}"
    read N8N_USER < /dev/tty
    
    echo -e -n "${CYAN}Nhap n8n password: ${NC}"
    read -s N8N_PASS < /dev/tty
    echo 
    
    echo -e -n "${CYAN}Nhap ten database (vi du: n8n_db): ${NC}"
    read DB_NAME < /dev/tty
    
    echo -e -n "${CYAN}Nhap user database: ${NC}"
    read DB_USER < /dev/tty
    
    echo -e -n "${CYAN}Nhap mat khau database: ${NC}"
    read -s DB_PASS < /dev/tty
    echo 

    if [[ -z "$DOMAIN" || -z "$N8N_USER" || -z "$N8N_PASS" || -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASS" ]]; then
        echo -e "${RED}Loi: Vui long cung cap tat ca thong tin can thiet${NC}"
        exit 1
    fi
    
    # Export bien de docker-compose.yml co the su dung
    export DB_USER DB_PASS DB_NAME N8N_USER N8N_PASS DOMAIN

    echo -e "\n${PURPLE}Bat dau qua trinh cai dat...${NC}\n"
    
    install_docker
    configure_n8n
    
    echo -e "\n${GREEN}==================================================="
    echo "      BUOC 1 HOAN TAT: Da khoi chay n8n trong Docker!"
    echo "===================================================${NC}"
    echo -e "Thong tin cua ban:"
    echo -e "${CYAN}Domain:${NC} https://${DOMAIN}"
    echo -e "${CYAN}n8n User:${NC} ${N8N_USER}"
    echo -e "${CYAN}n8n Pass:${NC} ******* (Da an)"
    echo -e "${CYAN}DB User:${NC} ${DB_USER}"
    echo -e "${CYAN}DB Pass:${NC} ******* (Da an)"
    echo -e "${CYAN}DB Name:${NC} ${DB_NAME}"
    echo -e "${YELLOW}n8n dang chay tai dia chi local: http://127.0.0.1:5678${NC}"
    echo -e "\n${RED}VIEC CAN LAM TIEP THEO:${NC}"
    echo -e "${PURPLE}==> Thuc hien cac buoc cau hinh Reverse Proxy trong FastPanel!${NC}"
    echo -e "${PURPLE}==> Kiem tra log Docker neu gap su co: sudo docker logs n8n${NC}"
    echo -e "${PURPLE}==> Doi vai phut de PostgreSQL khoi tao, sau do kiem tra lai.${NC}"
}

main
