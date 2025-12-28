-- Insert Layout Components (Headers, Footers, Navigation, etc.)
-- Run this after render-design-components-setup.sql

-- =====================================================
-- HEADER LAYOUTS
-- =====================================================

-- Header 1: Minimal Header with Logo and Navigation
INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt")
VALUES (
    'Minimal Header',
    'header',
    'minimal-header',
    'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
    '<header class="header-minimal">
  <div class="container">
    <nav class="navbar">
      <div class="logo">
        <a href="#home">Brand</a>
      </div>
      <ul class="nav-menu">
        <li><a href="#home">Home</a></li>
        <li><a href="#about">About</a></li>
        <li><a href="#services">Services</a></li>
        <li><a href="#contact">Contact</a></li>
      </ul>
      <button class="cta-button">Get Started</button>
    </nav>
  </div>
</header>',
    '.header-minimal {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  padding: 1rem 0;
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 1000;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo a {
  font-size: 1.5rem;
  font-weight: bold;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-decoration: none;
}

.nav-menu {
  display: flex;
  list-style: none;
  gap: 2rem;
  margin: 0;
  padding: 0;
}

.nav-menu a {
  color: #333;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s;
}

.nav-menu a:hover {
  color: #667eea;
}

.cta-button {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.cta-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}',
    'document.addEventListener("DOMContentLoaded", function() {
  const navLinks = document.querySelectorAll(".nav-menu a");
  navLinks.forEach(link => {
    link.addEventListener("click", function(e) {
      e.preventDefault();
      console.log("Navigation clicked:", this.textContent);
    });
  });
  
  document.querySelector(".cta-button").addEventListener("click", function() {
    alert("Get Started clicked!");
  });
});',
    'Clean and simple header with logo and navigation menu. Perfect for modern websites.',
    'header, navigation, minimal, logo',
    'html',
    0,
    0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT DO NOTHING;

-- Header 2: Glassmorphism Header
INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt")
VALUES (
    'Glassmorphism Header',
    'header',
    'glassmorphism-header',
    'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
    '<header class="header-glass">
  <div class="glass-nav">
    <div class="logo-section">
      <div class="logo-icon">⚡</div>
      <span class="logo-text">GlassUI</span>
    </div>
    <nav class="nav-links">
      <a href="#" class="nav-link active">Home</a>
      <a href="#" class="nav-link">Features</a>
      <a href="#" class="nav-link">Pricing</a>
      <a href="#" class="nav-link">Contact</a>
    </nav>
    <div class="action-buttons">
      <button class="btn-secondary">Sign In</button>
      <button class="btn-primary">Sign Up</button>
    </div>
  </div>
</header>',
    '.header-glass {
  position: fixed;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  width: 90%;
  max-width: 1200px;
  z-index: 1000;
}

.glass-nav {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 20px;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.logo-icon {
  font-size: 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.logo-text {
  font-size: 1.25rem;
  font-weight: 700;
  color: #fff;
}

.nav-links {
  display: flex;
  gap: 2rem;
}

.nav-link {
  color: rgba(255, 255, 255, 0.9);
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 10px;
  transition: all 0.3s;
  position: relative;
}

.nav-link:hover,
.nav-link.active {
  background: rgba(255, 255, 255, 0.15);
  color: #fff;
}

.action-buttons {
  display: flex;
  gap: 1rem;
}

.btn-secondary,
.btn-primary {
  padding: 0.75rem 1.5rem;
  border-radius: 12px;
  font-weight: 600;
  border: none;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.1);
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.2);
}

.btn-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
}

body {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  margin: 0;
  padding-top: 100px;
}',
    'document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".nav-link").forEach(link => {
    link.addEventListener("click", function(e) {
      e.preventDefault();
      document.querySelectorAll(".nav-link").forEach(l => l.classList.remove("active"));
      this.classList.add("active");
    });
  });
});',
    'Modern glassmorphism effect header with blur background and gradient accent.',
    'header, glassmorphism, glass, modern, navigation',
    'html',
    0,
    0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT DO NOTHING;

