# VIP System Setup Checklist

## Bước 1: Chạy SQL Migration

**QUAN TRỌNG**: Bạn CẦN chạy SQL script để tạo tables và insert VIP plans vào database!

1. Vào Render Dashboard → Database của bạn
2. Mở **SQL Editor** hoặc **Connect** bằng psql
3. Chạy file `vip-system-setup.sql`:

```sql
-- Hoặc copy toàn bộ nội dung từ vip-system-setup.sql
```

**Hoặc chạy từng lệnh:**

```sql
-- 1. Add VIP columns to Users
ALTER TABLE "Users" ADD COLUMN IF NOT EXISTS "IsVip" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE "Users" ADD COLUMN IF NOT EXISTS "VipExpiresAt" TIMESTAMP NULL;
ALTER TABLE "Users" ADD COLUMN IF NOT EXISTS "VipSubscriptionId" VARCHAR(255) NULL;

-- 2. Add IsPremium to DesignComponents
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

-- 5. Insert VIP plans (QUAN TRỌNG!)
INSERT INTO "VipPlans" ("Name", "Days", "Price", "IsActive", "CreatedAt")
VALUES 
    ('VIP 1 Tháng', 30, 150000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 3 Tháng', 90, 400000, TRUE, CURRENT_TIMESTAMP),
    ('VIP 1 Năm', 365, 1200000, TRUE, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;
```

## Bước 2: Verify Plans đã được insert

Chạy query này để kiểm tra:

```sql
SELECT * FROM "VipPlans" WHERE "IsActive" = TRUE;
```

Nếu không có kết quả, có nghĩa là plans chưa được insert. Hãy chạy lại INSERT statement ở trên.

## Bước 3: Setup PayOS (theo PAYOS_RENDER_SETUP.md)

1. Thêm Environment Variables trên Render
2. Setup Webhook URL trên PayOS Dashboard

## Bước 4: Test

1. Click button "Nâng cấp VIP" trên Header
2. Modal sẽ hiển thị:
   - Loading spinner (nếu đang fetch)
   - 3 gói VIP (nếu đã có data)
   - Empty state message (nếu chưa có data)

## Troubleshooting

### Modal hiển thị "Chưa có gói VIP"
- **Nguyên nhân**: Database chưa có plans hoặc API không trả về data
- **Giải pháp**: 
  1. Kiểm tra database đã có bảng `VipPlans` chưa
  2. Chạy INSERT statement để thêm plans
  3. Kiểm tra API endpoint `/api/payments/plans` có trả về data không
  4. Mở DevTools Console xem có error không

### API trả về 404 hoặc 500
- Kiểm tra backend đã deploy chưa
- Kiểm tra route `/api/payments/plans` có tồn tại không
- Kiểm tra database connection

### Plans không hiển thị sau khi insert
- Refresh browser (hard refresh: Ctrl+F5)
- Kiểm tra `IsActive` = TRUE trong database
- Kiểm tra API response trong Network tab

