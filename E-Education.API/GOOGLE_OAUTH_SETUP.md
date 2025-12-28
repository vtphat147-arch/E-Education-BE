# Hướng dẫn cấu hình Google OAuth

## Bước 1: Tạo Google OAuth Credentials

1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo project mới hoặc chọn project hiện có
3. Đi tới **APIs & Services** > **Credentials**
4. Click **Create Credentials** > **OAuth client ID**
5. Nếu chưa có, bạn sẽ cần cấu hình OAuth consent screen trước:
   - Chọn **User Type**: External (hoặc Internal nếu dùng Google Workspace)
   - Điền thông tin ứng dụng (App name, User support email, Developer contact)
   - Thêm **Scopes**: `email`, `profile`, `openid`
   - Thêm **Test users** (nếu app ở chế độ Testing)
6. Tạo OAuth client ID:
   - **Application type**: Web application
   - **Name**: E-Education API (hoặc tên bạn muốn)
   - **Authorized JavaScript origins**:
     - `http://localhost:5173` (cho development)
     - `https://your-frontend-domain.com` (cho production)
   - **Authorized redirect URIs**:
     - `http://localhost:5173` (cho development)
     - `https://your-frontend-domain.com` (cho production)
7. Sau khi tạo, copy **Client ID** và **Client Secret**

## Bước 2: Cấu hình trong appsettings.json

Thêm vào `appsettings.json`:

```json
{
  "GoogleOAuth": {
    "ClientId": "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com",
    "ClientSecret": "YOUR_GOOGLE_CLIENT_SECRET"
  }
}
```

## Bước 3: Cấu hình Frontend

Trong frontend, bạn cần tích hợp Google Sign-In JavaScript library:

1. Thêm script vào `index.html`:
```html
<script src="https://accounts.google.com/gsi/client" async defer></script>
```

2. Sử dụng Google Sign-In button trong React component

## Lưu ý:

- **Production**: Đảm bảo thêm domain production vào Authorized origins
- **Client Secret**: Giữ bí mật, không commit vào git
- **Environment Variables**: Nên dùng environment variables thay vì hardcode trong production

## Kiểm tra:

- Test Google Login trên localhost trước
- Đảm bảo redirect URI khớp chính xác
- Kiểm tra OAuth consent screen đã được phê duyệt (nếu cần)

