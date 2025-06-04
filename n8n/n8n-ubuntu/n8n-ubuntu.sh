#!/usr/bin/env bash

# Dinh nghia cac mau
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Hien thi banner voi mau sac
print_banner() {
    echo -e "${BLUE}****************************************************************************************${NC}"
    echo -e "${BLUE}******                                                                          ********${NC}"
    echo -e "${BLUE}******                 File bash ho tro cau hinh n8n tu dong                    ********${NC}"
    echo -e "${BLUE}******              Dev By trangc0der - MinhBee (modified)                      ********${NC}"
    echo -e "${BLUE}******          Phien ban ho tro ubuntu, su dung docker va PostgreSQL           ********${NC}"
    echo -e "${BLUE}******                                                                          ********${NC}"
    echo -e "${BLUE}****************************************************************************************${NC}"
}

# Ham kiem tra va xu ly loi
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Loi: $1${NC}"
        exit 1
    fi
}

# Ham lay dia chi IP cua may chu
get_server_ip() {
    SERVER_IP=$(curl -s ifconfig.me)
    if [ -z "$SERVER_IP" ]; then
        SERVER_IP=$(hostname -I | awk '{print $1}')
    fi
    echo "$SERVER_IP"
}

# Ham tinh tong cac chu so trong IP
calculate_ip_sum() {
    local ip=$1
    local sum=0
    
    # Thay the dau cham bang khoang trang
    ip_digits=$(echo "$ip" | tr '.' ' ')
    
    # Tinh tong
    for digit in $ip_digits; do
        sum=$((sum + digit))
    done
    
    echo "$sum"
}

# Ham kiem tra domain co tro den IP may chu khong - su dung cac cong cu co san
check_domain_ip() {
    local domain=$1
    local server_ip=$2
    
    echo -e "${YELLOW}Kiem tra domain $domain...${NC}"
    
    # Kiem tra bang ping
    echo -e "${CYAN}Kiem tra bang ping...${NC}"
    ping_output=$(ping -c 1 "$domain" 2>/dev/null)
    if [ $? -eq 0 ]; then
        ping_ip=$(echo "$ping_output" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)
        echo -e "${CYAN}IP tu ping:${NC} $ping_ip"
        
        if [ "$ping_ip" = "$server_ip" ]; then
            echo -e "${GREEN}Domain $domain da tro den IP may chu $server_ip theo kiem tra ping.${NC}"
            return 0
        fi
    else
        echo -e "${YELLOW}Khong the ping den $domain${NC}"
    fi
    
    # Kiem tra bang host
    if command -v host &> /dev/null; then
        echo -e "${CYAN}Kiem tra bang host...${NC}"
        host_output=$(host "$domain" 2>/dev/null)
        if [ $? -eq 0 ]; then
            host_ip=$(echo "$host_output" | grep "has address" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)
            echo -e "${CYAN}IP tu host:${NC} $host_ip"
            
            if [ "$host_ip" = "$server_ip" ]; then
                echo -e "${GREEN}Domain $domain da tro den IP may chu $server_ip theo kiem tra host.${NC}"
                return 0
            fi
        else
            echo -e "${YELLOW}Khong the dung host de kiem tra $domain${NC}"
        fi
    fi
    
    # Kiem tra bang nslookup
    if command -v nslookup &> /dev/null; then
        echo -e "${CYAN}Kiem tra bang nslookup...${NC}"
        nslookup_output=$(nslookup "$domain" 2>/dev/null)
        if [ $? -eq 0 ]; then
            nslookup_ip=$(echo "$nslookup_output" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | tail -1)
            echo -e "${CYAN}IP tu nslookup:${NC} $nslookup_ip"
            
            if [ "$nslookup_ip" = "$server_ip" ]; then
                echo -e "${GREEN}Domain $domain da tro den IP may chu $server_ip theo kiem tra nslookup.${NC}"
                return 0
            fi
        else
            echo -e "${YELLOW}Khong the dung nslookup de kiem tra $domain${NC}"
        fi
    fi
    
    # Kiem tra bang getent
    if command -v getent &> /dev/null; then
        echo -e "${CYAN}Kiem tra bang getent...${NC}"
        getent_output=$(getent hosts "$domain" 2>/dev/null)
        if [ $? -eq 0 ]; then
            getent_ip=$(echo "$getent_output" | awk '{print $1}')
            echo -e "${CYAN}IP tu getent:${NC} $getent_ip"
            
            if [ "$getent_ip" = "$server_ip" ]; then
                echo -e "${GREEN}Domain $domain da tro den IP may chu $server_ip theo kiem tra getent.${NC}"
                return 0
            fi
        else
            echo -e "${YELLOW}Khong the dung getent de kiem tra $domain${NC}"
        fi
    fi
    
    # Neu khong co phuong phap nao khop
    echo -e "${RED}Canh bao: Domain $domain khong tro den IP may chu $server_ip theo bat ky phuong phap nao.${NC}"
    echo -e "${YELLOW}Ban co the da cap nhat DNS gan day nhung chua lan truyen.${NC}"
    echo -e "${YELLOW}Ban co muon:${NC}"
    echo -e "${CYAN}1. Kiem tra lai${NC}"
    echo -e "${CYAN}2. Bo qua kiem tra (dung khi ban chac chan da cau hinh DNS dung)${NC}"
    echo -e "${CYAN}3. Huy cai dat${NC}"
    read -p "$(echo -e ${CYAN}Lua chon cua ban [1/2/3]: ${NC})" dns_choice
    
    if [ "$dns_choice" = "1" ]; then
        # Kiem tra lai
        echo -e "${YELLOW}Dang kiem tra lai...${NC}"
        check_domain_ip "$domain" "$server_ip"
    elif [ "$dns_choice" = "2" ]; then
        # Bo qua kiem tra
        echo -e "${YELLOW}Bo qua kiem tra DNS. Tiep tuc cai dat...${NC}"
        return 0
    else
        # Huy cai dat
        echo -e "${RED}Qua trinh cai dat bi huy. Vui long cau hinh DNS truoc khi thu lai.${NC}"
        exit 1
    fi
}

