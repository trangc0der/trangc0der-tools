# trangc0der-tools

Đây là một bộ sưu tập các script dòng lệnh (shell script) hữu ích để tự động hóa các tác vụ quản trị hệ thống (SysAdmin) trên các bản phân phối Linux dựa trên RHEL như AlmaLinux, Rocky Linux, CentOS.

## Yêu cầu

- Hệ điều hành: **AlmaLinux 8 / Rocky Linux 8 / CentOS 8**
- Quyền `sudo` để thực thi các tác vụ quản trị.
- Các công cụ `curl` hoặc `git` đã được cài đặt sẵn trên hệ thống.

## Hướng dẫn sử dụng

#### Gỡ cài đặt Docker

Script này sẽ gỡ cài đặt Docker Engine, CLI, containerd và xóa toàn bộ dữ liệu liên quan (containers, images, volumes, networks).

**Lệnh thực thi:**

```bash
curl -sSL [https://raw.githubusercontent.com/trangc0der/trangc0der-tools/main/docker/remove-docker/remove-docker.sh](https://raw.githubusercontent.com/trangc0der/trangc0der-tools/main/docker/remove-docker/remove-docker.sh) | sudo bash
```

---

## ⚠️ Cảnh báo quan trọng

> **CÁC SCRIPT NÀY CÓ TÍNH CHẤT PHÁ HỦY DỮ LIỆU.**
>
> - Chúng được thiết kế để **XÓA SẠCH** phần mềm và dữ liệu liên quan khỏi hệ thống của bạn.
> - Hành động này **KHÔNG THỂ HOÀN TÁC**.
> - Luôn luôn **SAO LƯU (BACKUP)** dữ liệu quan trọng trước khi chạy bất kỳ script nào trong bộ công cụ này.
> - Hãy đọc kỹ nội dung script trước khi thực thi để hiểu rõ nó sẽ làm gì trên hệ thống của bạn.

## Đóng góp

Nếu bạn có ý tưởng cải thiện hoặc muốn đóng góp thêm các công cụ mới, vui lòng tạo một "Issue" để thảo luận hoặc một "Pull Request" để gửi mã nguồn của bạn. Mọi sự đóng góp đều được chào đón!

## Giấy phép

Dự án này được cấp phép theo Giấy phép MIT.
