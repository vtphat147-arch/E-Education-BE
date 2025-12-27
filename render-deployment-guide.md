# Hướng dẫn Deploy Backend lên Render

## Bước 1: Tạo PostgreSQL Database trên Render

1. Đăng nhập vào [Render Dashboard](https://dashboard.render.com)
2. Click **"New +"** → Chọn **"PostgreSQL"**
3. Điền thông tin:
   - **Name**: `e-education-db` (hoặc tên bạn muốn)
   - **Database**: `e_education_db`
   - **User**: `e_education_user` (hoặc để mặc định)
   - **Region**: Chọn gần bạn nhất (Singapore, US, etc.)
   - **PostgreSQL Version**: 15 (hoặc mới nhất)
   - **Plan**: Free tier (hoặc paid nếu cần)
4. Click **"Create Database"**
5. **Lưu lại External Database URL** (sẽ dùng sau)

## Bước 2: Chạy SQL Script để tạo bảng và data

Render cung cấp **Connection Pooling URL** và **Internal Database URL**

### Cách 1: Dùng Render Shell (Khuyến nghị)

1. Vào Dashboard → Chọn database vừa tạo
2. Click tab **"Connect"** → Copy **"Internal Database URL"** hoặc **"Connection Pooling URL"**
3. Click tab **"Shell"** → Mở terminal
4. Chạy lệnh:
```bash
psql "postgresql://user:password@host:port/database" -f /path/to/render-database-setup.sql
```

### Cách 2: Dùng Render SQL Editor

1. Vào Dashboard → Chọn database
2. Click tab **"Query"** hoặc **"SQL Editor"**
3. Copy nội dung file `render-database-setup.sql`
4. Paste và click **"Run"**

### Cách 3: Dùng psql từ máy local

1. Copy **"External Database URL"** từ Render Dashboard
2. Chạy lệnh:
```bash
psql "EXTERNAL_DATABASE_URL" -f render-database-setup.sql
```

## Bước 3: Deploy Backend API lên Render

1. **Push code backend lên GitHub** (nếu chưa có)
2. Vào Render Dashboard → Click **"New +"** → Chọn **"Web Service"**
3. Kết nối GitHub repo chứa backend
4. Điền thông tin:
   - **Name**: `e-education-api`
   - **Environment**: `Docker`
   - **Region**: Cùng region với database
   - **Branch**: `main` (hoặc branch bạn muốn)
   - **Root Directory**: `Backend/E-Education.API` (nếu backend trong subfolder)
5. **Environment Variables**:
   - Key: `ConnectionStrings__DefaultConnection`
   - Value: Copy **"Internal Database URL"** từ PostgreSQL service (Render tự động link nếu cùng service)
   
   **HOẶC** nếu database đã tạo trước:
   - Key: `ConnectionStrings__DefaultConnection`
   - Value: `postgresql://user:password@host:port/database` (từ Internal Database URL)
   
   - Key: `ASPNETCORE_ENVIRONMENT`
   - Value: `Production`
   
   - Key: `ASPNETCORE_URLS`
   - Value: `http://0.0.0.0:10000` (Port Render tự động assign, nhưng có thể set cụ thể)

6. Click **"Create Web Service"**

## Bước 4: Link Database với Web Service (Auto-connect)

Render tự động tạo biến môi trường `DATABASE_URL` nếu bạn:
- Tạo database và web service trong cùng 1 project
- Hoặc manual link trong **"Connections"** tab của Web Service

**Lưu ý**: Render dùng `DATABASE_URL` chứ không phải `ConnectionStrings__DefaultConnection`. Cần update `Program.cs` để đọc từ `DATABASE_URL` hoặc set `ConnectionStrings__DefaultConnection=$DATABASE_URL`

## Tự động chạy migrations/data seeding

Render không tự động chạy SQL scripts khi deploy. Bạn có thể:

### Option 1: Dùng Build Command
Thêm vào Render build command:
```bash
# Build project trước
dotnet restore && dotnet build
# Chạy SQL script (cần psql trong container)
psql $DATABASE_URL -f database-setup.sql || echo "Table may already exist"
```

### Option 2: Dùng Startup Script trong Program.cs
Tự động chạy khi app start (kiểm tra table chưa tồn tại mới chạy)

### Option 3: Chạy manual một lần
Chạy SQL script một lần qua Render Shell hoặc SQL Editor (như Bước 2)

## Kiểm tra

Sau khi deploy xong:
1. Vào Web Service → Click URL (ví dụ: `https://e-education-api.onrender.com`)
2. Test API: `https://your-api.onrender.com/api/Courses`
3. Test Swagger: `https://your-api.onrender.com/swagger` (nếu enable trong Production)

## Lưu ý quan trọng

- **Free tier**: Render sẽ sleep sau 15 phút không có traffic. Request đầu tiên sẽ mất ~30s để wake up
- **Database URL**: Render tự động cung cấp `DATABASE_URL` environment variable
- **Connection String**: Backend cần đọc từ environment variable, không hardcode
- **Health Checks**: Render có health check endpoint, có thể config trong Web Service settings

