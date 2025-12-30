# E-Education - Backend API

RESTful API backend cho nền tảng E-Education, được xây dựng với ASP.NET Core 8.0, PostgreSQL, và tích hợp PayOS payment gateway.

## 🚀 Công nghệ sử dụng

### Core Framework
- **.NET 8.0** - Runtime framework
- **ASP.NET Core** - Web API framework
- **Entity Framework Core 8.0** - ORM
- **PostgreSQL** - Database

### Authentication & Security
- **JWT Bearer Authentication** - Token-based authentication
- **BCrypt.Net** - Password hashing
- **Google OAuth 2.0** - Social login

### Payment Integration
- **PayOS Payment Gateway** - VIP subscription payments

### Email Service
- **MailKit** - SMTP email client
- **SendGrid** - Email delivery service (optional)

### API Documentation
- **Swagger/OpenAPI** - API documentation và testing

### HTTP Client
- **HttpClientFactory** - HTTP client management

## 📦 Cài đặt

### Yêu cầu
- .NET 8.0 SDK
- PostgreSQL 12+ (hoặc sử dụng cloud database)
- Git

### Setup Local

```bash
# Clone repository
git clone <repository-url>
cd Backend/E-Education.API

# Restore packages
dotnet restore

# Tạo file appsettings.json từ appsettings.example.json
cp appsettings.example.json appsettings.json

# Chỉnh sửa appsettings.json với thông tin database và config của bạn

# Apply database migrations
dotnet ef database update

# Chạy application
dotnet run

# API sẽ chạy tại: http://localhost:5000 hoặc https://localhost:5001
# Swagger UI: http://localhost:5000/swagger
```

### Setup với Docker

```bash
# Build Docker image
docker build -t e-education-api .

# Run container
docker run -p 8080:8080 \
  -e DATABASE_URL=postgresql://user:password@host:port/database \
  -e JWT_SECRET_KEY=your-secret-key \
  e-education-api
```

## ⚙️ Configuration

### Environment Variables

Copy `appsettings.example.json` thành `appsettings.json` và điền các thông tin sau:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=e_education;Username=postgres;Password=your_password"
  },
  "JwtSettings": {
    "SecretKey": "your-secret-key-at-least-32-characters-long",
    "Issuer": "E-Education-API",
    "Audience": "E-Education-Client",
    "ExpiryMinutes": "1440"
  },
  "GoogleOAuth": {
    "ClientId": "YOUR_GOOGLE_CLIENT_ID",
    "ClientSecret": "YOUR_GOOGLE_CLIENT_SECRET"
  },
  "SmtpSettings": {
    "Host": "smtp.gmail.com",
    "Port": "587",
    "User": "your-email@gmail.com",
    "Password": "your-app-password",
    "FromEmail": "your-email@gmail.com",
    "FromName": "E-Education"
  },
  "PayOS": {
    "ClientId": "your-payos-client-id",
    "ApiKey": "your-payos-api-key",
    "ChecksumKey": "your-payos-checksum-key",
    "ReturnUrl": "https://your-domain.com/payment-success",
    "CancelUrl": "https://your-domain.com/payment-cancel"
  },
  "FrontendUrl": "http://localhost:5173"
}
```

### Environment Variables cho Production (Render/Cloud)

| Variable | Mô tả | Required |
|----------|-------|----------|
| `DATABASE_URL` | PostgreSQL connection string | ✅ Yes |
| `JWT_SECRET_KEY` | Secret key cho JWT tokens | ✅ Yes |
| `JWT_ISSUER` | JWT Issuer | ❌ No |
| `JWT_AUDIENCE` | JWT Audience | ❌ No |
| `GOOGLE_CLIENT_ID` | Google OAuth Client ID | ❌ No |
| `GOOGLE_CLIENT_SECRET` | Google OAuth Client Secret | ❌ No |
| `SMTP_HOST` | SMTP server host | ❌ No |
| `SMTP_PORT` | SMTP server port | ❌ No |
| `SMTP_USER` | SMTP username | ❌ No |
| `SMTP_PASSWORD` | SMTP password | ❌ No |
| `PAYOS__CLIENTID` | PayOS Client ID | ✅ Yes (nếu dùng PayOS) |
| `PAYOS__APIKEY` | PayOS API Key | ✅ Yes (nếu dùng PayOS) |
| `PAYOS__CHECKSUMKEY` | PayOS Checksum Key | ✅ Yes (nếu dùng PayOS) |
| `FRONTEND_URL` | Frontend URL cho CORS | ❌ No |

## 🗄️ Database Setup

### PostgreSQL Connection

Application hỗ trợ 2 cách config database:

1. **Connection String** (Local development):
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Host=localhost;Port=5432;Database=e_education;Username=postgres;Password=password"
   }
   ```

