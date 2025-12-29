-- Create ComponentLikes table for tracking user likes
-- Run this script after render-users-setup.sql and render-design-components-setup.sql

-- Create ComponentLikes table
CREATE TABLE IF NOT EXISTS "ComponentLikes" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" INTEGER NOT NULL,
    "ComponentId" INTEGER NOT NULL,
    "LikedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign keys
    CONSTRAINT "FK_ComponentLikes_Users_UserId" 
        FOREIGN KEY ("UserId") 
        REFERENCES "Users" ("Id") 
        ON DELETE CASCADE,
    
    CONSTRAINT "FK_ComponentLikes_DesignComponents_ComponentId" 
        FOREIGN KEY ("ComponentId") 
        REFERENCES "DesignComponents" ("Id") 
        ON DELETE CASCADE,
    
    -- Ensure one like per user per component
    UNIQUE ("UserId", "ComponentId")
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS "IX_ComponentLikes_UserId" ON "ComponentLikes" ("UserId");
CREATE INDEX IF NOT EXISTS "IX_ComponentLikes_ComponentId" ON "ComponentLikes" ("ComponentId");
CREATE INDEX IF NOT EXISTS "IX_ComponentLikes_UserId_ComponentId" ON "ComponentLikes" ("UserId", "ComponentId");

-- Note: This script should be run after:
-- 1. render-users-setup.sql (creates Users table)
-- 2. render-design-components-setup.sql (creates DesignComponents table)



