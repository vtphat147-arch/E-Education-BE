# Hướng dẫn cấu hình SMTP Email

## Cấu hình Gmail (Khuyến nghị cho development)

### Bước 1: Tạo App Password cho Gmail

1. Đăng nhập vào [Google Account](https://myaccount.google.com/)
2. Vào **Security**
3. Bật **2-Step Verification** (nếu chưa bật)
4. Vào **App passwords** (tìm trong Security settings)
5. Tạo App password mới:
   - Select app: **Mail**
   - Select device: **Other (Custom name)**
   - Nhập tên: **E-Education API**
6. Copy password được tạo (16 ký tự, không có khoảng trắng)

### Bước 2: Cấu hình trong appsettings.json

```json
{
  "SmtpSettings": {
    "Host": "smtp.gmail.com",
    "Port": "587",
    "User": "your-email@gmail.com",
    "Password": "your-16-char-app-password",
    "FromEmail": "your-email@gmail.com",
    "FromName": "E-Education"
  }
}
```

## Cấu hình cho các Email Provider khác

### Outlook/Hotmail

```json
{
  "SmtpSettings": {
    "Host": "smtp-mail.outlook.com",
    "Port": "587",
    "User": "your-email@outlook.com",
    "Password": "your-password",
    "FromEmail": "your-email@outlook.com",
    "FromName": "E-Education"
  }
}
```

### SendGrid (Production - Khuyến nghị)

1. Đăng ký tài khoản tại [SendGrid](https://sendgrid.com/)
2. Tạo API Key trong Settings > API Keys
3. Cấu hình:

```json
{
  "SmtpSettings": {
    "Host": "smtp.sendgrid.net",
    "Port": "587",
    "User": "apikey",
    "Password": "YOUR_SENDGRID_API_KEY",
    "FromEmail": "noreply@yourdomain.com",
    "FromName": "E-Education"
  }
}
```

### Mailgun

```json
{
  "SmtpSettings": {
    "Host": "smtp.mailgun.org",
    "Port": "587",
    "User": "postmaster@yourdomain.mailgun.org",
    "Password": "YOUR_MAILGUN_PASSWORD",
    "FromEmail": "noreply@yourdomain.com",
    "FromName": "E-Education"
  }
}
```

## Development Mode (Không cấu hình SMTP)

Nếu không cấu hình SMTP, hệ thống sẽ:
- Log verification link ra console/logs
- Không gửi email thật
- User vẫn có thể đăng ký và đăng nhập

Để xem verification link, check logs khi đăng ký:
```
Verification link: http://localhost:5173/verify-email?token=xxxxx
```

## Environment Variables (Production)

Để bảo mật hơn, nên dùng environment variables:

**Render:**
- Vào Service Settings > Environment
- Thêm các variables:
  - `SMTP__Host`
  - `SMTP__Port`
  - `SMTP__User`
  - `SMTP__Password`
  - `SMTP__FromEmail`
  - `SMTP__FromName`

**Hoặc trong Docker:**
```bash
docker run -e SMTP__Host=smtp.gmail.com \
  -e SMTP__Port=587 \
  -e SMTP__User=your-email@gmail.com \
  -e SMTP__Password=your-app-password \
  ...
```

## Kiểm tra

1. Đăng ký user mới
2. Check email inbox (hoặc spam folder)
3. Click vào verification link
4. Email sẽ được verify thành công

## Troubleshooting

- **"Authentication failed"**: Kiểm tra App Password (Gmail) hoặc username/password
- **"Connection timeout"**: Kiểm tra firewall, port 587/465 có bị block không
- **Email vào spam**: Thêm SPF/DKIM records cho domain
- **Gmail không gửi được**: Đảm bảo đã bật "Less secure app access" HOẶC dùng App Password