# Ham xoa sach cai dat cu
clean_previous_installation() {
    echo -e "${YELLOW}Dang xoa sach cai dat cu...${NC}"
    
    # Dung va xoa container
    echo -e "${CYAN}Dung va xoa container...${NC}"
    docker stop n8n postgres 2>/dev/null || true
    docker rm n8n postgres 2>/dev/null || true
    
    # Xoa toan bo volume
    echo -e "${CYAN}Xoa volume Docker...${NC}"
    docker volume rm n8n_data postgres_data n8n_data_postgres_data 2>/dev/null || true
    
    # Xoa toan bo network
    echo -e "${CYAN}Xoa network Docker...${NC}"
    docker network rm n8n-network 2>/dev/null || true
    docker network prune -f 2>/dev/null || true
    
    # Xoa thu muc n8n_data
    if [ -d "$HOME/n8n_data" ]; then
        echo -e "${CYAN}Xoa thu muc n8n_data...${NC}"
        rm -rf "$HOME/n8n_data"
    fi
    
    # Xoa cau hinh Nginx
    if [ -f "/etc/nginx/sites-available/n8n" ]; then
        echo -e "${CYAN}Xoa cau hinh Nginx...${NC}"
        sudo rm -f /etc/nginx/sites-available/n8n
        sudo rm -f /etc/nginx/sites-enabled/n8n
        sudo systemctl reload nginx
    fi
    
    # Xoa toan bo Docker image lien quan (tuy chon)
    echo -e "${RED}Ban co muon xoa Docker image n8n va PostgreSQL? (y/n): ${NC}"
    read remove_images
    if [[ "$remove_images" =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}Xoa Docker image...${NC}"
        docker rmi n8nio/n8n:latest postgres:15 2>/dev/null || true
    fi
    
    echo -e "${GREEN}Da xoa sach cai dat cu.${NC}"
}

# Ham kiem tra cai dat truoc do
check_previous_installation() {
    local reinstall=false
    
    echo -e "${YELLOW}Dang kiem tra cai dat truoc do...${NC}"
    
    # Kiem tra Docker
    if command -v docker &> /dev/null; then
        # Kiem tra n8n container
        if docker ps -a | grep -q "n8n"; then
            echo -e "${CYAN}Container n8n da ton tai.${NC}"
            reinstall=true
        fi
        
        # Kiem tra PostgreSQL container
        if docker ps -a | grep -q "postgres"; then
            echo -e "${CYAN}Container PostgreSQL da ton tai.${NC}"
            reinstall=true
        fi
        
        # Kiem tra volume
        if docker volume ls | grep -q "n8n_data\|postgres_data"; then
            echo -e "${CYAN}Volume Docker da ton tai.${NC}"
            reinstall=true
        fi
    fi
    
    # Kiem tra Nginx config cho n8n
    if [ -f "/etc/nginx/sites-available/n8n" ]; then
        echo -e "${CYAN}Cau hinh Nginx cho n8n da ton tai.${NC}"
        reinstall=true
    fi
    
    # Kiem tra thu muc n8n_data
    if [ -d "$HOME/n8n_data" ]; then
        echo -e "${CYAN}Thu muc n8n_data da ton tai.${NC}"
        reinstall=true
    fi
    
    if [ "$reinstall" = true ]; then
        echo -e "${RED}Phat hien cai dat truoc do. De tranh loi, can xoa sach cai dat cu.${NC}"
        echo -e "${YELLOW}Ban co muon:${NC}"
        echo -e "${CYAN}1. Xoa sach va cai dat moi${NC}"
        echo -e "${CYAN}2. Huy cai dat${NC}"
        read -p "$(echo -e ${CYAN}Lua chon cua ban [1/2]: ${NC})" reinstall_choice
        
        if [ "$reinstall_choice" = "1" ]; then
            # Xoa sach cai dat cu
            clean_previous_installation
        else
            # Huy cai dat
            echo -e "${RED}Qua trinh cai dat bi huy.${NC}"
            exit 0
        fi
    else
        echo -e "${GREEN}Khong phat hien cai dat truoc do. Tien hanh cai dat moi...${NC}"
    fi
}

# Ham cai dat mui gio
configure_timezone() {
    echo -e "${YELLOW}Dang cau hinh mui gio GMT+7 (Ho Chi Minh)...${NC}"
    
    # Kiem tra mui gio hien tai
    current_timezone=$(timedatectl | grep "Time zone" | awk '{print $3}')
    
    if [ "$current_timezone" = "Asia/Ho_Chi_Minh" ]; then
        echo -e "${GREEN}Mui gio da duoc cai dat thanh Asia/Ho_Chi_Minh.${NC}"
    else
        # Cai dat mui gio cho he thong
        sudo timedatectl set-timezone Asia/Ho_Chi_Minh
        check_error "Khong the cai dat mui gio cho he thong"
        
        # Hien thi mui gio hien tai de xac nhan
        echo -e "${GREEN}Mui gio hien tai: $(timedatectl | grep "Time zone")${NC}"
    fi
}

# Ham cai dat cac goi can thiet
install_dependencies() {
    echo -e "${YELLOW}Dang cai dat cac goi can thiet...${NC}"
    
    # Kiem tra Nginx da duoc cai dat chua
    if command -v nginx &> /dev/null; then
        echo -e "${GREEN}Nginx da duoc cai dat.${NC}"
    else
        echo -e "${CYAN}Cai dat Nginx...${NC}"
        sudo apt update
        sudo apt install -y nginx
        check_error "Khong the cai dat Nginx"
    fi
    
    # Kiem tra ca-certificates va curl
    if ! command -v curl &> /dev/null; then
        echo -e "${CYAN}Cai dat curl va ca-certificates...${NC}"
        sudo apt update
        sudo apt install -y ca-certificates curl gnupg
        check_error "Khong the cai dat curl va ca-certificates"
    fi
    
    echo -e "${GREEN}Cai dat cac goi can thiet thanh cong!${NC}"
}

# Ham cai dat Docker va Docker Compose
install_docker() {
    # Kiem tra Docker da duoc cai dat chua
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker da duoc cai dat.${NC}"
        
        # Kiem tra Docker dang chay
        if systemctl is-active --quiet docker; then
            echo -e "${GREEN}Docker dang chay.${NC}"
        else
            echo -e "${YELLOW}Docker da cai dat nhung khong chay. Dang khoi dong Docker...${NC}"
            sudo systemctl start docker
            sudo systemctl enable docker
            check_error "Khong the khoi dong Docker"
        fi
        
        # Kiem tra Docker Compose
        if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
            echo -e "${GREEN}Docker Compose da duoc cai dat.${NC}"
        else
            echo -e "${YELLOW}Docker da cai dat nhung khong tim thay Docker Compose. Dang cai dat Docker Compose...${NC}"
            # Cai dat Docker Compose
            sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            check_error "Khong the cai dat Docker Compose"
        fi
    else
        echo -e "${YELLOW}Dang cai dat Docker va Docker Compose...${NC}"
        
        # Tao thu muc keyrings neu chua co
        sudo install -m 0755 -d /etc/apt/keyrings
        
        # Them khoa GPG cua Docker
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        
        # Them repository cua Docker
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # Cap nhat va cai dat Docker
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        check_error "Khong the cai dat Docker"
        
        # Cai dat Docker Compose
        sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        check_error "Khong the cai dat Docker Compose"
        
        # Bat Docker khoi dong cung he thong
        sudo systemctl enable docker
        sudo systemctl start docker
        
        # Kiem tra Docker da chay chua
        echo -e "${CYAN}Dang cho Docker khoi dong...${NC}"
        timeout 30s bash -c 'until sudo docker info &>/dev/null; do echo -e "\033[0;36mDang cho Docker khoi dong...\033[0m"; sleep 2; done'
        check_error "Docker khong khoi dong duoc"
    fi
    
    echo -e "${GREEN}Docker va Docker Compose da san sang!${NC}"
}

# Ham cau hinh n8n voi Docker Compose
configure_n8n() {
    echo -e "${YELLOW}Dang cau hinh n8n...${NC}"
    
    # Tao thu muc cho n8n va chuyen vao thu muc do
    mkdir -p ~/n8n_data
    cd ~/n8n_data || exit 1
    
    echo -e "${CYAN}Tao file docker-compose.yml...${NC}"
    # Tao file docker-compose.yml voi cau hinh dung
    cat > docker-compose.yml <<EOL

services:
  postgres:
    image: postgres:15
    container_name: postgres
    restart: always
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASS}
      POSTGRES_DB: ${DB_NAME}
      TZ: Asia/Ho_Chi_Minh
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 5
    command: postgres -c 'timezone=Asia/Ho_Chi_Minh'
    networks:
      - n8n-network

  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${N8N_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_PASS}
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${DB_NAME}
      - DB_POSTGRESDB_USER=${DB_USER}
      - DB_POSTGRESDB_PASSWORD=${DB_PASS}
      - N8N_HOST=${DOMAIN}
      - N8N_PROTOCOL=https
      - N8N_PORT=5678
      - WEBHOOK_URL=https://${DOMAIN}/
      - N8N_EDITOR_BASE_URL=https://${DOMAIN}/
      - N8N_PUBLIC_API_HOST=${DOMAIN}
      - VUE_APP_URL_BASE_API=https://${DOMAIN}/
      - GENERIC_TIMEZONE=Asia/Ho_Chi_Minh
      - TZ=Asia/Ho_Chi_Minh
      - N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - n8n_data:/home/node/.n8n
    networks:
      - n8n-network

networks:
  n8n-network:
    driver: bridge

volumes:
  postgres_data:
  n8n_data:
EOL
    
    # Khoi chay PostgreSQL truoc
    echo -e "${CYAN}Khoi chay PostgreSQL...${NC}"
    sudo docker-compose up -d postgres
    check_error "Khong the khoi chay PostgreSQL"
    
    # Doi cho PostgreSQL khoi dong hoan tat
    echo -e "${CYAN}Doi PostgreSQL khoi dong hoan tat...${NC}"
    sleep 15
    
    # Khoi chay n8n
    echo -e "${CYAN}Khoi chay n8n...${NC}"
    sudo docker-compose up -d n8n
    check_error "Khong the khoi chay n8n"
    
    # Kiem tra container da chay chua
    echo -e "${CYAN}Dang cho n8n container khoi dong...${NC}"
    timeout 60s bash -c 'until sudo docker ps | grep -q n8n; do echo -e "\033[0;36mDang cho n8n container khoi dong...\033[0m"; sleep 5; done'
    check_error "n8n container khong chay"
    
    echo -e "${GREEN}Cau hinh n8n thanh cong!${NC}"
}

