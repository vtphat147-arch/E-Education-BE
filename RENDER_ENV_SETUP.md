# Render Environment Variables Setup

## Google OAuth Configuration

Để Google Login hoạt động trên Render, bạn **PHẢI** set các environment variables sau:

### 1. Vào Render Dashboard
- Đi đến **Web Service** của backend
- Click vào tab **Environment**
- Thêm các biến sau:

### 2. Environment Variables cần thiết:

```
GOOGLE_OAUTH__CLIENT_ID=1093420935022-fir4sj8alp1han53qe6tdailmel475bg.apps.googleusercontent.com
GOOGLE_OAUTH__CLIENT_SECRET=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
```

**⚠️ QUAN TRỌNG:**
- Phải dùng **2 dấu gạch dưới (`__`)** giữa `GOOGLE_OAUTH` và `CLIENT_ID`
- Không được có khoảng trắng xung quanh dấu `=`
- Giá trị không cần dấu ngoặc kép

### 3. Sau khi set environment variables:

1. **Manual Deploy** hoặc đợi **Auto Deploy** từ GitHub
2. Backend sẽ tự động restart và load các biến mới

### 4. Kiểm tra:

- Xem logs trên Render để đảm bảo không còn lỗi "Google OAuth ClientId is not configured"
- Thử đăng nhập bằng Google trên frontend

### 5. Nếu vẫn lỗi:

1. Kiểm tra lại tên biến: `GOOGLE_OAUTH__CLIENT_ID` (2 dấu `__`)
2. Kiểm tra giá trị không có khoảng trắng thừa
3. Xem logs trên Render để biết lỗi cụ thể
4. Restart service trên Render nếu cần

