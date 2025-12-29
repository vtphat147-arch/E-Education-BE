-- Script để xóa và tạo lại VipPlans và Payments từ đầu
-- Chạy script này trên Render Database SQL Editor

-- Bước 1: Xóa table Payments trước (vì có foreign key đến VipPlans)
DROP TABLE IF EXISTS "Payments" CASCADE;

-- Bước 2: Xóa table VipPlans
DROP TABLE IF EXISTS "VipPlans" CASCADE;

-- Bước 3: Tạo lại table VipPlans
CREATE TABLE "VipPlans" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL,
    "Days" INTEGER NOT NULL,
    "Price" DECIMAL(18,2) NOT NULL,
    "IsActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Bước 4: Tạo indexes cho VipPlans
CREATE INDEX IF NOT EXISTS "IX_VipPlans_IsActive" ON "VipPlans" ("IsActive");

-- Bước 5: Tạo lại table Payments
CREATE TABLE "Payments" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" INTEGER NOT NULL,
    "VipPlanId" INTEGER NOT NULL,
    "Amount" DECIMAL(18,2) NOT NULL,
    "Currency" VARCHAR(10) NOT NULL DEFAULT 'VND',
    "PayOSOrderCode" VARCHAR(255) UNIQUE NOT NULL,
    "PayOSTransactionCode" VARCHAR(255) NULL,
    "Status" VARCHAR(50) NOT NULL DEFAULT 'pending',
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "CompletedAt" TIMESTAMP NULL,
    FOREIGN KEY ("UserId") REFERENCES "Users"("Id") ON DELETE CASCADE,
    FOREIGN KEY ("VipPlanId") REFERENCES "VipPlans"("Id") ON DELETE RESTRICT
);

-- Bước 6: Tạo indexes cho Payments
CREATE INDEX IF NOT EXISTS "IX_Payments_UserId" ON "Payments" ("UserId");
CREATE INDEX IF NOT EXISTS "IX_Payments_PayOSOrderCode" ON "Payments" ("PayOSOrderCode");
CREATE INDEX IF NOT EXISTS "IX_Payments_Status" ON "Payments" ("Status");

-- Bước 7: Insert 3 gói VIP mặc định
INSERT INTO "VipPlans" ("Name", "Days", "Price", "IsActive", "CreatedAt")
VALUES 
    ('VIP 1 Tháng', 30, 150000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 3 Tháng', 90, 400000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 1 Năm', 365, 1200000, TRUE, CURRENT_TIMESTAMP);

-- Bước 8: Verify
SELECT 'VipPlans table created successfully!' as Status;
SELECT COUNT(*) as TotalPlans FROM "VipPlans";
SELECT * FROM "VipPlans" WHERE "IsActive" = TRUE ORDER BY "Days";