# Ham cau hinh Nginx
configure_nginx() {
    echo -e "${YELLOW}Dang cau hinh Nginx...${NC}"
    
    # Kiem tra cau hinh Nginx da ton tai chua
    if [ -f "/etc/nginx/sites-available/n8n" ]; then
        echo -e "${CYAN}Cau hinh Nginx cho n8n da ton tai. Dang cap nhat...${NC}"
        # Sao luu cau hinh cu
        sudo cp /etc/nginx/sites-available/n8n /etc/nginx/sites-available/n8n.bak
    fi
    
    # Tao file cau hinh Nginx cho n8n
    echo -e "${CYAN}Tao file cau hinh Nginx...${NC}"
    sudo tee /etc/nginx/sites-available/n8n > /dev/null <<EOL
server {
    server_name ${DOMAIN};

    location / {
        proxy_pass http://localhost:5678;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # Ho tro WebSocket
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";

        # Giam timeout tranh mat ket noi
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;
        send_timeout 600;
    }

    # Gzip
    gzip on;
    gzip_comp_level 4;
    gzip_min_length 1000;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}

server {
    listen 80;
    server_name ${DOMAIN};
    return 301 https://\$host\$request_uri;
}
EOL
    
    # Tao symlink de kich hoat site
    sudo ln -sf /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
    
    # Kiem tra va reload Nginx
    echo -e "${CYAN}Kiem tra cau hinh Nginx...${NC}"
    sudo nginx -t
    check_error "Cau hinh Nginx khong hop le"
    
    echo -e "${CYAN}Khoi dong lai Nginx...${NC}"
    sudo systemctl restart nginx
    check_error "Khong the khoi dong lai Nginx"
    
    echo -e "${GREEN}Cau hinh Nginx thanh cong!${NC}"
}

