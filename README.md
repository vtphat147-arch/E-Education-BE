# E-Education Backend API

.NET 8.0 Web API cho nền tảng E-Education

## Công nghệ

- .NET 8.0
- Entity Framework Core
- PostgreSQL
- Swagger/OpenAPI

## Setup Local

1. Cài đặt PostgreSQL
2. Tạo database `EEducationDb`
3. Update `appsettings.Development.json` với connection string của bạn
4. Chạy SQL script để tạo bảng và data: `render-database-setup.sql`
5. Restore packages và run:
```bash
cd E-Education.API
dotnet restore
dotnet run
```

API sẽ chạy tại: `https://localhost:5001` hoặc `http://localhost:5000`

Swagger UI: `https://localhost:5001/swagger`

## Deploy lên Render

1. **Tạo PostgreSQL Database trên Render:**
   - Vào Render Dashboard → New + → PostgreSQL
   - Lưu lại Internal Database URL

2. **Chạy SQL Script:**
   - Vào database → Tab "Query" → Copy và chạy `render-database-setup.sql`

3. **Deploy Web Service:**
   - New + → Web Service → Connect GitHub repo
   - **Root Directory:** `E-Education.API`
   - **Environment:** Docker
   - **Build Command:** (để trống, Render tự build Dockerfile)
   - **Start Command:** (để trống)
   
4. **Environment Variables:**
   - `DATABASE_URL` = Internal Database URL từ PostgreSQL service (Render tự động link nếu cùng project)
   - `ASPNETCORE_ENVIRONMENT` = `Production`
   - `ASPNETCORE_URLS` = `http://0.0.0.0:10000`

5. **API Endpoints:**
   - Health check: `GET /`
   - Get all courses: `GET /api/Courses`
   - Get course by id: `GET /api/Courses/{id}`
   - Search: `GET /api/Courses?search=react`
   - Filter by category: `GET /api/Courses?category=programming`
   - Swagger: `https://your-api.onrender.com/swagger`

## Lưu ý

- Render cung cấp `DATABASE_URL` environment variable, Program.cs tự động convert sang format .NET
- Nếu database chưa có table, API sẽ tự tạo (EnsureCreated)
- Nhớ chạy SQL script để có dữ liệu mẫu

