# Cấu hình Application

## Quick Start

1. Copy `appsettings.example.json` thành `appsettings.json`
2. Điền thông tin cấu hình cần thiết

## Các cấu hình cần thiết

### 1. Database Connection String

```json
"ConnectionStrings": {
  "DefaultConnection": "Host=localhost;Port=5432;Database=e_education;Username=postgres;Password=your_password"
}
```

### 2. JWT Settings (Đã có mặc định, có thể để nguyên cho development)

```json
"JwtSettings": {
  "SecretKey": "your-secret-key-at-least-32-characters-long-for-security-purposes-please-change-in-production",
  "Issuer": "E-Education-API",
  "Audience": "E-Education-Client",
  "ExpiryMinutes": "1440"
}
```

### 3. Google OAuth (Tùy chọn - Xem GOOGLE_OAUTH_SETUP.md)

Nếu muốn dùng Google Login:
- Xem file `GOOGLE_OAUTH_SETUP.md` để hướng dẫn chi tiết
- Điền `ClientId` và `ClientSecret` từ Google Cloud Console

```json
"GoogleOAuth": {
  "ClientId": "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com",
  "ClientSecret": "YOUR_GOOGLE_CLIENT_SECRET"
}
```

### 4. SMTP Settings (Tùy chọn - Xem SMTP_SETUP.md)

Nếu muốn gửi email verification:
- Xem file `SMTP_SETUP.md` để hướng dẫn chi tiết
- Điền thông tin SMTP (Gmail, SendGrid, etc.)

```json
"SmtpSettings": {
  "Host": "smtp.gmail.com",
  "Port": "587",
  "User": "your-email@gmail.com",
  "Password": "your-app-password",
  "FromEmail": "your-email@gmail.com",
  "FromName": "E-Education"
}
```

**Lưu ý**: Nếu không cấu hình SMTP, verification link sẽ được log ra console. User vẫn có thể đăng ký và đăng nhập.

### 5. Frontend URL

```json
"FrontendUrl": "http://localhost:5173"
```

URL này được dùng để tạo verification link trong email.

## Development vs Production

### Development
- Có thể để trống `GoogleOAuth` và `SmtpSettings`
- Verification link sẽ được log ra console
- Google Login sẽ không hoạt động (nếu không cấu hình)

### Production (Render/Docker)

Nên dùng **Environment Variables**:

```bash
# Google OAuth
GOOGLE_OAUTH__CLIENT_ID=your-client-id
GOOGLE_OAUTH__CLIENT_SECRET=your-client-secret

# SMTP
SMTP__HOST=smtp.gmail.com
SMTP__PORT=587
SMTP__USER=your-email@gmail.com
SMTP__PASSWORD=your-app-password
SMTP__FROMEMAIL=your-email@gmail.com
SMTP__FROMNAME=E-Education

# Frontend
FRONTEND_URL=https://your-frontend-domain.com

# Database (Render tự động cung cấp)
DATABASE_URL=postgresql://...
```

## Admin Account

Sau khi chạy ứng dụng lần đầu, hệ thống tự động tạo admin account:

- **Email**: `admin@e-education.com`
- **Password**: `Admin123!`
- **Username**: `admin`

⚠️ **Quan trọng**: Hãy đổi password ngay sau lần đăng nhập đầu tiên!

