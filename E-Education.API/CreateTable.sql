CREATE TABLE IF NOT EXISTS "Courses" (
    "Id" SERIAL PRIMARY KEY,
    "Title" VARCHAR(200) NOT NULL,
    "Instructor" VARCHAR(100) NOT NULL,
    "Category" VARCHAR(50) NOT NULL,
    "Rating" DECIMAL(3,2) NOT NULL,
    "Reviews" INTEGER NOT NULL,
    "Students" INTEGER NOT NULL,
    "Price" DECIMAL(12,2) NOT NULL,
    "OriginalPrice" DECIMAL(12,2) NULL,
    "Duration" VARCHAR(50) NOT NULL,
    "Lessons" INTEGER NOT NULL,
    "Image" VARCHAR(500) NOT NULL,
    "Level" VARCHAR(50) NOT NULL,
    "Badge" VARCHAR(50) NULL,
    "Description" TEXT NULL,
    "CreatedAt" TIMESTAMP NOT NULL,
    "UpdatedAt" TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS "IX_Courses_Category" ON "Courses" ("Category");
CREATE INDEX IF NOT EXISTS "IX_Courses_Title" ON "Courses" ("Title");