# Ham cai dat SSL
install_ssl() {
    echo -e "${YELLOW}Dang cai dat SSL...${NC}"
    
    # Kiem tra Certbot da duoc cai dat chua
    if ! command -v certbot &> /dev/null; then
        echo -e "${CYAN}Cai dat Certbot...${NC}"
        sudo apt install -y certbot python3-certbot-nginx
        check_error "Khong the cai dat Certbot"
    else
        echo -e "${GREEN}Certbot da duoc cai dat.${NC}"
    fi
    
    # Kiem tra xem SSL da duoc cai dat cho domain nay chua
    if sudo certbot certificates | grep -q "$DOMAIN"; then
        echo -e "${CYAN}SSL certificate cho domain $DOMAIN da ton tai. Kiem tra han su dung...${NC}"
        # Kiem tra han su dung
        expiry_date=$(sudo certbot certificates | grep -A 2 "$DOMAIN" | grep "Expiry Date" | awk '{print $3, $4, $5, $6}')
        echo -e "${CYAN}SSL certificate het han vao: $expiry_date${NC}"
        
        # Kiem tra cau hinh Nginx co SSL hay khong
        if ! grep -q "ssl_certificate" /etc/nginx/sites-available/n8n; then
            echo -e "${RED}Phat hien chung chi SSL ton tai nhung chua duoc cau hinh trong Nginx.${NC}"
            echo -e "${YELLOW}Ban co muon xoa chung chi cu va cai dat lai SSL? (y/n): ${NC}"
            read reinstall_ssl
            
            if [[ "$reinstall_ssl" =~ ^[Yy]$ ]]; then
                echo -e "${CYAN}Dang xoa chung chi SSL cu...${NC}"
                sudo certbot delete --cert-name "$DOMAIN" --non-interactive
                
                echo -e "${CYAN}Dang cai dat lai SSL...${NC}"
                sudo certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m "${EMAIL}" --redirect
                check_error "Khong the cai dat SSL certificate"
                
                # Kiem tra lai cau hinh Nginx
                if grep -q "ssl_certificate" /etc/nginx/sites-available/n8n; then
                    echo -e "${GREEN}Da cai dat va cau hinh SSL thanh cong.${NC}"
                else
                    echo -e "${RED}Cau hinh SSL van chua duoc them vao Nginx. Dang them thu cong...${NC}"
                    add_ssl_config_manually
                fi
            else
                echo -e "${YELLOW}Dang them cau hinh SSL vao Nginx thu cong...${NC}"
                add_ssl_config_manually
            fi
        else
            # Neu muon cap nhat, co the su dung certbot renew
            echo -e "${CYAN}Ban co muon cap nhat SSL certificate? (y/n): ${NC}"
            read renew_ssl
            
            if [[ "$renew_ssl" =~ ^[Yy]$ ]]; then
                echo -e "${CYAN}Dang cap nhat SSL certificate...${NC}"
                sudo certbot renew --force-renewal -d "$DOMAIN"
                check_error "Khong the cap nhat SSL certificate"
            else
                echo -e "${GREEN}Giu nguyen SSL certificate hien tai.${NC}"
            fi
        fi
    else
        echo -e "${CYAN}Dang cai dat SSL cho domain ${DOMAIN}...${NC}"
        sudo certbot --nginx -d "${DOMAIN}" --non-interactive --agree-tos -m "${EMAIL}" --redirect
        check_error "Khong the cai dat SSL certificate"
        
        # Kiem tra lai cau hinh Nginx
        if ! grep -q "ssl_certificate" /etc/nginx/sites-available/n8n; then
            echo -e "${RED}Cau hinh SSL chua duoc them vao Nginx. Dang them thu cong...${NC}"
            add_ssl_config_manually
        fi
    fi
    
    # Tu dong gia han SSL - kiem tra xem da co trong crontab chua
    if ! sudo grep -q "certbot renew" /etc/crontab; then
        echo -e "${CYAN}Cau hinh tu dong gia han SSL...${NC}"
        echo "0 3 * * * /usr/bin/certbot renew --quiet" | sudo tee -a /etc/crontab > /dev/null
    else
        echo -e "${GREEN}Tu dong gia han SSL da duoc cau hinh.${NC}"
    fi
    
    echo -e "${GREEN}Cai dat SSL thanh cong!${NC}"
}

