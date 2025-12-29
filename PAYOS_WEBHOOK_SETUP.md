# PayOS Webhook Setup Guide

## 📌 Webhook URL là gì?

Webhook URL là địa chỉ backend endpoint mà PayOS sẽ gọi để thông báo khi có thanh toán thành công.

## 🔗 Lấy Webhook URL

Webhook URL của bạn sẽ có dạng:

```
https://your-backend-domain.onrender.com/api/payments/webhook
```

**Ví dụ:**
- Nếu backend của bạn deploy trên Render: `https://e-education-be.onrender.com/api/payments/webhook`
- Nếu backend deploy ở nơi khác: `https://your-domain.com/api/payments/webhook`

## ✅ Cách Setup Webhook trong PayOS

### Cách 1: Dùng API confirm-webhook (KHUYẾN NGHỊ)

1. **Lấy webhook URL của bạn:**
   ```
   https://e-education-be.onrender.com/api/payments/webhook
   ```
   (Thay bằng URL backend thực tế của bạn)

2. **Gọi API confirm-webhook:**
   
   **Sử dụng cURL:**
   ```bash
   curl -X POST "https://e-education-be.onrender.com/api/payments/confirm-webhook" \
     -H "Content-Type: application/json" \
     -d '{
       "webhookUrl": "https://e-education-be.onrender.com/api/payments/webhook"
     }'
   ```

   **Hoặc sử dụng Postman/Thunder Client:**
   - Method: `POST`
   - URL: `https://e-education-be.onrender.com/api/payments/confirm-webhook`
   - Headers: `Content-Type: application/json`
   - Body:
     ```json
     {
       "webhookUrl": "https://e-education-be.onrender.com/api/payments/webhook"
     }
     ```

3. **Backend sẽ tự động gọi PayOS API để confirm webhook**

### Cách 2: Gọi trực tiếp PayOS API

**Cách này cần Client ID và API Key từ PayOS:**

```bash
curl -X POST "https://api-merchant.payos.vn/v2/confirm-webhook" \
  -H "x-client-id: YOUR_CLIENT_ID" \
  -H "x-api-key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "webhookUrl": "https://e-education-be.onrender.com/api/payments/webhook"
  }'
```

## 🧪 Test Webhook

Sau khi setup, PayOS sẽ gửi một request test đến webhook URL của bạn để verify.

Bạn có thể kiểm tra logs trên Render để xem:
- PayOS đã gọi webhook chưa
- Signature verification có đúng không
- Webhook có xử lý đúng không

## 📋 Checklist

- [ ] Backend đã deploy và có endpoint `/api/payments/webhook`
- [ ] Environment variables đã setup (PayOS__ClientId, PayOS__ApiKey, PayOS__ChecksumKey)
- [ ] Webhook URL đã được confirm với PayOS
- [ ] Test webhook bằng cách tạo một payment thử

## ⚠️ Lưu ý

1. **Webhook URL phải là HTTPS** (không dùng HTTP)
2. **Webhook URL phải accessible từ internet** (không dùng localhost)
3. **ChecksumKey phải đúng** để verify signature
4. **Webhook phải trả về status 200** khi nhận request từ PayOS

## 🔍 Kiểm tra Webhook có hoạt động

1. Tạo một payment thử
2. Xem logs trên Render backend
3. Kiểm tra database xem payment status đã update chưa
4. Kiểm tra user VIP status đã được activate chưa

