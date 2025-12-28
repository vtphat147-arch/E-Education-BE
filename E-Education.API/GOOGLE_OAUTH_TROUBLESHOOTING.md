# Google OAuth Troubleshooting

## ✅ Format của Credentials

Credentials của bạn có format **ĐÚNG**:

- **Client ID**: `1093420935022-fir4sj8alp1han53qe6tdailmel475bg.apps.googleusercontent.com`
  - ✅ Có `.apps.googleusercontent.com`
  - ✅ Format hợp lệ

- **Client Secret**: `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`
  - ✅ Bắt đầu bằng `GOCSPX-` (đúng format mới của Google)
  - ✅ Format hợp lệ

## 🔍 Cách kiểm tra credentials có đúng không:

### 1. Kiểm tra trên Google Cloud Console:

1. Vào [Google Cloud Console](https://console.cloud.google.com/)
2. Chọn đúng project
3. Vào **APIs & Services** > **Credentials**
4. Tìm OAuth 2.0 Client ID có Client ID: `1093420935022-...`
5. Click vào để xem chi tiết

### 2. Kiểm tra các điểm sau:

#### ✅ Client ID và Client Secret phải cùng một OAuth Client
- Không được lấy Client ID từ project này và Client Secret từ project khác

#### ✅ OAuth Client phải **ENABLED**
- Nếu thấy status là "Disabled" → Click "Enable"

#### ✅ Authorized JavaScript origins phải có:
```
http://localhost:5173
https://e-education-beta.vercel.app
```

#### ✅ OAuth consent screen phải được cấu hình
- Vào **OAuth consent screen**
- Đảm bảo app không ở chế độ "Testing" với users hạn chế (hoặc thêm test user)

### 3. Kiểm tra trên Render:

#### Backend Environment Variables:
```
GOOGLE_OAUTH__CLIENT_ID=1093420935022-fir4sj8alp1han53qe6tdailmel475bg.apps.googleusercontent.com
GOOGLE_OAUTH__CLIENT_SECRET=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
```

**⚠️ Lưu ý:**
- Phải có **2 dấu `__`** (double underscore) giữa `GOOGLE_OAUTH` và `CLIENT_ID`
- Không có khoảng trắng

#### Frontend Environment Variables (Vercel):
```
VITE_GOOGLE_CLIENT_ID=1093420935022-fir4sj8alp1han53qe6tdailmel475bg.apps.googleusercontent.com
```

### 4. Common Issues:

#### ❌ Lỗi: "disabled_client"
- **Nguyên nhân**: OAuth Client bị disabled
- **Fix**: Vào Google Cloud Console → Enable OAuth Client

#### ❌ Lỗi: "invalid_client"
- **Nguyên nhân**: Client ID và Client Secret không khớp
- **Fix**: Kiểm tra lại cả hai từ cùng một OAuth Client

#### ❌ Lỗi: "redirect_uri_mismatch"
- **Nguyên nhân**: Domain không có trong Authorized origins
- **Fix**: Thêm domain vào Google Cloud Console

#### ❌ Lỗi: "ClientId is not configured"
- **Nguyên nhân**: Environment variable chưa set trên Render
- **Fix**: Set `GOOGLE_OAUTH__CLIENT_ID` trên Render (2 dấu `__`)

## 🔧 Quick Test:

1. **Test trên localhost:**
   - Frontend: `http://localhost:5173`
   - Backend: `http://localhost:5000` (hoặc port của bạn)
   - Thử Google Login

2. **Test trên production:**
   - Frontend: `https://e-education-beta.vercel.app`
   - Backend: `https://e-education-be.onrender.com`
   - Thử Google Login

3. **Kiểm tra logs:**
   - Render logs: Xem lỗi cụ thể
   - Browser console: Xem lỗi từ Google OAuth

## 📝 Checklist:

- [ ] Client ID format đúng (có `.apps.googleusercontent.com`)
- [ ] Client Secret format đúng (bắt đầu bằng `GOCSPX-`)
- [ ] Client ID và Client Secret cùng một OAuth Client
- [ ] OAuth Client đã được Enable
- [ ] Authorized origins có domain frontend
- [ ] OAuth consent screen đã cấu hình
- [ ] Environment variables trên Render đúng (2 dấu `__`)
- [ ] Environment variables trên Vercel đúng
- [ ] Backend đã restart sau khi set environment variables

