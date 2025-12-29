-- VIP System Migration Script
-- Run this script to add VIP functionality to the database

-- 1. Add VIP columns to Users table
ALTER TABLE "Users" ADD COLUMN IF NOT EXISTS "IsVip" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE "Users" ADD COLUMN IF NOT EXISTS "VipExpiresAt" TIMESTAMP NULL;
ALTER TABLE "Users" ADD COLUMN IF NOT EXISTS "VipSubscriptionId" VARCHAR(255) NULL;

-- 2. Add IsPremium column to DesignComponents table
ALTER TABLE "DesignComponents" ADD COLUMN IF NOT EXISTS "IsPremium" BOOLEAN NOT NULL DEFAULT FALSE;

-- 3. Create VipPlans table
CREATE TABLE IF NOT EXISTS "VipPlans" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL,
    "Days" INTEGER NOT NULL,
    "Price" DECIMAL(18,2) NOT NULL,
    "IsActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create index for VipPlans
CREATE INDEX IF NOT EXISTS "IX_VipPlans_IsActive" ON "VipPlans" ("IsActive");

-- 4. Create Payments table
CREATE TABLE IF NOT EXISTS "Payments" (
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

-- Create indexes for Payments
CREATE INDEX IF NOT EXISTS "IX_Payments_UserId" ON "Payments" ("UserId");
CREATE INDEX IF NOT EXISTS "IX_Payments_PayOSOrderCode" ON "Payments" ("PayOSOrderCode");
CREATE INDEX IF NOT EXISTS "IX_Payments_Status" ON "Payments" ("Status");

-- 5. Insert default VIP plans
INSERT INTO "VipPlans" ("Name", "Days", "Price", "IsActive", "CreatedAt")
VALUES 
    ('VIP 1 Tháng', 30, 150000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 3 Tháng', 90, 400000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 1 Năm', 365, 1200000, TRUE, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 6. Optional: Mark some existing components as Premium (example)
-- Uncomment and modify as needed:
-- UPDATE "DesignComponents" 
-- SET "IsPremium" = TRUE 
-- WHERE "Id" IN (1, 2, 3); -- Replace with actual component IDs

-- Verify tables were created
SELECT 'VIP System setup completed successfully!' as Status;
