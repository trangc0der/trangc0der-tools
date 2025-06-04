Chắc chắn rồi, đây là tài liệu hướng dẫn sử dụng script cài đặt n8n trên AlmaLinux với FastPanel ở định dạng Markdown.

---

# Hướng dẫn Cài đặt n8n trên AlmaLinux với FastPanel bằng Script tự động

Script này được tạo ra để tự động hóa quá trình cài đặt n8n (sử dụng Docker) trên một máy chủ AlmaLinux đã có FastPanel. Script sẽ thực hiện các công việc sau:
* Kiểm tra và cài đặt Docker & Docker Compose nếu chưa có.
* Hỏi người dùng các thông tin cần thiết để cấu hình n8n và cơ sở dữ liệu PostgreSQL.
* Tạo file `docker-compose.yml` với cấu hình chuẩn.
* Khởi chạy các container n8n và PostgreSQL.
* Hướng dẫn người dùng các bước tiếp theo để hoàn tất cài đặt (cấu hình Reverse Proxy trong FastPanel).

## Điều kiện cần có

* Một máy chủ đang chạy hệ điều hành AlmaLinux (hoặc các bản phân phối tương tự như CentOS, Rocky Linux).
* FastPanel đã được cài đặt trên máy chủ.
* Quyền truy cập `sudo` hoặc `root`.
* Một tên miền (hoặc subdomain) đã được trỏ DNS về IP của máy chủ để sử dụng cho n8n.

## Các bước thực hiện

### Bước 1: Tải Script

Kết nối SSH vào máy chủ của bạn và tải về script cài đặt từ GitHub bằng lệnh `wget` hoặc `curl`.

```bash
wget https://raw.githubusercontent.com/trangc0der/trangc0der-tools/main/n8n/n8n-almalinux-fastpanel/n8n-almalinux-fastpanel.sh
```

### Bước 2: Cấp quyền thực thi cho Script

Sau khi tải về, bạn cần cấp quyền thực thi cho file `n8n-almalinux-fastpanel.sh`.

```bash
chmod +x n8n-almalinux-fastpanel.sh
```

### Bước 3: Chạy Script và Cung cấp thông tin

Thực thi script với quyền `sudo` để bắt đầu quá trình cài đặt.

```bash
sudo ./n8n-almalinux-fastpanel.sh
```

Script sẽ yêu cầu bạn nhập các thông tin sau:

1.  **Domain:** Nhập tên miền bạn đã chuẩn bị để truy cập n8n (ví dụ: `n8n.yourdomain.com`).
2.  **n8n User:** Tên người dùng để đăng nhập vào giao diện n8n.
3.  **n8n Password:** Mật khẩu để đăng nhập vào giao diện n8n (sẽ được ẩn khi nhập).
4.  **Database Name:** Tên cho cơ sở dữ liệu PostgreSQL (ví dụ: `n8n_db`).
5.  **Database User:** Tên người dùng cho cơ sở dữ liệu.
6.  **Database Password:** Mật khẩu cho người dùng cơ sở dữ liệu (sẽ được ẩn khi nhập).

Sau khi bạn nhập đầy đủ thông tin, script sẽ tự động thực hiện các công việc còn lại.

### Bước 4: Cấu hình Reverse Proxy trong FastPanel

Sau khi script chạy xong và khởi động thành công các container, bạn sẽ thấy thông báo **"BUOC 1 HOAN TAT"**.

Lúc này, n8n đang chạy và lắng nghe trên địa chỉ `http://127.0.0.1:5555` của máy chủ. Bước cuối cùng là tạo một trang web trong FastPanel và cấu hình nó như một Reverse Proxy để trỏ tên miền của bạn vào ứng dụng n8n.

1.  **Đăng nhập vào FastPanel.**
2.  **Tạo một trang web mới:**
    * Vào mục "Sites" và nhấn "New Site".
    * Chọn "Site on server" và nhập tên miền bạn đã cung cấp cho script ở bước 3.
    * Hoàn tất việc tạo site.
3.  **Cài đặt SSL:** Sau khi tạo site, hãy vào phần cài đặt của site đó và tiến hành cài đặt chứng chỉ SSL miễn phí từ Let's Encrypt.
4.  **Cấu hình Proxy:**
    * Trong phần cài đặt của site, tìm đến mục **Proxy**.
    * Bật tính năng Proxy lên.
    * Trong ô **Proxy URL**, nhập địa chỉ mà n8n đang lắng nghe:
        ```
        http://127.0.0.1:5555
        ```
    * Lưu lại cấu hình.

### Bước 5: Hoàn tất

Bây giờ bạn có thể truy cập n8n bằng tên miền của mình (`https://n8n.yourdomain.com`). Đăng nhập bằng tài khoản và mật khẩu n8n mà bạn đã tạo ở bước 3.

## Quản lý và khắc phục sự cố

* **Thư mục làm việc:** Tất cả các file cấu hình (`docker-compose.yml`) và dữ liệu (`n8n_local_data`, `postgres_data`) sẽ được lưu tại `~/n8n_data`.
* **Kiểm tra logs của n8n:** Nếu gặp sự cố, bạn có thể xem nhật ký hoạt động của container n8n bằng lệnh:
    ```bash
    sudo docker logs n8n
    ```
* **Khởi động lại dịch vụ:**
    ```bash
    cd ~/n8n_data
    sudo docker compose up -d
    ```
* **Dừng dịch vụ:**
    ```bash
    cd ~/n8n_data
    sudo docker compose down
    ```