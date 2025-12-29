-- Script để kiểm tra VIP Plans trong database

-- 1. Kiểm tra table có tồn tại không
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name = 'VipPlans';

-- 2. Kiểm tra tất cả plans (kể cả inactive)
SELECT * FROM "VipPlans" ORDER BY "Days";

-- 3. Kiểm tra chỉ active plans (như API sẽ query)
SELECT * FROM "VipPlans" 
WHERE "IsActive" = TRUE 
ORDER BY "Days";

-- 4. Kiểm tra số lượng plans
SELECT COUNT(*) as total_plans FROM "VipPlans";
SELECT COUNT(*) as active_plans FROM "VipPlans" WHERE "IsActive" = TRUE;

-- 5. Nếu chưa có data, insert lại
-- Xóa tất cả plans cũ (nếu cần)
-- DELETE FROM "VipPlans";

-- Insert plans (nếu chưa có)
INSERT INTO "VipPlans" ("Name", "Days", "Price", "IsActive", "CreatedAt")
VALUES 
    ('VIP 1 Tháng', 30, 150000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 3 Tháng', 90, 400000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 1 Năm', 365, 1200000, TRUE, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 6. Verify sau khi insert
SELECT * FROM "VipPlans" WHERE "IsActive" = TRUE ORDER BY "Days";

