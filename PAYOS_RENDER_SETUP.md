# Hướng dẫn Setup PayOS trên Render

## Bước 1: Lấy PayOS Credentials

1. Đăng nhập vào [PayOS Dashboard](https://pay.payos.vn/)
2. Vào **Cài đặt** → **Thông tin ứng dụng**
3. Copy các thông tin:
   - **Client ID**
   - **API Key** 
   - **Checksum Key**

## Bước 2: Setup Environment Variables trên Render

### Cách 1: Qua Render Dashboard

1. Vào **Render Dashboard** → Chọn service của bạn
2. Vào tab **Environment**
3. Thêm các biến môi trường sau:

```
PayOS__ClientId = your-client-id-here
PayOS__ApiKey = your-api-key-here
PayOS__ChecksumKey = your-checksum-key-here
PayOS__BaseUrl = https://e-education-be.onrender.com
PayOS__ReturnUrl = https://your-frontend-domain.vercel.app/payment-success
PayOS__CancelUrl = https://your-frontend-domain.vercel.app/payment-cancel
```

### Cách 2: Qua Render CLI

```bash
render env set PayOS__ClientId your-client-id-here
render env set PayOS__ApiKey your-api-key-here
render env set PayOS__ChecksumKey your-checksum-key-here
render env set PayOS__BaseUrl https://e-education-be.onrender.com
render env set PayOS__ReturnUrl https://your-frontend-domain.vercel.app/payment-success
render env set PayOS__CancelUrl https://your-frontend-domain.vercel.app/payment-cancel
```

## Bước 3: Setup Webhook URL trên PayOS

1. Vào **PayOS Dashboard** → **Cài đặt** → **Webhook**
2. Thêm Webhook URL:
   ```
   https://e-education-be.onrender.com/api/payments/webhook
   ```
3. Save

## Bước 4: Verify Configuration

Sau khi deploy, test bằng cách:
1. Gọi API `/api/payments/plans` để xem danh sách gói
2. Tạo order để test payment flow
3. Kiểm tra logs trên Render để xem có lỗi config không

## Lưu ý:

- **Format Environment Variables trên Render**: Sử dụng `PayOS__ClientId` (double underscore `__`) để map với `PayOS:ClientId` trong config
- **BaseUrl**: Nên dùng domain Render của bạn (ví dụ: `https://e-education-be.onrender.com`)
- **ReturnUrl/CancelUrl**: Dùng domain frontend của bạn (ví dụ: Vercel domain)
- **Webhook URL**: Phải là public URL, Render tự động cung cấp HTTPS

## Troubleshooting:

### Lỗi "Cấu hình PayOS chưa được thiết lập"
- Kiểm tra lại các environment variables đã được set chưa
- Đảm bảo tên biến đúng format: `PayOS__ClientId` (double underscore)
- Redeploy service sau khi thêm env vars

### Webhook không nhận được
- Kiểm tra Webhook URL trên PayOS Dashboard
- Kiểm tra logs trên Render xem có request đến `/api/payments/webhook`
- Đảm bảo PayOS có thể truy cập được URL của bạn (public HTTPS)

### Signature verification failed
- Kiểm tra `PayOS__ChecksumKey` đã đúng chưa
- Đảm bảo không có khoảng trắng thừa trong env vars

