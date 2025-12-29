# Checklist Cấu Hình Cần Thiết

## 🔴 BẮT BUỘC - PayOS Configuration

### 1. Environment Variables trên Render (QUAN TRỌNG NHẤT)

Vào **Render Dashboard** → **Environment** tab, thêm các biến sau:

```bash
# PayOS Credentials (BẮT BUỘC)
PayOS__ClientId = your-client-id-here
PayOS__ApiKey = your-api-key-here  
PayOS__ChecksumKey = your-checksum-key-here

# PayOS URLs (BẮT BUỘC)
PayOS__ReturnUrl = https://your-frontend-domain.vercel.app/payment-success
PayOS__CancelUrl = https://your-frontend-domain.vercel.app/payment-cancel
```

**⚠️ QUAN TRỌNG:**
- **KHÔNG** set `PayOS__ApiUrl` - API URL được hardcode trong code
- **KHÔNG** set `PayOS__BaseUrl` - Không tồn tại trong PayOS config
- **CHỈ** cần 5 biến trên (ClientId, ApiKey, ChecksumKey, ReturnUrl, CancelUrl)

**Lưu ý:**
- Format: `PayOS__ClientId` (double underscore `__`)
- Lấy credentials từ: https://my.payos.vn → Cài đặt → Thông tin ứng dụng
- Sau khi thêm env vars → **Redeploy service**

### 2. Setup Webhook trên PayOS Dashboard

1. Vào https://my.payos.vn
2. **Cài đặt** → **Webhook**
3. Thêm Webhook URL:
   ```
   https://your-backend-domain.onrender.com/api/payments/webhook
   ```
4. Save

---

## 🟡 QUAN TRỌNG - Database Configuration

### Connection String trên Render

```bash
ConnectionStrings__DefaultConnection = Host=your-db-host;Port=5432;Database=e_education;Username=your-user;Password=your-password
```

**Lưu ý:** Format double underscore `__` cho nested config

---

## 🟡 QUAN TRỌNG - JWT Configuration

```bash
JwtSettings__SecretKey = your-secret-key-at-least-32-characters-long
JwtSettings__Issuer = E-Education-API
JwtSettings__Audience = E-Education-Client
JwtSettings__ExpiryMinutes = 1440
```

---

## 🟢 TÙY CHỌN - Các config khác

### Google OAuth (nếu dùng)
```bash
GoogleOAuth__ClientId = your-google-client-id
GoogleOAuth__ClientSecret = your-google-client-secret
```

### SMTP Settings (nếu dùng email)
```bash
SmtpSettings__Host = smtp.gmail.com
SmtpSettings__Port = 587
SmtpSettings__User = your-email@gmail.com
SmtpSettings__Password = your-app-password
SmtpSettings__FromEmail = your-email@gmail.com
SmtpSettings__FromName = E-Education
```

### Frontend URL (cho CORS)
```bash
FrontendUrl = https://your-frontend-domain.vercel.app
```

---

## ✅ Checklist Trước Khi Deploy

- [ ] Đã set `PayOS__ClientId`, `PayOS__ApiKey`, `PayOS__ChecksumKey`
- [ ] Đã set `PayOS__ReturnUrl` và `PayOS__CancelUrl` (đúng domain frontend)
- [ ] Đã setup Webhook URL trên PayOS Dashboard
- [ ] Đã set `ConnectionStrings__DefaultConnection`
- [ ] Đã set `JwtSettings__SecretKey`
- [ ] Đã chạy SQL migrations (VIP plans, payments table)
- [ ] Đã redeploy sau khi thêm env vars

---

## 🧪 Test Sau Khi Deploy

1. **Test PayOS Config:**
   ```bash
   GET /api/payments/plans
   # Phải trả về danh sách gói VIP (không phải 500 error)
   ```

2. **Test Payment Flow:**
   - Tạo order qua UI
   - Kiểm tra xem có redirect đến PayOS không
   - Test thanh toán thành công
   - Kiểm tra webhook có nhận được không

3. **Check Logs:**
   - Không có lỗi "PayOS configuration is missing"
   - Không có lỗi "Invalid signature"
   - Webhook nhận được request từ PayOS

---

## 📝 Ghi Chú

- **Format Env Vars:** Render dùng double underscore `__` để map với nested config
- **PayOS Dashboard:** https://my.payos.vn (không phải pay.payos.vn)
- **API Endpoint:** Production là `https://api-merchant.payos.vn` (đã config sẵn trong code)
- **Webhook:** Phải là HTTPS public URL
- **Signature:** Code đã tự động tạo đúng format (query string sorted alphabetically)

