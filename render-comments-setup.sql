-- Create Comments table for component reviews/comments
-- Run this script after render-users-setup.sql and render-design-components-setup.sql

-- Create Comments table
CREATE TABLE IF NOT EXISTS "Comments" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" INTEGER NOT NULL,
    "ComponentId" INTEGER NOT NULL,
    "Content" VARCHAR(2000) NOT NULL,
    "Likes" INTEGER NOT NULL DEFAULT 0,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign keys
    CONSTRAINT "FK_Comments_Users_UserId" 
        FOREIGN KEY ("UserId") 
        REFERENCES "Users" ("Id") 
        ON DELETE CASCADE,
    
    CONSTRAINT "FK_Comments_DesignComponents_ComponentId" 
        FOREIGN KEY ("ComponentId") 
        REFERENCES "DesignComponents" ("Id") 
        ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS "IX_Comments_UserId" ON "Comments" ("UserId");
CREATE INDEX IF NOT EXISTS "IX_Comments_ComponentId" ON "Comments" ("ComponentId");
CREATE INDEX IF NOT EXISTS "IX_Comments_CreatedAt" ON "Comments" ("CreatedAt" DESC);

-- Add comments to some components for testing (optional)
-- You can remove this section if you don't want sample data

-- Sample comments (assuming user ID 1 exists and component IDs 1-6 exist)
-- Only insert if users and components exist
INSERT INTO "Comments" ("UserId", "ComponentId", "Content", "Likes", "CreatedAt", "UpdatedAt")
SELECT 
    1 as "UserId",
    1 as "ComponentId",
    'This is a great header component! Very clean and modern design.' as "Content",
    0 as "Likes",
    CURRENT_TIMESTAMP as "CreatedAt",
    CURRENT_TIMESTAMP as "UpdatedAt"
WHERE EXISTS (SELECT 1 FROM "Users" WHERE "Id" = 1)
  AND EXISTS (SELECT 1 FROM "DesignComponents" WHERE "Id" = 1)
ON CONFLICT DO NOTHING;

INSERT INTO "Comments" ("UserId", "ComponentId", "Content", "Likes", "CreatedAt", "UpdatedAt")
SELECT 
    1 as "UserId",
    2 as "ComponentId",
    'Love the glassmorphism effect! Perfect for modern websites.' as "Content",
    2 as "Likes",
    CURRENT_TIMESTAMP as "CreatedAt",
    CURRENT_TIMESTAMP as "UpdatedAt"
WHERE EXISTS (SELECT 1 FROM "Users" WHERE "Id" = 1)
  AND EXISTS (SELECT 1 FROM "DesignComponents" WHERE "Id" = 2)
ON CONFLICT DO NOTHING;

-- Note: This script should be run after:
-- 1. render-users-setup.sql (creates Users table and admin user)
-- 2. render-design-components-setup.sql (creates DesignComponents table and components)
-- 3. render-design-components-insert-more.sql (adds more components)

