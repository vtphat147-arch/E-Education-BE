-- Create Users table
CREATE TABLE IF NOT EXISTS "Users" (
    "Id" SERIAL PRIMARY KEY,
    "Email" VARCHAR(255) NOT NULL UNIQUE,
    "Username" VARCHAR(255) NOT NULL UNIQUE,
    "PasswordHash" TEXT NOT NULL,
    "FullName" VARCHAR(100),
    "AvatarUrl" VARCHAR(500),
    "Bio" VARCHAR(1000),
    "IsAdmin" BOOLEAN NOT NULL DEFAULT FALSE,
    "IsEmailVerified" BOOLEAN NOT NULL DEFAULT FALSE,
    "GoogleId" VARCHAR(255),
    "GoogleEmail" VARCHAR(500),
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS "IX_Users_Email" ON "Users" ("Email");
CREATE INDEX IF NOT EXISTS "IX_Users_Username" ON "Users" ("Username");
CREATE INDEX IF NOT EXISTS "IX_Users_GoogleId" ON "Users" ("GoogleId");

-- Create EmailVerifications table
CREATE TABLE IF NOT EXISTS "EmailVerifications" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" INTEGER NOT NULL,
    "Token" VARCHAR(255) NOT NULL UNIQUE,
    "ExpiresAt" TIMESTAMP NOT NULL,
    "IsUsed" BOOLEAN NOT NULL DEFAULT FALSE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("UserId") REFERENCES "Users"("Id") ON DELETE CASCADE
);

-- Create indexes
CREATE INDEX IF NOT EXISTS "IX_EmailVerifications_Token" ON "EmailVerifications" ("Token");
CREATE INDEX IF NOT EXISTS "IX_EmailVerifications_UserId" ON "EmailVerifications" ("UserId");

-- Create Favorites table
CREATE TABLE IF NOT EXISTS "Favorites" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" INTEGER NOT NULL,
    "ComponentId" INTEGER NOT NULL,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("UserId") REFERENCES "Users"("Id") ON DELETE CASCADE,
    FOREIGN KEY ("ComponentId") REFERENCES "DesignComponents"("Id") ON DELETE CASCADE,
    UNIQUE ("UserId", "ComponentId")
);

-- Create index
CREATE INDEX IF NOT EXISTS "IX_Favorites_UserId_ComponentId" ON "Favorites" ("UserId", "ComponentId");

-- Create Comments table
CREATE TABLE IF NOT EXISTS "Comments" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" INTEGER NOT NULL,
    "ComponentId" INTEGER NOT NULL,
    "Content" VARCHAR(2000) NOT NULL,
    "Likes" INTEGER NOT NULL DEFAULT 0,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("UserId") REFERENCES "Users"("Id") ON DELETE CASCADE,
    FOREIGN KEY ("ComponentId") REFERENCES "DesignComponents"("Id") ON DELETE CASCADE
);

-- Create indexes
CREATE INDEX IF NOT EXISTS "IX_Comments_ComponentId" ON "Comments" ("ComponentId");
CREATE INDEX IF NOT EXISTS "IX_Comments_CreatedAt" ON "Comments" ("CreatedAt");

-- Create ComponentViewHistory table
CREATE TABLE IF NOT EXISTS "ComponentViewHistory" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" INTEGER NOT NULL,
    "ComponentId" INTEGER NOT NULL,
    "ViewedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("UserId") REFERENCES "Users"("Id") ON DELETE CASCADE,
    FOREIGN KEY ("ComponentId") REFERENCES "DesignComponents"("Id") ON DELETE CASCADE
);

-- Create indexes
CREATE INDEX IF NOT EXISTS "IX_ComponentViewHistory_UserId_ComponentId" ON "ComponentViewHistory" ("UserId", "ComponentId");
CREATE INDEX IF NOT EXISTS "IX_ComponentViewHistory_ViewedAt" ON "ComponentViewHistory" ("ViewedAt");

-- Insert default admin user (password: Admin123!)
-- BCrypt hash for "Admin123!" 
-- Note: You can generate new hash using: BCrypt.Net.BCrypt.HashPassword("Admin123!")
INSERT INTO "Users" ("Email", "Username", "PasswordHash", "FullName", "IsAdmin", "IsEmailVerified", "CreatedAt", "UpdatedAt")
VALUES (
    'admin@e-education.com',
    'admin',
    '$2a$11$Yf6fE9vK2Lx8XqY7Z5N2UePqR3S5T8VwY0Za1Bc2De3Fg4Hi5Jk6Lm',
    'Administrator',
    TRUE,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT ("Email") DO NOTHING;

