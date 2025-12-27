-- Insert thêm nhiều components đẹp và hiện đại
-- Chạy file này sau khi đã chạy render-design-components-setup.sql

INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt") VALUES

-- ========== HEADERS ==========

('Gradient Animated Navbar', 'header', 'navbar-animated', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<nav class="nav-gradient">
  <div class="nav-container">
    <div class="logo-glow">Brand</div>
    <ul class="nav-menu">
      <li><a href="#" class="nav-link">Home</a></li>
      <li><a href="#" class="nav-link">Products</a></li>
      <li><a href="#" class="nav-link">About</a></li>
      <li><a href="#" class="nav-link active">Contact</a></li>
    </ul>
  </div>
</nav>',
'.nav-gradient { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 1.5rem 2rem; box-shadow: 0 10px 40px rgba(102, 126, 234, 0.3); } .nav-container { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; } .logo-glow { font-size: 1.5rem; font-weight: 800; color: white; text-shadow: 0 0 20px rgba(255,255,255,0.5); } .nav-menu { display: flex; gap: 2rem; list-style: none; } .nav-link { color: rgba(255,255,255,0.9); text-decoration: none; font-weight: 600; position: relative; transition: all 0.3s; } .nav-link:hover, .nav-link.active { color: white; text-shadow: 0 0 10px rgba(255,255,255,0.8); } .nav-link::after { content: ""; position: absolute; bottom: -5px; left: 0; width: 0; height: 2px; background: white; transition: width 0.3s; } .nav-link:hover::after, .nav-link.active::after { width: 100%; }',
NULL,
'Gradient navbar với animation và glow effects cực đẹp', 'gradient,animated,glow,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Floating Glass Header', 'header', 'glass-header', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<header class="glass-header">
  <div class="header-content">
    <div class="brand">Logo</div>
    <nav>
      <a href="#" class="nav-item">Work</a>
      <a href="#" class="nav-item">Services</a>
      <a href="#" class="nav-item">Team</a>
      <button class="cta-btn">Get Started</button>
    </nav>
  </div>
</header>',
'.glass-header { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); width: 90%; max-width: 1200px; background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 20px; padding: 1rem 2rem; z-index: 1000; } .header-content { display: flex; justify-content: space-between; align-items: center; } .brand { font-size: 1.5rem; font-weight: 700; color: #1a1a1a; } nav { display: flex; align-items: center; gap: 2rem; } .nav-item { color: #333; text-decoration: none; font-weight: 500; transition: color 0.3s; } .nav-item:hover { color: #667eea; } .cta-btn { background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 10px; font-weight: 600; cursor: pointer; transition: transform 0.3s; } .cta-btn:hover { transform: translateY(-2px); }',
NULL,
'Floating glass morphism header với backdrop blur hiện đại', 'glass,floating,morphism,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Minimalist Dark Navbar', 'header', 'minimal-dark', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<nav class="nav-dark">
  <div class="nav-wrapper">
    <div class="logo-minimal">A</div>
    <div class="nav-items">
      <a href="#" class="nav-link-dark">Home</a>
      <a href="#" class="nav-link-dark">Portfolio</a>
      <a href="#" class="nav-link-dark">Blog</a>
      <a href="#" class="nav-link-dark">Contact</a>
    </div>
  </div>
</nav>',
'.nav-dark { background: #0a0a0a; padding: 2rem 3rem; border-bottom: 1px solid rgba(255,255,255,0.1); } .nav-wrapper { max-width: 1400px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; } .logo-minimal { width: 50px; height: 50px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; font-weight: 800; } .nav-items { display: flex; gap: 3rem; } .nav-link-dark { color: rgba(255,255,255,0.7); text-decoration: none; font-weight: 500; font-size: 0.95rem; letter-spacing: 0.5px; transition: color 0.3s; position: relative; } .nav-link-dark::before { content: ""; position: absolute; bottom: -5px; left: 0; width: 0; height: 1px; background: #667eea; transition: width 0.3s; } .nav-link-dark:hover { color: white; } .nav-link-dark:hover::before { width: 100%; }',
NULL,
'Minimalist dark navbar với subtle animations', 'minimal,dark,elegant,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== FOOTERS ==========

('Modern Gradient Footer', 'footer', 'gradient-footer', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<footer class="footer-gradient">
  <div class="footer-grid">
    <div class="footer-col">
      <h4>Product</h4>
      <a href="#">Features</a>
      <a href="#">Pricing</a>
      <a href="#">Updates</a>
    </div>
    <div class="footer-col">
      <h4>Company</h4>
      <a href="#">About</a>
      <a href="#">Careers</a>
      <a href="#">Contact</a>
    </div>
    <div class="footer-col">
      <h4>Resources</h4>
      <a href="#">Documentation</a>
      <a href="#">Blog</a>
      <a href="#">Community</a>
    </div>
    <div class="footer-col">
      <h4>Connect</h4>
      <div class="social-links">
        <a href="#">Twitter</a>
        <a href="#">LinkedIn</a>
        <a href="#">GitHub</a>
      </div>
    </div>
  </div>
  <div class="footer-bottom">
    <p>© 2024 All rights reserved</p>
  </div>
</footer>',
'.footer-gradient { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 4rem 2rem 2rem; margin-top: 6rem; } .footer-grid { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 3rem; margin-bottom: 3rem; } .footer-col h4 { font-size: 1.1rem; font-weight: 700; margin-bottom: 1.5rem; } .footer-col a { display: block; color: rgba(255,255,255,0.8); text-decoration: none; margin-bottom: 0.75rem; transition: all 0.3s; } .footer-col a:hover { color: white; transform: translateX(5px); } .social-links { display: flex; gap: 1rem; } .footer-bottom { max-width: 1200px; margin: 0 auto; padding-top: 2rem; border-top: 1px solid rgba(255,255,255,0.2); text-align: center; color: rgba(255,255,255,0.7); }',
NULL,
'Modern gradient footer với grid layout và hover effects', 'gradient,modern,grid,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Minimal Dark Footer', 'footer', 'minimal-dark-footer', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<footer class="footer-minimal">
  <div class="footer-content">
    <div class="footer-left">
      <div class="footer-logo">Brand</div>
      <p class="footer-tagline">Building beautiful digital experiences</p>
    </div>
    <div class="footer-right">
      <div class="footer-links">
        <a href="#">Privacy</a>
        <a href="#">Terms</a>
        <a href="#">Cookies</a>
      </div>
    </div>
  </div>
  <div class="footer-divider"></div>
  <p class="footer-copyright">© 2024 Brand. All rights reserved.</p>
</footer>',
'.footer-minimal { background: #0a0a0a; color: rgba(255,255,255,0.7); padding: 4rem 2rem 2rem; } .footer-content { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2rem; } .footer-logo { font-size: 1.5rem; font-weight: 800; color: white; margin-bottom: 0.5rem; } .footer-tagline { color: rgba(255,255,255,0.5); font-size: 0.9rem; } .footer-links { display: flex; gap: 2rem; } .footer-links a { color: rgba(255,255,255,0.6); text-decoration: none; font-size: 0.9rem; transition: color 0.3s; } .footer-links a:hover { color: white; } .footer-divider { max-width: 1200px; margin: 2rem auto; height: 1px; background: rgba(255,255,255,0.1); } .footer-copyright { max-width: 1200px; margin: 0 auto; text-align: center; color: rgba(255,255,255,0.4); font-size: 0.85rem; }',
NULL,
'Minimal dark footer với clean design', 'minimal,dark,clean,elegant', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Glass Footer with Icons', 'footer', 'glass-footer-icons', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<footer class="footer-glass">
  <div class="footer-main">
    <div class="footer-brand">
      <h3>Brand Name</h3>
      <p>Creating amazing designs</p>
    </div>
    <div class="footer-nav">
      <div class="nav-section">
        <h4>Links</h4>
        <a href="#">Home</a>
        <a href="#">About</a>
        <a href="#">Services</a>
      </div>
      <div class="nav-section">
        <h4>Legal</h4>
        <a href="#">Privacy</a>
        <a href="#">Terms</a>
        <a href="#">Policy</a>
      </div>
    </div>
  </div>
  <div class="footer-social">
    <a href="#" class="social-icon">📘</a>
    <a href="#" class="social-icon">📷</a>
    <a href="#" class="social-icon">🐦</a>
    <a href="#" class="social-icon">💼</a>
  </div>
  <div class="footer-copy">© 2024 Brand Name</div>
</footer>',
'.footer-glass { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(20px); border-top: 1px solid rgba(255, 255, 255, 0.1); padding: 3rem 2rem 2rem; } .footer-main { max-width: 1200px; margin: 0 auto 2rem; display: grid; grid-template-columns: 1fr 2fr; gap: 4rem; } .footer-brand h3 { font-size: 1.5rem; font-weight: 700; color: #1a1a1a; margin-bottom: 0.5rem; } .footer-brand p { color: rgba(0,0,0,0.6); } .footer-nav { display: grid; grid-template-columns: repeat(2, 1fr); gap: 3rem; } .nav-section h4 { font-weight: 600; color: #1a1a1a; margin-bottom: 1rem; } .nav-section a { display: block; color: rgba(0,0,0,0.7); text-decoration: none; margin-bottom: 0.5rem; transition: color 0.3s; } .nav-section a:hover { color: #667eea; } .footer-social { max-width: 1200px; margin: 0 auto 1rem; display: flex; justify-content: center; gap: 1.5rem; } .social-icon { width: 45px; height: 45px; background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; text-decoration: none; transition: all 0.3s; } .social-icon:hover { background: rgba(102, 126, 234, 0.2); transform: translateY(-3px); } .footer-copy { max-width: 1200px; margin: 0 auto; text-align: center; color: rgba(0,0,0,0.5); font-size: 0.9rem; }',
NULL,
'Glass footer với social icons và modern layout', 'glass,icons,social,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== SIDEBARS ==========

('Modern Glass Sidebar', 'sidebar', 'glass-sidebar', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<aside class="sidebar-glass">
  <div class="sidebar-header">
    <div class="sidebar-logo">Dashboard</div>
  </div>
  <nav class="sidebar-nav">
    <a href="#" class="sidebar-item active">
      <span class="icon">🏠</span>
      <span>Home</span>
    </a>
    <a href="#" class="sidebar-item">
      <span class="icon">📊</span>
      <span>Analytics</span>
    </a>
    <a href="#" class="sidebar-item">
      <span class="icon">⚙️</span>
      <span>Settings</span>
    </a>
    <a href="#" class="sidebar-item">
      <span class="icon">👤</span>
      <span>Profile</span>
    </a>
  </nav>
</aside>',
'.sidebar-glass { width: 280px; background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(20px); border-right: 1px solid rgba(255, 255, 255, 0.2); min-height: 100vh; padding: 2rem 0; } .sidebar-header { padding: 0 2rem 2rem; border-bottom: 1px solid rgba(255, 255, 255, 0.1); margin-bottom: 2rem; } .sidebar-logo { font-size: 1.5rem; font-weight: 800; color: #1a1a1a; } .sidebar-nav { padding: 0 1rem; } .sidebar-item { display: flex; align-items: center; gap: 1rem; padding: 1rem 1.5rem; color: rgba(0,0,0,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 0.5rem; transition: all 0.3s; } .sidebar-item:hover { background: rgba(102, 126, 234, 0.1); color: #667eea; transform: translateX(5px); } .sidebar-item.active { background: linear-gradient(135deg, #667eea, #764ba2); color: white; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3); } .icon { font-size: 1.2rem; }',
NULL,
'Modern glass sidebar với gradient active state', 'glass,modern,gradient,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Minimalist Light Sidebar', 'sidebar', 'minimal-light', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<aside class="sidebar-minimal">
  <div class="sidebar-brand">
    <div class="brand-circle">A</div>
    <span class="brand-text">App</span>
  </div>
  <nav>
    <a href="#" class="nav-minimal active">Overview</a>
    <a href="#" class="nav-minimal">Projects</a>
    <a href="#" class="nav-minimal">Team</a>
    <a href="#" class="nav-minimal">Settings</a>
  </nav>
</aside>',
'.sidebar-minimal { width: 240px; background: #fafafa; border-right: 1px solid #e5e5e5; min-height: 100vh; padding: 2rem 1.5rem; } .sidebar-brand { display: flex; align-items: center; gap: 1rem; margin-bottom: 3rem; padding-bottom: 2rem; border-bottom: 1px solid #e5e5e5; } .brand-circle { width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 800; font-size: 1.2rem; } .brand-text { font-size: 1.25rem; font-weight: 700; color: #1a1a1a; } nav { display: flex; flex-direction: column; gap: 0.5rem; } .nav-minimal { padding: 0.75rem 1rem; color: #666; text-decoration: none; border-radius: 8px; font-weight: 500; transition: all 0.3s; } .nav-minimal:hover { background: #f0f0f0; color: #1a1a1a; } .nav-minimal.active { background: linear-gradient(135deg, #667eea, #764ba2); color: white; box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2); }',
NULL,
'Minimalist light sidebar với clean design', 'minimal,light,clean,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Animated Sidebar Menu', 'sidebar', 'animated-sidebar', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<aside class="sidebar-animated">
  <div class="sidebar-top">
    <h2>Menu</h2>
  </div>
  <nav>
    <a href="#" class="menu-item">
      <span class="menu-icon">💼</span>
      <span class="menu-text">Dashboard</span>
      <span class="menu-badge">12</span>
    </a>
    <a href="#" class="menu-item">
      <span class="menu-icon">📁</span>
      <span class="menu-text">Projects</span>
    </a>
    <a href="#" class="menu-item active">
      <span class="menu-icon">⭐</span>
      <span class="menu-text">Favorites</span>
    </a>
    <a href="#" class="menu-item">
      <span class="menu-icon">📊</span>
      <span class="menu-text">Reports</span>
    </a>
  </nav>
</aside>',
'.sidebar-animated { width: 260px; background: #1a1a1a; color: white; min-height: 100vh; padding: 2rem 0; } .sidebar-top { padding: 0 1.5rem 2rem; border-bottom: 1px solid rgba(255,255,255,0.1); margin-bottom: 1rem; } .sidebar-top h2 { font-size: 1.5rem; font-weight: 800; } nav { padding: 1rem 0; } .menu-item { display: flex; align-items: center; gap: 1rem; padding: 1rem 1.5rem; color: rgba(255,255,255,0.7); text-decoration: none; transition: all 0.3s; position: relative; } .menu-item::before { content: ""; position: absolute; left: 0; top: 0; bottom: 0; width: 4px; background: #667eea; transform: scaleY(0); transition: transform 0.3s; } .menu-item:hover { background: rgba(255,255,255,0.05); color: white; } .menu-item:hover::before { transform: scaleY(1); } .menu-item.active { background: rgba(102, 126, 234, 0.2); color: white; } .menu-item.active::before { transform: scaleY(1); } .menu-icon { font-size: 1.3rem; } .menu-text { flex: 1; font-weight: 500; } .menu-badge { background: #667eea; color: white; padding: 0.25rem 0.75rem; border-radius: 12px; font-size: 0.75rem; font-weight: 600; }',
NULL,
'Animated sidebar với badges và smooth transitions', 'animated,badges,modern,dark', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== LAYOUTS ==========

('Hero Section with Gradient', 'layout', 'hero-gradient', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<section class="hero-gradient">
  <div class="hero-content">
    <h1 class="hero-title">Build Amazing Products</h1>
    <p class="hero-subtitle">Create stunning experiences with our design system</p>
    <div class="hero-buttons">
      <button class="btn-primary-hero">Get Started</button>
      <button class="btn-secondary-hero">Learn More</button>
    </div>
  </div>
  <div class="hero-shapes">
    <div class="shape shape-1"></div>
    <div class="shape shape-2"></div>
    <div class="shape shape-3"></div>
  </div>
</section>',
'.hero-gradient { position: relative; min-height: 600px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; overflow: hidden; } .hero-content { text-align: center; z-index: 2; padding: 4rem 2rem; } .hero-title { font-size: 4rem; font-weight: 900; color: white; margin-bottom: 1.5rem; text-shadow: 0 10px 40px rgba(0,0,0,0.2); } .hero-subtitle { font-size: 1.5rem; color: rgba(255,255,255,0.9); margin-bottom: 3rem; } .hero-buttons { display: flex; gap: 1.5rem; justify-content: center; } .btn-primary-hero { background: white; color: #667eea; padding: 1rem 2.5rem; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: transform 0.3s, box-shadow 0.3s; } .btn-primary-hero:hover { transform: translateY(-3px); box-shadow: 0 10px 30px rgba(0,0,0,0.3); } .btn-secondary-hero { background: transparent; color: white; padding: 1rem 2.5rem; border: 2px solid white; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.3s; } .btn-secondary-hero:hover { background: white; color: #667eea; } .hero-shapes { position: absolute; inset: 0; z-index: 1; } .shape { position: absolute; border-radius: 50%; background: rgba(255,255,255,0.1); } .shape-1 { width: 300px; height: 300px; top: -100px; right: -100px; } .shape-2 { width: 200px; height: 200px; bottom: -50px; left: -50px; } .shape-3 { width: 150px; height: 150px; top: 50%; right: 10%; }',
NULL,
'Modern hero section với gradient và animated shapes', 'hero,gradient,animated,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Card Grid Layout', 'layout', 'card-grid-modern', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<section class="card-grid-section">
  <div class="cards-container">
    <div class="card-modern">
      <div class="card-icon">🚀</div>
      <h3>Fast</h3>
      <p>Lightning fast performance</p>
    </div>
    <div class="card-modern">
      <div class="card-icon">🎨</div>
      <h3>Beautiful</h3>
      <p>Stunning design system</p>
    </div>
    <div class="card-modern">
      <div class="card-icon">🔒</div>
      <h3>Secure</h3>
      <p>Enterprise-grade security</p>
    </div>
  </div>
</section>',
'.card-grid-section { padding: 4rem 2rem; background: #fafafa; } .cards-container { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem; } .card-modern { background: white; padding: 3rem 2rem; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.08); transition: all 0.3s; text-align: center; } .card-modern:hover { transform: translateY(-10px); box-shadow: 0 20px 60px rgba(0,0,0,0.15); } .card-icon { font-size: 3rem; margin-bottom: 1.5rem; } .card-modern h3 { font-size: 1.5rem; font-weight: 700; color: #1a1a1a; margin-bottom: 1rem; } .card-modern p { color: #666; line-height: 1.6; }',
NULL,
'Modern card grid layout với hover effects', 'cards,grid,modern,hover', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Split Layout', 'layout', 'split-layout', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<section class="split-section">
  <div class="split-content">
    <div class="split-left">
      <h2>Modern Design System</h2>
      <p>Build beautiful interfaces with our comprehensive design system. Every component is crafted with attention to detail.</p>
      <button class="split-btn">Explore</button>
    </div>
    <div class="split-right">
      <div class="split-image">
        <div class="gradient-box"></div>
      </div>
    </div>
  </div>
</section>',
'.split-section { padding: 6rem 2rem; background: white; } .split-content { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 1fr 1fr; gap: 4rem; align-items: center; } .split-left h2 { font-size: 3rem; font-weight: 800; color: #1a1a1a; margin-bottom: 1.5rem; line-height: 1.2; } .split-left p { font-size: 1.2rem; color: #666; line-height: 1.8; margin-bottom: 2rem; } .split-btn { background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 1rem 2.5rem; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: transform 0.3s; } .split-btn:hover { transform: translateY(-3px); } .split-right { position: relative; } .split-image { position: relative; height: 400px; border-radius: 20px; overflow: hidden; } .gradient-box { width: 100%; height: 100%; background: linear-gradient(135deg, #667eea, #764ba2); }',
NULL,
'Modern split layout với gradient và clean design', 'split,layout,modern,gradient', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Feature Grid Layout', 'layout', 'feature-grid', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<section class="features-grid">
  <div class="features-header">
    <h2>Why Choose Us</h2>
    <p>Everything you need to build amazing products</p>
  </div>
  <div class="features">
    <div class="feature-item">
      <div class="feature-number">01</div>
      <h3>Design First</h3>
      <p>Beautiful, intuitive interfaces</p>
    </div>
    <div class="feature-item">
      <div class="feature-number">02</div>
      <h3>Developer Friendly</h3>
      <p>Easy to implement and customize</p>
    </div>
    <div class="feature-item">
      <div class="feature-number">03</div>
      <h3>Performance</h3>
      <p>Optimized for speed and efficiency</p>
    </div>
    <div class="feature-item">
      <div class="feature-number">04</div>
      <h3>Support</h3>
      <p>24/7 customer support</p>
    </div>
  </div>
</section>',
'.features-grid { padding: 6rem 2rem; background: linear-gradient(to bottom, #fafafa, white); } .features-header { text-align: center; max-width: 600px; margin: 0 auto 4rem; } .features-header h2 { font-size: 3rem; font-weight: 800; color: #1a1a1a; margin-bottom: 1rem; } .features-header p { font-size: 1.2rem; color: #666; } .features { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 3rem; } .feature-item { text-align: center; } .feature-number { font-size: 4rem; font-weight: 900; background: linear-gradient(135deg, #667eea, #764ba2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 1rem; } .feature-item h3 { font-size: 1.5rem; font-weight: 700; color: #1a1a1a; margin-bottom: 0.5rem; } .feature-item p { color: #666; }',
NULL,
'Feature grid layout với numbered items và gradient', 'features,grid,numbers,gradient', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== TYPOGRAPHY ==========

('Animated Gradient Text', 'typography', 'gradient-animated', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="typography-gradient">
  <h1 class="gradient-animated">Animated Gradient</h1>
  <h2 class="gradient-static">Static Gradient</h2>
  <p class="gradient-text">Beautiful typography effects</p>
</div>',
'.typography-gradient { padding: 4rem; background: #fafafa; text-align: center; } .gradient-animated { font-size: 4rem; font-weight: 900; background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #667eea); background-size: 200% auto; -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; animation: gradient-shift 3s linear infinite; } @keyframes gradient-shift { 0% { background-position: 0% center; } 100% { background-position: 200% center; } } .gradient-static { font-size: 3rem; font-weight: 800; background: linear-gradient(135deg, #667eea, #764ba2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin: 2rem 0; } .gradient-text { font-size: 1.5rem; background: linear-gradient(135deg, #667eea, #764ba2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }',
NULL,
'Animated gradient text với smooth color transitions', 'gradient,animated,typography,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Glass Typography', 'typography', 'glass-typography', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="typography-glass">
  <h1 class="glass-title">Glass Effect</h1>
  <h2 class="glass-subtitle">Beautiful Text Styles</h2>
  <p class="glass-text">Modern typography with glassmorphism</p>
</div>',
'.typography-glass { padding: 4rem; background: linear-gradient(135deg, #667eea, #764ba2); text-align: center; } .glass-title { font-size: 5rem; font-weight: 900; color: rgba(255,255,255,0.9); text-shadow: 0 0 30px rgba(255,255,255,0.5), 0 0 60px rgba(255,255,255,0.3); backdrop-filter: blur(10px); margin-bottom: 2rem; } .glass-subtitle { font-size: 2.5rem; font-weight: 700; color: rgba(255,255,255,0.8); text-shadow: 0 0 20px rgba(255,255,255,0.4); margin-bottom: 1.5rem; } .glass-text { font-size: 1.5rem; color: rgba(255,255,255,0.7); text-shadow: 0 0 15px rgba(255,255,255,0.3); }',
NULL,
'Glass typography với glow effects và shadows', 'glass,typography,glow,effects', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('3D Text Effect', 'typography', '3d-text', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="typography-3d">
  <h1 class="text-3d">3D TEXT</h1>
  <h2 class="text-3d-small">Depth Effect</h2>
</div>',
'.typography-3d { padding: 4rem; background: #1a1a1a; text-align: center; } .text-3d { font-size: 5rem; font-weight: 900; color: #667eea; text-shadow: 0 1px 0 #764ba2, 0 2px 0 #764ba2, 0 3px 0 #764ba2, 0 4px 0 #764ba2, 0 5px 0 #764ba2, 0 6px 10px rgba(0,0,0,0.5); transform: perspective(500px) rotateX(20deg); margin-bottom: 2rem; } .text-3d-small { font-size: 2.5rem; font-weight: 800; color: #764ba2; text-shadow: 0 1px 0 #667eea, 0 2px 0 #667eea, 0 3px 0 #667eea, 0 4px 10px rgba(0,0,0,0.5); }',
NULL,
'3D text effect với depth và perspective', '3d,typography,depth,effect', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Neon Text Effect', 'typography', 'neon-text', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="typography-neon">
  <h1 class="neon-text">NEON</h1>
  <h2 class="neon-subtitle">Glowing Effect</h2>
</div>',
'.typography-neon { padding: 4rem; background: #0a0a0a; text-align: center; } .neon-text { font-size: 5rem; font-weight: 900; color: #fff; text-shadow: 0 0 10px #667eea, 0 0 20px #667eea, 0 0 30px #667eea, 0 0 40px #667eea, 0 0 70px #667eea; animation: neon-flicker 2s infinite alternate; margin-bottom: 2rem; } .neon-subtitle { font-size: 2.5rem; font-weight: 700; color: #fff; text-shadow: 0 0 10px #764ba2, 0 0 20px #764ba2, 0 0 30px #764ba2; } @keyframes neon-flicker { 0%, 100% { opacity: 1; } 50% { opacity: 0.8; } }',
NULL,
'Neon text với glowing effects và animation', 'neon,typography,glow,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Outline Text Style', 'typography', 'outline-text', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="typography-outline">
  <h1 class="outline-title">OUTLINE</h1>
  <h2 class="outline-gradient">Gradient Outline</h2>
</div>',
'.typography-outline { padding: 4rem; background: white; text-align: center; } .outline-title { font-size: 5rem; font-weight: 900; -webkit-text-stroke: 3px #667eea; color: transparent; margin-bottom: 2rem; } .outline-gradient { font-size: 3rem; font-weight: 800; -webkit-text-stroke: 2px transparent; background: linear-gradient(135deg, #667eea, #764ba2); -webkit-background-clip: text; background-clip: text; color: transparent; }',
NULL,
'Outline text với gradient và stroke effects', 'outline,typography,stroke,gradient', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

SELECT COUNT(*) as "TotalComponentsAfterInsert" FROM "DesignComponents";