# Ham them cau hinh SSL vao Nginx thu cong
add_ssl_config_manually() {
    echo -e "${CYAN}Dang them cau hinh SSL vao Nginx thu cong...${NC}"
    
    # Kiem tra duong dan chung chi
    ssl_cert_path="/etc/letsencrypt/live/${DOMAIN}/fullchain.pem"
    ssl_key_path="/etc/letsencrypt/live/${DOMAIN}/privkey.pem"
    
    if [ ! -f "$ssl_cert_path" ] || [ ! -f "$ssl_key_path" ]; then
        echo -e "${RED}Khong tim thay chung chi SSL tai duong dan mong doi.${NC}"
        echo -e "${YELLOW}Duong dan chung chi: $ssl_cert_path${NC}"
        echo -e "${YELLOW}Duong dan khoa: $ssl_key_path${NC}"
        
        # Cai dat lai SSL
        echo -e "${YELLOW}Dang cai dat lai SSL...${NC}"
        sudo certbot --nginx -d "${DOMAIN}" --non-interactive --agree-tos -m "${EMAIL}" --redirect
        check_error "Khong the cai dat SSL certificate"
        
        # Kiem tra lai cau hinh Nginx
        if grep -q "ssl_certificate" /etc/nginx/sites-available/n8n; then
            echo -e "${GREEN}Da cai dat va cau hinh SSL thanh cong.${NC}"
            return 0
        fi
    fi
    
    # Tao file cau hinh Nginx moi voi SSL
    sudo tee /etc/nginx/sites-available/n8n > /dev/null <<EOL
server {
    server_name ${DOMAIN};
    
    listen 443 ssl;
    ssl_certificate ${ssl_cert_path};
    ssl_certificate_key ${ssl_key_path};
    
    # Cac thong so SSL toi uu
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;

    location / {
        proxy_pass http://localhost:5678;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # Ho tro WebSocket
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";

        # Giam timeout tranh mat ket noi
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;
        send_timeout 600;
    }

    # Gzip
    gzip on;
    gzip_comp_level 4;
    gzip_min_length 1000;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}

server {
    listen 80;
    server_name ${DOMAIN};
    return 301 https://\$host\$request_uri;
}
EOL

    # Kiem tra cau hinh Nginx
    echo -e "${CYAN}Kiem tra cau hinh Nginx...${NC}"
    sudo nginx -t
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Cau hinh Nginx voi SSL thanh cong!${NC}"
        sudo systemctl restart nginx
    else
        echo -e "${RED}Cau hinh Nginx khong hop le. Vui long kiem tra lai.${NC}"
        return 1
    fi
}

