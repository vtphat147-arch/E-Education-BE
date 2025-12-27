# Hướng dẫn Setup Database

## Bước 1: Tạo bảng và Insert dữ liệu

Chạy file SQL: `render-design-components-setup.sql`

### Cách chạy trên Render:

1. Vào **Render Dashboard** → Chọn **PostgreSQL database**
2. Click tab **"Query"** hoặc **"SQL Editor"**
3. Copy toàn bộ nội dung file `render-design-components-setup.sql`
4. Paste và click **"Run"**

### Hoặc dùng psql:

```bash
psql "your_database_url" -f render-design-components-setup.sql
```

## Script sẽ làm gì:

1. ✅ Tạo bảng `DesignComponents` (nếu chưa có)
2. ✅ Tạo indexes để tối ưu performance
3. ✅ Insert 6 components mẫu (nếu bảng rỗng):
   - Modern Navbar (header)
   - Sticky Header (header)
   - Glass Footer (footer)
   - Sidebar Navigation (sidebar)
   - Card Layout (layout)
   - Modern Typography (typography)

## Kiểm tra:

Sau khi chạy xong, kiểm tra bằng cách:
- GET `https://your-api.onrender.com/api/components`
- Hoặc vào Swagger: `https://your-api.onrender.com/swagger`

