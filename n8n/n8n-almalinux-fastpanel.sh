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
    echo -e "${BLUE}*** Dev By MinhBee - trangc0der (modified)                      ***${NC}"
    echo -e "${BLUE}**********************************************************************${NC}"
}

# Ham kiem tra va xu ly loi
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Loi: $1${NC}"
        exit 1
    fi
}

# Ham cai dat Docker va Docker Compose
install_docker() {
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker da duoc cai dat.${NC}"
        return 0
    fi

    echo -e "${YELLOW}Dang cai dat Docker va Docker Compose...${NC}"
    
    sudo dnf install -y dnf-utils
    sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    check_error "Khong the cai dat Docker"
    
    # Cai dat Docker Compose (standalone de dam bao tuong thich)
    sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    check_error "Khong the cai dat Docker Compose"
    
    sudo systemctl enable docker
    sudo systemctl start docker
    
    echo -e "${CYAN}Dang cho Docker khoi dong...${NC}"
    timeout 30s bash -c 'until sudo docker info &>/dev/null; do sleep 2; done'
    check_error "Docker khong khoi dong duoc"
    
    echo -e "${GREEN}Docker va Docker Compose da san sang!${NC}"
}

# Ham cau hinh va khoi chay n8n
configure_n8n() {
    echo -e "${YELLOW}Dang cau hinh n8n...${NC}"
    
    # Tao thu muc
    mkdir -p ~/n8n_data
    cd ~/n8n_data || exit 1
    
    # Kiem tra neu docker-compose.yml da ton tai
    if [ -f "docker-compose.yml" ]; then
        echo -e -n "${YELLOW}Phat hien file docker-compose.yml cu. Ban co muon tao lai? (y/n)${NC} "
        read -r create_new
        if [[ ! "$create_new" =~ ^[Yy]$ ]]; then
            echo -e "${CYAN}Giu lai file cu. Khoi dong lai container...${NC}"
            sudo docker-compose up -d
            check_error "Khoi dong lai container that bai."
            return
        fi
    fi

    echo -e "${CYAN}Tao file docker-compose.yml...${NC}"
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
    depends_on:
      - postgres
    volumes:
      - ./n8n_local_data:/home/node/.n8n
    networks:
      - n8n-network

networks:
  n8n-network:

volumes:
  postgres_data:
  n8n_local_data:
EOL
    
    echo -e "${CYAN}Khoi chay n8n va postgres...${NC}"
    sudo docker-compose up -d
    check_error "Khong the khoi chay cac container"
    
    echo -e "${GREEN}Cai dat container n8n thanh cong!${NC}"
}

# Ham chinh
main() {
    set -e
    print_banner
    
    echo -e "${PURPLE}Vui long nhap cac thong tin de cau hinh n8n:${NC}"

    # ===== PHAN DA DUOC SUA LOI =====
    echo -e -n "${CYAN}Nhap domain ban se su dung (vi du: n8n.yourdomain.com): ${NC}"
    read DOMAIN
    
    echo -e -n "${CYAN}Nhap n8n user: ${NC}"
    read N8N_USER
    
    echo -e -n "${CYAN}Nhap n8n password: ${NC}"
    read -s N8N_PASS
    echo
    
    echo -e -n "${CYAN}Nhap ten database (vi du: n8n_db): ${NC}"
    read DB_NAME
    
    echo -e -n "${CYAN}Nhap user database: ${NC}"
    read DB_USER
    
    echo -e -n "${CYAN}Nhap mat khau database: ${NC}"
    read -s DB_PASS
    echo
    # ===== KET THUC PHAN SUA LOI =====

    if [[ -z "$DOMAIN" || -z "$N8N_USER" || -z "$N8N_PASS" || -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASS" ]]; then
        echo -e "${RED}Loi: Vui long cung cap tat ca thong tin can thiet${NC}"
        exit 1
    fi
    
    # Export de file YML co the su dung
    export DOMAIN N8N_USER N8N_PASS DB_NAME DB_USER DB_PASS
    
    echo -e "\n${PURPLE}Bat dau qua trinh cai dat...${NC}\n"
    
    install_docker
    configure_n8n
    
    echo -e "\n${GREEN}==================================================="
    echo "      BUOC 1 HOAN TAT: Da khoi chay n8n trong Docker!"
    echo "===================================================${NC}"
    echo -e "Thong tin cua ban:"
    echo -e "${CYAN}Domain:${NC} https://${DOMAIN}"
    echo -e "${CYAN}n8n User:${NC} ${N8N_USER}"
    echo -e "${CYAN}n8n Pass:${NC} *******"
    echo -e "${YELLOW}n8n dang chay tai dia chi local: http://127.0.0.1:5678${NC}"
    echo -e "\n${RED}VIEC CAN LAM TIEP THEO:${NC}"
    echo -e "${PURPLE}==> Thuc hien cac buoc cau hinh Reverse Proxy trong FastPanel!${NC}"
}

main