# Ham kiem tra n8n hoat dong
check_n8n_health() {
    echo -e "${YELLOW}Kiem tra n8n hoat dong...${NC}"
    
    # Doi 10 giay cho n8n khoi dong hoan tat
    sleep 10
    
    # Kiem tra n8n co dang chay khong
    if docker ps | grep -q "n8n"; then
        echo -e "${GREEN}n8n container dang chay.${NC}"
        
        # Kiem tra ket noi den PostgreSQL
        echo -e "${CYAN}Kiem tra logs n8n...${NC}"
        n8n_logs=$(docker logs n8n 2>&1 | tail -n 20)
        
        if echo "$n8n_logs" | grep -q "Error connecting to database"; then
            echo -e "${RED}Phat hien loi ket noi database trong logs n8n.${NC}"
            echo -e "${YELLOW}Dang thu khoi dong lai n8n...${NC}"
            docker restart n8n
            sleep 10
            
            # Kiem tra lai sau khi khoi dong lai
            n8n_logs_after=$(docker logs n8n 2>&1 | tail -n 20)
            if echo "$n8n_logs_after" | grep -q "Error connecting to database"; then
                echo -e "${RED}Van con loi ket noi database sau khi khoi dong lai.${NC}"
                echo -e "${YELLOW}Xem logs chi tiet:${NC}"
                docker logs n8n | tail -n 50
            else
                echo -e "${GREEN}n8n da ket noi thanh cong den database sau khi khoi dong lai.${NC}"
            fi
        else
            echo -e "${GREEN}Khong phat hien loi trong logs n8n.${NC}"
        fi
    else
        echo -e "${RED}n8n container khong chay.${NC}"
        echo -e "${YELLOW}Dang thu khoi dong lai n8n...${NC}"
        docker start n8n
        sleep 10
        
        if docker ps | grep -q "n8n"; then
            echo -e "${GREEN}n8n container da duoc khoi dong lai thanh cong.${NC}"
        else
            echo -e "${RED}Khong the khoi dong lai n8n container.${NC}"
            echo -e "${YELLOW}Xem logs chi tiet:${NC}"
            docker logs n8n
        fi
    fi
}