2. **DATABASE_URL** (Production/Render):
   ```
   DATABASE_URL=postgresql://user:password@host:port/database
   ```
   Application sẽ tự động parse `DATABASE_URL` thành connection string.

### Migrations

```bash
# Tạo migration mới
dotnet ef migrations add MigrationName

# Apply migrations lên database
dotnet ef database update

# Xóa migration cuối cùng (chưa apply)
dotnet ef migrations remove
```

### Database Schema

Các bảng chính:
- `Users` - Thông tin user
- `DesignComponents` - UI/UX components
- `Comments` - Comments trên components
- `ComponentLikes` - Likes của user
- `Favorites` - Favorite components
- `ComponentViewHistory` - Lịch sử xem
- `EmailVerifications` - Email verification tokens
- `VipPlans` - VIP subscription plans
- `Payments` - Payment records

## 🛣️ API Endpoints

### Authentication (`/api/auth`)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/auth/register` | Đăng ký user mới | ❌ |
| POST | `/api/auth/login` | Đăng nhập | ❌ |
| POST | `/api/auth/google` | Đăng nhập với Google | ❌ |
| GET | `/api/auth/me` | Lấy thông tin user hiện tại | ✅ |

### Users (`/api/users`)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/users/me` | Lấy profile của user hiện tại | ✅ |
| PUT | `/api/users/me` | Cập nhật profile | ✅ |
| GET | `/api/users/{id}` | Lấy thông tin user theo ID | ✅ |

### Design Components (`/api/components`)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/components` | Lấy danh sách components (có filter, pagination) | ❌ |
| GET | `/api/components/{id}` | Lấy chi tiết component | ❌ |
| POST | `/api/components/{id}/like` | Like/Unlike component | ✅ |
| GET | `/api/components/{id}/like/check` | Kiểm tra user đã like chưa | ✅ |
| GET | `/api/components/categories` | Lấy danh sách categories | ❌ |
| GET | `/api/components/types/{category}` | Lấy types theo category | ❌ |

### Comments (`/api/components/{componentId}/comments`)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/components/{componentId}/comments` | Lấy comments của component | ❌ |
| POST | `/api/components/{componentId}/comments` | Tạo comment mới | ✅ |
| PUT | `/api/components/{componentId}/comments/{id}` | Cập nhật comment | ✅ |
| DELETE | `/api/components/{componentId}/comments/{id}` | Xóa comment | ✅ |

### Favorites (`/api/favorites`)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/favorites` | Lấy danh sách favorites của user | ✅ |
| POST | `/api/favorites` | Thêm favorite | ✅ |
| DELETE | `/api/favorites/{componentId}` | Xóa favorite | ✅ |

### View History (`/api/viewhistory`)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/viewhistory` | Lấy lịch sử xem của user | ✅ |
| POST | `/api/viewhistory` | Thêm view history | ✅ |

### Payments (`/api/payments`)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/payments/create-order` | Tạo PayOS payment order | ✅ |
| POST | `/api/payments/webhook` | PayOS webhook handler | ❌ |
| GET | `/api/payments/verify/{orderCode}` | Verify payment status | ✅ |
| GET | `/api/payments/history` | Lấy payment history của user | ✅ |
| GET | `/api/payments/vip-status` | Lấy VIP status của user | ✅ |

### Email Verification (`/api/emailverification`)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/emailverification/send` | Gửi email verification | ❌ |
| POST | `/api/emailverification/verify` | Verify email với token | ❌ |

### Admin (`/api/admin`)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/admin/users` | Lấy danh sách users (admin only) | ✅ Admin |
| GET | `/api/admin/stats` | Lấy statistics (admin only) | ✅ Admin |

## 🔐 Authentication

### JWT Token