-- Header 3: Sticky Sidebar Header
INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt")
VALUES (
    'Sidebar Navigation Header',
    'header',
    'sidebar-navigation',
    'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
    '<header class="sidebar-header">
  <div class="sidebar">
    <div class="sidebar-logo">
      <div class="logo-circle">D</div>
      <span>Dashboard</span>
    </div>
    <nav class="sidebar-nav">
      <a href="#" class="nav-item active">
        <span class="nav-icon">🏠</span>
        <span class="nav-label">Home</span>
      </a>
      <a href="#" class="nav-item">
        <span class="nav-icon">📊</span>
        <span class="nav-label">Analytics</span>
      </a>
      <a href="#" class="nav-item">
        <span class="nav-icon">📁</span>
        <span class="nav-label">Projects</span>
      </a>
      <a href="#" class="nav-item">
        <span class="nav-icon">⚙️</span>
        <span class="nav-label">Settings</span>
      </a>
      <a href="#" class="nav-item">
        <span class="nav-icon">👤</span>
        <span class="nav-label">Profile</span>
      </a>
    </nav>
    <div class="sidebar-footer">
      <button class="logout-btn">
        <span class="nav-icon">🚪</span>
        <span class="nav-label">Logout</span>
      </button>
    </div>
  </div>
</header>',
    '.sidebar-header {
  position: fixed;
  left: 0;
  top: 0;
  height: 100vh;
  z-index: 1000;
}

.sidebar {
  width: 260px;
  height: 100%;
  background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
  padding: 2rem 1.5rem;
  display: flex;
  flex-direction: column;
  box-shadow: 2px 0 20px rgba(0, 0, 0, 0.1);
}

.sidebar-logo {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 3rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.logo-circle {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: bold;
  font-size: 1.25rem;
}

.sidebar-logo span {
  color: white;
  font-size: 1.25rem;
  font-weight: 700;
}

.sidebar-nav {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem 1rem;
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  border-radius: 12px;
  transition: all 0.3s;
  cursor: pointer;
}

.nav-item:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  transform: translateX(5px);
}

.nav-item.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

.nav-icon {
  font-size: 1.25rem;
  width: 24px;
  text-align: center;
}

.nav-label {
  font-weight: 500;
}

.sidebar-footer {
  padding-top: 1.5rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.logout-btn {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem 1rem;
  background: rgba(239, 68, 68, 0.1);
  color: #ef4444;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s;
  font-weight: 500;
}

.logout-btn:hover {
  background: rgba(239, 68, 68, 0.2);
  transform: translateX(5px);
}

body {
  margin: 0;
  background: #f8fafc;
  padding-left: 260px;
  min-height: 100vh;
}',
    'document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".nav-item").forEach(item => {
    item.addEventListener("click", function(e) {
      e.preventDefault();
      document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
      this.classList.add("active");
    });
  });
  
  document.querySelector(".logout-btn").addEventListener("click", function() {
    if (confirm("Are you sure you want to logout?")) {
      console.log("Logout clicked");
    }
  });
});',
    'Elegant sidebar navigation with icon-based menu items and smooth animations.',
    'header, sidebar, navigation, dashboard, menu',
    'html',
    0,
    0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT DO NOTHING;

-- =====================================================
-- FOOTER LAYOUTS
-- =====================================================