# Ham chinh
main() {
    set -e  # Dung script neu co lenh nao loi
    
    print_banner
    
    # Lay IP may chu
    SERVER_IP=$(get_server_ip)
    echo -e "${YELLOW}IP may chu cua ban la: ${SERVER_IP}${NC}"
    
    # Tinh tong cac chu so trong IP
    IP_SUM=$(calculate_ip_sum "$SERVER_IP")
    
    # Kiem tra cai dat truoc do
    check_previous_installation
    
	# Hoi nguoi dung de dien thong tin
    echo -e "${PURPLE}Vui long nhap cac thong tin cau hinh:${NC}"
    
    # Nhap va kiem tra domain
    while true; do
        read -p "$(echo -e ${CYAN}Nhap domain cua ban: ${NC})" DOMAIN
        if [ -z "$DOMAIN" ]; then
            echo -e "${RED}Domain khong duoc de trong. Vui long nhap lai.${NC}"
            continue
        fi
        
        # Kiem tra domain co tro den IP may chu khong
        if check_domain_ip "$DOMAIN" "$SERVER_IP"; then
            break
        fi
    done
    
    # Hien thi lua chon che do cai dat
    echo -e "${PURPLE}Chon che do cai dat:${NC}"
    echo -e "${CYAN}1. Chay thu cong (nhap thong tin)${NC}"
    echo -e "${CYAN}2. Chay tu dong (tu dong tao thong tin)${NC}"
    read -p "$(echo -e ${CYAN}Lua chon cua ban [1/2]: ${NC})" setup_mode
    
    if [ "$setup_mode" = "1" ]; then
        # Che do thu cong
        echo -e "${YELLOW}Ban da chon che do cai dat thu cong.${NC}"
        read -p "$(echo -e ${CYAN}Nhap email cua ban: ${NC})" EMAIL
        read -p "$(echo -e ${CYAN}Nhap n8n user: ${NC})" N8N_USER
        read -s -p "$(echo -e ${CYAN}Nhap n8n password: ${NC})" N8N_PASS
        echo
        read -p "$(echo -e ${CYAN}Nhap ten database: ${NC})" DB_NAME
        read -p "$(echo -e ${CYAN}Nhap user database: ${NC})" DB_USER
        read -s -p "$(echo -e ${CYAN}Nhap mat khau database: ${NC})" DB_PASS
        echo
    else
        # Che do tu dong
        echo -e "${YELLOW}Ban da chon che do cai dat tu dong.${NC}"
        
        # Tao thong tin tu dong
        EMAIL="admin@$DOMAIN"
        N8N_USER="n8n_inet$IP_SUM"
        N8N_PASS="n8n_inet$IP_SUM"
        DB_NAME="n8n_inet$IP_SUM"
        DB_USER="n8n_inet$IP_SUM"
        DB_PASS="n8n_inet$IP_SUM"
        
        echo -e "${GREEN}Da tao thong tin tu dong:${NC}"
        echo -e "${CYAN}Email:${NC} $EMAIL"
        echo -e "${CYAN}n8n User/Pass:${NC} $N8N_USER"
        echo -e "${CYAN}Database name/user/pass:${NC} $DB_NAME"
    fi
    
    # Kiem tra thong tin dau vao
    if [[ -z "$DOMAIN" || -z "$EMAIL" || -z "$N8N_USER" || -z "$N8N_PASS" || -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASS" ]]; then
        echo -e "${RED}Loi: Vui long cung cap tat ca thong tin can thiet${NC}"
        exit 1
    fi
    
    echo -e "\n${PURPLE}Bat dau qua trinh cai dat...${NC}\n"
    
    # Thuc hien cac buoc cai dat
    configure_timezone
    install_dependencies
    install_docker
    configure_n8n
    configure_nginx
    install_ssl
    
    # Kiem tra n8n co hoat dong tot khong
    check_n8n_health
    
    # Hoan tat
    echo -e "\n${GREEN}==================================================="
    echo "      Cai dat n8n hoan tat thanh cong!"
    echo "      Hay kiem tra lai cac thong tin sau"
    echo "===================================================${NC}"
    echo -e "${CYAN}Domain:${NC} https://${DOMAIN}"
    echo -e "${CYAN}n8n User:${NC} ${N8N_USER}"
    echo -e "${CYAN}n8n Pass:${NC} ${N8N_PASS}"
    echo -e "${CYAN}PostgreSQL DB:${NC} ${DB_NAME}"
    echo -e "${CYAN}PostgreSQL User:${NC} ${DB_USER}"
    echo -e "${CYAN}PostgreSQL Pass:${NC} ${DB_PASS}"
    echo -e "${CYAN}Mui gio:${NC} Asia/Ho_Chi_Minh (GMT+7)"
    echo -e "${GREEN}===================================================${NC}"
    
    echo -e "\n${YELLOW}Ban co the truy cap n8n tai dia chi:${NC} ${PURPLE}https://${DOMAIN}${NC}"
    
    # Thong tin them
    echo -e "\n${CYAN}Thong tin bo sung:${NC}"
    echo -e "- De xem log cua n8n: ${YELLOW}docker logs n8n${NC}"
    echo -e "- De khoi dong lai n8n: ${YELLOW}docker restart n8n${NC}"
    echo -e "- De dung n8n: ${YELLOW}docker stop n8n${NC}"
    echo -e "- De bat n8n: ${YELLOW}docker start n8n${NC}"
    echo -e "- Thu muc cau hinh: ${YELLOW}~/n8n_data${NC}"
    
    # Huong dan khac phuc su co
    echo -e "\n${CYAN}Huong dan khac phuc su co:${NC}"
    echo -e "- Neu gap loi ket noi database, thu chay: ${YELLOW}docker restart postgres n8n${NC}"
    echo -e "- Neu can xoa hoan toan va cai dat lai, chay script nay va chon 'Xoa sach va cai dat moi'"
    echo -e "- Neu can xem logs chi tiet: ${YELLOW}docker logs postgres${NC} hoac ${YELLOW}docker logs n8n${NC}"
}

# Chay ham chinh
main