Sau khi login thành công, client nhận được JWT token:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "username",
    "isVip": false
  }
}
```

### Sử dụng Token

Gửi token trong header:

```
Authorization: Bearer {token}
```

### Google OAuth

1. User đăng nhập với Google trên frontend
2. Frontend gửi `idToken` từ Google đến `/api/auth/google`
3. Backend verify token và tạo/update user
4. Trả về JWT token

## 💳 PayOS Integration

### Payment Flow

1. **Create Order**: User chọn VIP plan → `POST /api/payments/create-order`
   - Backend tạo payment record trong DB
   - Gọi PayOS API để tạo payment link
   - Trả về `checkoutUrl` cho frontend

2. **User Payment**: Frontend redirect user đến PayOS checkout page

3. **Webhook**: PayOS gọi `POST /api/payments/webhook` sau khi thanh toán
   - Verify signature
   - Update payment status
   - Activate VIP cho user

4. **Verify**: Frontend poll `GET /api/payments/verify/{orderCode}` để check status

### PayOS Configuration

Cần config 3 keys từ PayOS Dashboard:
- `ClientId`
- `ApiKey`
- `ChecksumKey` (dùng để verify webhook signature)

Webhook URL cần đăng ký trong PayOS Dashboard:
```
https://your-api-domain.com/api/payments/webhook
```

## 📁 Cấu trúc thư mục

```
E-Education.API/
├── Controllers/           # API Controllers
│   ├── AuthController.cs
│   ├── UsersController.cs
│   ├── DesignComponentsController.cs
│   ├── CommentsController.cs
│   ├── PaymentsController.cs
│   ├── FavoritesController.cs
│   ├── ViewHistoryController.cs
│   ├── EmailVerificationController.cs
│   └── AdminController.cs
├── Models/                # Data Models
│   ├── User.cs
│   ├── DesignComponent.cs
│   ├── Comment.cs
│   ├── Payment.cs
│   ├── VipPlan.cs
│   └── DTOs/             # Data Transfer Objects
│       ├── LoginDto.cs
│       ├── RegisterDto.cs
│       └── AuthResponseDto.cs
├── Data/                  # Database Context
│   ├── ApplicationDbContext.cs
│   └── DbInitializer.cs
├── Services/              # Business Logic Services
│   ├── AuthService.cs
│   ├── GoogleAuthService.cs
│   └── EmailService.cs
├── Program.cs             # Application entry point
├── appsettings.json       # Configuration (không commit)
├── appsettings.example.json  # Configuration template
├── Dockerfile             # Docker configuration
└── E-Education.API.csproj # Project file
```

## 🚢 Deployment

### Render.com (Recommended)

1. Connect GitHub repository
2. Chọn service type: **Web Service**
3. Build command: `cd E-Education.API && dotnet publish -c Release -o ./publish`
4. Start command: `cd E-Education.API && dotnet ./publish/E-Education.API.dll`
5. Set environment variables:
   - `DATABASE_URL`
   - `JWT_SECRET_KEY`
   - `PAYOS__CLIENTID`
   - `PAYOS__APIKEY`
   - `PAYOS__CHECKSUMKEY`
   - `FRONTEND_URL`
6. Deploy!

### Docker

```bash
# Build
docker build -t e-education-api .

# Run
docker run -d \
  -p 8080:8080 \
  -e DATABASE_URL=postgresql://... \
  -e JWT_SECRET_KEY=... \
  e-education-api
```

## 🔒 Security

- ✅ JWT token authentication
- ✅ BCrypt password hashing
- ✅ CORS configured
- ✅ HTTPS required (production)
- ✅ SQL injection protection (EF Core parameterized queries)
- ✅ PayOS webhook signature verification

## 🧪 Testing với Swagger

1. Chạy application: `dotnet run`
2. Mở browser: `http://localhost:5000/swagger`
3. Test các endpoints trực tiếp trên Swagger UI
4. Authenticate: Click "Authorize" → Nhập JWT token

## 📝 Logging

Application sử dụng built-in logging của ASP.NET Core:

```csharp
_logger.LogInformation("Message");
_logger.LogError(ex, "Error message");
```

Logs được hiển thị trong console và có thể configure trong `appsettings.json`.

## 🤝 Contributing

1. Fork repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## 📄 License

Private project - All rights reserved

## 🔗 Links

- **API Base URL**: https://e-education-be.onrender.com/api
- **Swagger UI**: https://e-education-be.onrender.com/swagger
- **GitHub**: [Repository URL]

---

Built with ❤️ using ASP.NET Core 8.0 + PostgreSQL

