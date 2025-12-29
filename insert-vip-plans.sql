-- Insert VIP plans vào database
-- Chạy script này trên Render Database SQL Editor

-- Xóa các plans cũ nếu cần (optional)
-- DELETE FROM "VipPlans";

-- Insert 3 gói VIP
INSERT INTO "VipPlans" ("Name", "Days", "Price", "IsActive", "CreatedAt")
VALUES 
    ('VIP 1 Tháng', 30, 150000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 3 Tháng', 90, 400000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 1 Năm', 365, 1200000, TRUE, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- Verify plans đã được insert
SELECT * FROM "VipPlans" WHERE "IsActive" = TRUE ORDER BY "Days";