-- Footer 1: Modern Footer with Links
INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt")
VALUES (
    'Modern Footer',
    'footer',
    'modern-footer',
    'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
    '<footer class="footer-modern">
  <div class="footer-container">
    <div class="footer-content">
      <div class="footer-section">
        <h3 class="footer-logo">Brand</h3>
        <p class="footer-description">Building beautiful UI components for modern web applications.</p>
        <div class="social-links">
          <a href="#" class="social-link">📘</a>
          <a href="#" class="social-link">🐦</a>
          <a href="#" class="social-link">📷</a>
          <a href="#" class="social-link">💼</a>
        </div>
      </div>
      <div class="footer-section">
        <h4 class="footer-title">Product</h4>
        <ul class="footer-links">
          <li><a href="#">Features</a></li>
          <li><a href="#">Pricing</a></li>
          <li><a href="#">Documentation</a></li>
          <li><a href="#">Changelog</a></li>
        </ul>
      </div>
      <div class="footer-section">
        <h4 class="footer-title">Company</h4>
        <ul class="footer-links">
          <li><a href="#">About</a></li>
          <li><a href="#">Blog</a></li>
          <li><a href="#">Careers</a></li>
          <li><a href="#">Contact</a></li>
        </ul>
      </div>
      <div class="footer-section">
        <h4 class="footer-title">Newsletter</h4>
        <p class="newsletter-text">Subscribe to our newsletter for updates.</p>
        <div class="newsletter-form">
          <input type="email" placeholder="Enter your email" class="newsletter-input">
          <button class="newsletter-button">Subscribe</button>
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <p>&copy; 2024 Brand. All rights reserved.</p>
      <div class="footer-legal">
        <a href="#">Privacy Policy</a>
        <a href="#">Terms of Service</a>
      </div>
    </div>
  </div>
</footer>',
    '.footer-modern {
  background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
  color: #fff;
  padding: 4rem 2rem 2rem;
  margin-top: 4rem;
}

.footer-container {
  max-width: 1200px;
  margin: 0 auto;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 3rem;
  margin-bottom: 3rem;
}

.footer-section {
  display: flex;
  flex-direction: column;
}

.footer-logo {
  font-size: 1.5rem;
  font-weight: bold;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 1rem;
}

.footer-description {
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

.social-links {
  display: flex;
  gap: 1rem;
}

.social-link {
  width: 40px;
  height: 40px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  text-decoration: none;
  font-size: 1.25rem;
  transition: all 0.3s;
}

.social-link:hover {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  transform: translateY(-3px);
}

.footer-title {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #fff;
}

.footer-links {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.footer-links a {
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  transition: color 0.3s;
}

.footer-links a:hover {
  color: #667eea;
}

.newsletter-text {
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 1rem;
}

.newsletter-form {
  display: flex;
  gap: 0.5rem;
}

.newsletter-input {
  flex: 1;
  padding: 0.75rem 1rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.1);
  color: #fff;
  outline: none;
}

.newsletter-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.newsletter-button {
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.2s;
}

.newsletter-button:hover {
  transform: translateY(-2px);
}

.footer-bottom {
  padding-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.footer-bottom p {
  color: rgba(255, 255, 255, 0.7);
  margin: 0;
}

.footer-legal {
  display: flex;
  gap: 2rem;
}

.footer-legal a {
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  transition: color 0.3s;
}

.footer-legal a:hover {
  color: #667eea;
}',
    'document.addEventListener("DOMContentLoaded", function() {
  document.querySelector(".newsletter-button").addEventListener("click", function() {
    const input = document.querySelector(".newsletter-input");
    const email = input.value;
    if (email) {
      alert("Thank you for subscribing with: " + email);
      input.value = "";
    } else {
      alert("Please enter a valid email address");
    }
  });
  
  document.querySelectorAll(".social-link").forEach(link => {
    link.addEventListener("click", function(e) {
      e.preventDefault();
      console.log("Social link clicked");
    });
  });
});',
    'Clean and comprehensive footer with multiple sections, social links, and newsletter signup.',
    'footer, links, newsletter, social, modern',
    'html',
    0,
    0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT DO NOTHING;

