-- Tạo bảng Courses
CREATE TABLE IF NOT EXISTS "Courses" (
    "Id" SERIAL PRIMARY KEY,
    "Title" VARCHAR(255) NOT NULL,
    "Instructor" VARCHAR(255) NOT NULL,
    "Category" VARCHAR(100) NOT NULL,
    "Rating" DECIMAL(3,1) NOT NULL DEFAULT 0,
    "Reviews" INTEGER NOT NULL DEFAULT 0,
    "Students" INTEGER NOT NULL DEFAULT 0,
    "Price" DECIMAL(18,2) NOT NULL,
    "OriginalPrice" DECIMAL(18,2) NULL,
    "Duration" VARCHAR(50) NOT NULL,
    "Lessons" INTEGER NOT NULL DEFAULT 0,
    "Image" TEXT NOT NULL,
    "Level" VARCHAR(50) NOT NULL,
    "Badge" VARCHAR(50) NULL,
    "Description" TEXT NULL,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO "Courses" ("Title", "Instructor", "Category", "Rating", "Reviews", "Students", "Price", "OriginalPrice", "Duration", "Lessons", "Image", "Level", "Badge", "Description", "CreatedAt", "UpdatedAt") VALUES
('Lập trình Web với React', 'Nguyễn Văn A', 'programming', 4.8, 1234, 5432, 899000, 1299000, '40 giờ', 120, 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400&h=250&fit=crop', 'Cơ bản', 'Bán chạy', 'Học React từ cơ bản đến nâng cao', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Thiết kế UI/UX với Figma', 'Trần Thị B', 'design', 4.9, 892, 3210, 699000, 999000, '30 giờ', 85, 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400&h=250&fit=crop', 'Trung cấp', 'Mới', 'Master Figma từ zero to hero', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Marketing Digital cho người mới', 'Lê Văn C', 'marketing', 4.7, 654, 2890, 599000, NULL, '25 giờ', 70, 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&h=250&fit=crop', 'Cơ bản', 'Hot', 'Khóa học marketing digital toàn diện', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Python cho Data Science', 'Phạm Thị D', 'data', 4.8, 1123, 4567, 999000, 1499000, '50 giờ', 150, 'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?w=400&h=250&fit=crop', 'Nâng cao', 'Bán chạy', 'Học Python và Data Science chuyên sâu', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Khởi nghiệp với Business Model', 'Hoàng Văn E', 'business', 4.6, 445, 1789, 799000, 1199000, '20 giờ', 55, 'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=400&h=250&fit=crop', 'Trung cấp', 'Giảm giá', 'Xây dựng business model thành công', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('JavaScript Advanced', 'Ngô Thị F', 'programming', 4.9, 1567, 6789, 1099000, NULL, '45 giờ', 135, 'https://images.unsplash.com/photo-1579468118864-1b9ea3c0db4a?w=400&h=250&fit=crop', 'Nâng cao', 'Hot', 'Master JavaScript ES6+ và Advanced Patterns', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Thiết kế Logo chuyên nghiệp', 'Đỗ Văn G', 'design', 4.7, 789, 2345, 499000, 799000, '15 giờ', 45, 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=400&h=250&fit=crop', 'Cơ bản', NULL, 'Tạo logo đẹp và chuyên nghiệp', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Facebook Ads từ A-Z', 'Vũ Thị H', 'marketing', 4.8, 1123, 4321, 899000, 1299000, '35 giờ', 100, 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=400&h=250&fit=crop', 'Trung cấp', 'Bán chạy', 'Quảng cáo Facebook hiệu quả', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Machine Learning với TensorFlow', 'Bùi Văn I', 'data', 4.9, 1456, 5678, 1299000, NULL, '60 giờ', 180, 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?w=400&h=250&fit=crop', 'Nâng cao', 'Mới', 'Xây dựng model ML từ đầu', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Quản lý tài chính doanh nghiệp', 'Đinh Thị K', 'business', 4.6, 567, 2134, 699000, 999000, '28 giờ', 80, 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=400&h=250&fit=crop', 'Trung cấp', NULL, 'Quản lý tài chính hiệu quả', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


