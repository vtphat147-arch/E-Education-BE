-- Tạo bảng DesignComponents
CREATE TABLE IF NOT EXISTS "DesignComponents" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(255) NOT NULL,
    "Category" VARCHAR(100) NOT NULL,
    "Type" VARCHAR(100) NOT NULL,
    "Preview" TEXT NOT NULL,
    "HtmlCode" TEXT NOT NULL,
    "CssCode" TEXT NOT NULL,
    "JsCode" TEXT NULL,
    "Description" TEXT NOT NULL,
    "Tags" VARCHAR(50) NULL,
    "Framework" VARCHAR(50) NULL,
    "Views" INTEGER NOT NULL DEFAULT 0,
    "Likes" INTEGER NOT NULL DEFAULT 0,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tạo indexes
CREATE INDEX IF NOT EXISTS "IX_DesignComponents_Category" ON "DesignComponents" ("Category");
CREATE INDEX IF NOT EXISTS "IX_DesignComponents_Type" ON "DesignComponents" ("Type");
CREATE INDEX IF NOT EXISTS "IX_DesignComponents_Name" ON "DesignComponents" ("Name");

-- Insert sample design components
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "DesignComponents" LIMIT 1) THEN
        -- Header Components
        INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt") VALUES
        ('Modern Navbar', 'header', 'navbar', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop', 
        '<nav class="navbar">
            <div class="logo">Logo</div>
            <ul class="nav-links">
                <li><a href="#">Home</a></li>
                <li><a href="#">About</a></li>
                <li><a href="#">Services</a></li>
                <li><a href="#">Contact</a></li>
            </ul>
        </nav>',
        '.navbar { display: flex; justify-content: space-between; align-items: center; padding: 1rem 2rem; background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); } .nav-links { display: flex; gap: 2rem; list-style: none; } .nav-links a { text-decoration: none; color: #333; font-weight: 500; }',
        'document.addEventListener("DOMContentLoaded", () => { console.log("Navbar loaded"); });',
        'Modern navigation bar with clean design and smooth transitions', 'modern,responsive,clean', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

        ('Sticky Header', 'header', 'sticky-header', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
        '<header class="sticky-header">
            <div class="container">
                <div class="logo">Brand</div>
                <nav class="menu">
                    <a href="#">Home</a>
                    <a href="#">Products</a>
                    <a href="#">About</a>
                </nav>
            </div>
        </header>',
        '.sticky-header { position: sticky; top: 0; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); padding: 1rem; z-index: 1000; } .container { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }',
        NULL,
        'Sticky header with glass morphism effect', 'sticky,glass,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

        ('Glass Footer', 'footer', 'glass-footer', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
        '<footer class="glass-footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Company</h3>
                    <p>About Us</p>
                    <p>Contact</p>
                </div>
                <div class="footer-section">
                    <h3>Resources</h3>
                    <p>Documentation</p>
                    <p>Blog</p>
                </div>
            </div>
            <div class="footer-bottom">© 2024 All rights reserved</div>
        </footer>',
        '.glass-footer { background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); padding: 2rem; margin-top: 4rem; } .footer-content { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 2rem; }',
        NULL,
        'Beautiful glass morphism footer design', 'glass,modern,responsive', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

        ('Sidebar Navigation', 'sidebar', 'sidebar-nav', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
        '<aside class="sidebar">
            <nav class="sidebar-nav">
                <a href="#" class="nav-item active">Dashboard</a>
                <a href="#" class="nav-item">Projects</a>
                <a href="#" class="nav-item">Settings</a>
                <a href="#" class="nav-item">Profile</a>
            </nav>
        </aside>',
        '.sidebar { width: 250px; background: #1a1a1a; color: white; min-height: 100vh; padding: 2rem 0; } .nav-item { display: block; padding: 1rem 2rem; color: #ccc; text-decoration: none; transition: all 0.3s; } .nav-item:hover, .nav-item.active { background: #333; color: white; }',
        NULL,
        'Dark themed sidebar navigation', 'dark,sidebar,responsive', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

        ('Card Layout', 'layout', 'card-grid', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
        '<div class="card-grid">
            <div class="card">Card 1</div>
            <div class="card">Card 2</div>
            <div class="card">Card 3</div>
        </div>',
        '.card-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 2rem; padding: 2rem; } .card { background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }',
        NULL,
        'Responsive card grid layout', 'grid,responsive,cards', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

        ('Modern Typography', 'typography', 'heading-styles', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
        '<div class="typography-demo">
            <h1 class="gradient-text">Gradient Heading</h1>
            <h2 class="outline-text">Outline Text</h2>
            <p class="body-text">Beautiful typography styles</p>
        </div>',
        '.gradient-text { background: linear-gradient(45deg, #667eea, #764ba2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-size: 3rem; font-weight: bold; } .outline-text { -webkit-text-stroke: 2px #333; color: transparent; font-size: 2.5rem; }',
        NULL,
        'Modern typography effects and styles', 'typography,gradient,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
        
        RAISE NOTICE 'Đã insert % dòng dữ liệu mẫu', 6;
    ELSE
        RAISE NOTICE 'Bảng đã có dữ liệu, bỏ qua insert';
    END IF;
END $$;

SELECT COUNT(*) as "TotalComponents" FROM "DesignComponents";