-- Footer 2: Minimal Footer
INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt")
VALUES (
    'Minimal Footer',
    'footer',
    'minimal-footer',
    'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
    '<footer class="footer-minimal">
  <div class="footer-wrapper">
    <div class="footer-links">
      <a href="#">Privacy</a>
      <a href="#">Terms</a>
      <a href="#">Cookie Policy</a>
      <a href="#">Contact</a>
    </div>
    <p class="footer-copyright">© 2024 Your Company. All rights reserved.</p>
  </div>
</footer>',
    '.footer-minimal {
  background: #f8fafc;
  border-top: 1px solid #e2e8f0;
  padding: 2rem 0;
  margin-top: 4rem;
}

.footer-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.footer-links {
  display: flex;
  gap: 2rem;
  flex-wrap: wrap;
}

.footer-links a {
  color: #64748b;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s;
}

.footer-links a:hover {
  color: #667eea;
}

.footer-copyright {
  color: #94a3b8;
  margin: 0;
  font-size: 0.9rem;
}',
    'Simple and elegant footer design perfect for landing pages.',
    'footer, minimal, simple, clean',
    'html',
    0,
    0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT DO NOTHING;

-- =====================================================
-- NAVIGATION LAYOUTS
-- =====================================================

-- Navigation 1: Breadcrumb Navigation
INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt")
VALUES (
    'Breadcrumb Navigation',
    'navigation',
    'breadcrumb-navigation',
    'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
    '<nav class="breadcrumb-nav">
  <ol class="breadcrumb-list">
    <li class="breadcrumb-item">
      <a href="#" class="breadcrumb-link">
        <span class="breadcrumb-icon">🏠</span>
        <span>Home</span>
      </a>
    </li>
    <li class="breadcrumb-separator">›</li>
    <li class="breadcrumb-item">
      <a href="#" class="breadcrumb-link">Products</a>
    </li>
    <li class="breadcrumb-separator">›</li>
    <li class="breadcrumb-item active">
      <span>Current Page</span>
    </li>
  </ol>
</nav>',
    '.breadcrumb-nav {
  padding: 1.5rem 0;
  background: #fff;
}

.breadcrumb-list {
  display: flex;
  align-items: center;
  list-style: none;
  padding: 0;
  margin: 0;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.breadcrumb-item {
  display: flex;
  align-items: center;
}

.breadcrumb-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #64748b;
  text-decoration: none;
  padding: 0.5rem 0.75rem;
  border-radius: 8px;
  transition: all 0.3s;
  font-weight: 500;
}

.breadcrumb-link:hover {
  background: #f1f5f9;
  color: #667eea;
}

.breadcrumb-icon {
  font-size: 1rem;
}

.breadcrumb-separator {
  color: #cbd5e1;
  font-size: 1.25rem;
  padding: 0 0.5rem;
}

.breadcrumb-item.active span {
  color: #1e293b;
  font-weight: 600;
  padding: 0.5rem 0.75rem;
}',
    'Elegant breadcrumb navigation component with icons and separators.',
    'navigation, breadcrumb, menu, links',
    'html',
    0,
    0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT DO NOTHING;

-- Navigation 2: Tab Navigation
INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt")
VALUES (
    'Tab Navigation',
    'navigation',
    'tab-navigation',
    'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
    '<nav class="tab-navigation">
  <div class="tab-list">
    <button class="tab-item active" data-tab="overview">Overview</button>
    <button class="tab-item" data-tab="features">Features</button>
    <button class="tab-item" data-tab="pricing">Pricing</button>
    <button class="tab-item" data-tab="reviews">Reviews</button>
    <div class="tab-indicator"></div>
  </div>
</nav>
<div class="tab-content">
  <div class="tab-panel active" data-panel="overview">Overview content goes here...</div>
  <div class="tab-panel" data-panel="features">Features content goes here...</div>
  <div class="tab-panel" data-panel="pricing">Pricing content goes here...</div>
  <div class="tab-panel" data-panel="reviews">Reviews content goes here...</div>
</div>',
    '.tab-navigation {
  background: #fff;
  border-bottom: 2px solid #e2e8f0;
  padding: 0 2rem;
}

.tab-list {
  display: flex;
  position: relative;
  gap: 1rem;
}

.tab-item {
  padding: 1rem 1.5rem;
  background: none;
  border: none;
  color: #64748b;
  font-weight: 600;
  cursor: pointer;
  position: relative;
  transition: color 0.3s;
  font-size: 1rem;
}

.tab-item:hover {
  color: #667eea;
}

.tab-item.active {
  color: #667eea;
}

.tab-indicator {
  position: absolute;
  bottom: -2px;
  left: 0;
  height: 2px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  transition: all 0.3s ease;
  border-radius: 2px 2px 0 0;
}

.tab-content {
  padding: 2rem;
  background: #f8fafc;
  min-height: 200px;
}

.tab-panel {
  display: none;
  animation: fadeIn 0.3s;
}

.tab-panel.active {
  display: block;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}',
    'document.addEventListener("DOMContentLoaded", function() {
  const tabs = document.querySelectorAll(".tab-item");
  const panels = document.querySelectorAll(".tab-panel");
  const indicator = document.querySelector(".tab-indicator");
  
  function updateIndicator(activeTab) {
    const tabRect = activeTab.getBoundingClientRect();
    const listRect = document.querySelector(".tab-list").getBoundingClientRect();
    indicator.style.width = tabRect.width + "px";
    indicator.style.left = (tabRect.left - listRect.left) + "px";
  }
  
  // Initialize indicator
  const activeTab = document.querySelector(".tab-item.active");
  if (activeTab) {
    updateIndicator(activeTab);
  }
  
  tabs.forEach(tab => {
    tab.addEventListener("click", function() {
      const tabName = this.dataset.tab;
      
      // Update tabs
      tabs.forEach(t => t.classList.remove("active"));
      this.classList.add("active");
      
      // Update panels
      panels.forEach(p => {
        p.classList.remove("active");
        if (p.dataset.panel === tabName) {
          p.classList.add("active");
        }
      });
      
      // Update indicator
      updateIndicator(this);
    });
  });
  
  // Update on resize
  window.addEventListener("resize", function() {
    const activeTab = document.querySelector(".tab-item.active");
    if (activeTab) {
      updateIndicator(activeTab);
    }
  });
});',
    'Modern tab navigation with smooth transitions and active states.',
    'navigation, tabs, menu, ui, interactive',
    'html',
    0,
    0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT DO NOTHING;

-- =====================================================
-- SIDEBAR LAYOUTS
-- =====================================================

-- Sidebar 1: Filter Sidebar
INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt")
VALUES (
    'Filter Sidebar',
    'sidebar',
    'filter-sidebar',
    'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
    '<aside class="filter-sidebar">
  <div class="sidebar-header">
    <h3>Filters</h3>
    <button class="clear-all">Clear All</button>
  </div>
  
  <div class="filter-section">
    <button class="filter-toggle">
      <span>Category</span>
      <span class="toggle-icon">▼</span>
    </button>
    <div class="filter-content open">
      <label class="filter-checkbox">
        <input type="checkbox" checked>
        <span>Header</span>
      </label>
      <label class="filter-checkbox">
        <input type="checkbox">
        <span>Footer</span>
      </label>
      <label class="filter-checkbox">
        <input type="checkbox">
        <span>Navigation</span>
      </label>
      <label class="filter-checkbox">
        <input type="checkbox">
        <span>Buttons</span>
      </label>
    </div>
  </div>
  
  <div class="filter-section">
    <button class="filter-toggle">
      <span>Price</span>
      <span class="toggle-icon">▼</span>
    </button>
    <div class="filter-content open">
      <label class="filter-radio">
        <input type="radio" name="price" value="free">
        <span>Free</span>
      </label>
      <label class="filter-radio">
        <input type="radio" name="price" value="premium" checked>
        <span>Premium</span>
      </label>
      <label class="filter-radio">
        <input type="radio" name="price" value="all">
        <span>All</span>
      </label>
    </div>
  </div>
  
  <div class="filter-section">
    <button class="filter-toggle">
      <span>Rating</span>
      <span class="toggle-icon">▼</span>
    </button>
    <div class="filter-content open">
      <div class="rating-filter">
        <button class="star-button" data-rating="5">★★★★★</button>
        <button class="star-button" data-rating="4">★★★★☆</button>
        <button class="star-button" data-rating="3">★★★☆☆</button>
      </div>
    </div>
  </div>
</aside>',
    '.filter-sidebar {
  width: 280px;
  background: #fff;
  border-right: 1px solid #e2e8f0;
  padding: 2rem;
  height: 100vh;
  overflow-y: auto;
  position: sticky;
  top: 0;
}

.sidebar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid #e2e8f0;
}

.sidebar-header h3 {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0;
}

.clear-all {
  background: none;
  border: none;
  color: #667eea;
  font-weight: 600;
  cursor: pointer;
  font-size: 0.875rem;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  transition: background 0.2s;
}

.clear-all:hover {
  background: #f1f5f9;
}

.filter-section {
  margin-bottom: 1.5rem;
}

.filter-toggle {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 0;
  background: none;
  border: none;
  font-weight: 600;
  color: #1e293b;
  cursor: pointer;
  font-size: 1rem;
}

.toggle-icon {
  transition: transform 0.3s;
  font-size: 0.75rem;
}

.filter-section:has(.filter-content:not(.open)) .toggle-icon {
  transform: rotate(-90deg);
}

.filter-content {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease;
}

.filter-content.open {
  max-height: 500px;
  padding-top: 0.5rem;
}

.filter-checkbox,
.filter-radio {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem 0;
  cursor: pointer;
  color: #475569;
}

.filter-checkbox input[type="checkbox"],
.filter-radio input[type="radio"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
  accent-color: #667eea;
}

.rating-filter {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.star-button {
  background: none;
  border: 1px solid #e2e8f0;
  padding: 0.5rem 0.75rem;
  border-radius: 8px;
  cursor: pointer;
  color: #64748b;
  font-size: 1rem;
  text-align: left;
  transition: all 0.2s;
}

.star-button:hover {
  border-color: #667eea;
  color: #667eea;
  background: #f8fafc;
}',
    'document.addEventListener("DOMContentLoaded", function() {
  // Toggle filter sections
  document.querySelectorAll(".filter-toggle").forEach(toggle => {
    toggle.addEventListener("click", function() {
      const content = this.nextElementSibling;
      content.classList.toggle("open");
    });
  });
  
  // Clear all filters
  document.querySelector(".clear-all").addEventListener("click", function() {
    document.querySelectorAll("input[type=\"checkbox\"]").forEach(cb => cb.checked = false);
    document.querySelectorAll("input[type=\"radio\"]").forEach(rb => rb.checked = false);
  });
  
  // Star rating filter
  document.querySelectorAll(".star-button").forEach(button => {
    button.addEventListener("click", function() {
      document.querySelectorAll(".star-button").forEach(b => {
        b.style.borderColor = "#e2e8f0";
        b.style.color = "#64748b";
      });
      this.style.borderColor = "#667eea";
      this.style.color = "#667eea";
      console.log("Filter by rating:", this.dataset.rating);
    });
  });
});',
    'Clean sidebar component for filtering and navigation with collapsible sections.',
    'sidebar, filter, navigation, ui, component',
    'html',
    0,
    0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT DO NOTHING;

-- Note: This script adds various layout components including:
-- 3 Header layouts (Minimal, Glassmorphism, Sidebar)
-- 2 Footer layouts (Modern, Minimal)
-- 2 Navigation layouts (Breadcrumb, Tabs)
-- 1 Sidebar layout (Filter Sidebar)
-- Total: 8 new layout components

