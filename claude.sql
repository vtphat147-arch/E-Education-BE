-- MEGA COLLECTION - Design Components Library
-- Chạy file này sau khi đã chạy render-design-components-setup.sql

INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt") VALUES

-- ========== BUTTONS (20+ styles) ==========

('Gradient Glow Button', 'button', 'gradient-glow', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<button class="btn-gradient-glow">Get Started</button>',
'.btn-gradient-glow { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem 3rem; border: none; border-radius: 50px; font-size: 1.1rem; font-weight: 700; cursor: pointer; position: relative; overflow: hidden; transition: all 0.3s; box-shadow: 0 0 20px rgba(102, 126, 234, 0.4); } .btn-gradient-glow:hover { transform: translateY(-3px); box-shadow: 0 0 40px rgba(102, 126, 234, 0.6), 0 10px 30px rgba(0,0,0,0.3); } .btn-gradient-glow::before { content: ""; position: absolute; top: -50%; left: -50%; width: 200%; height: 200%; background: rgba(255,255,255,0.1); transform: rotate(45deg); transition: all 0.5s; } .btn-gradient-glow:hover::before { left: 100%; }',
NULL,
'Button gradient với glow effect và shine animation', 'button,gradient,glow,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Neon Pulse Button', 'button', 'neon-pulse', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<button class="btn-neon-pulse">Click Me</button>',
'.btn-neon-pulse { background: transparent; color: #667eea; padding: 1rem 2.5rem; border: 2px solid #667eea; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; position: relative; transition: all 0.3s; text-shadow: 0 0 10px rgba(102, 126, 234, 0.5); box-shadow: 0 0 20px rgba(102, 126, 234, 0.3), inset 0 0 20px rgba(102, 126, 234, 0.1); animation: neon-pulse 2s infinite; } @keyframes neon-pulse { 0%, 100% { box-shadow: 0 0 20px rgba(102, 126, 234, 0.3), inset 0 0 20px rgba(102, 126, 234, 0.1); } 50% { box-shadow: 0 0 40px rgba(102, 126, 234, 0.6), inset 0 0 30px rgba(102, 126, 234, 0.2); } } .btn-neon-pulse:hover { background: #667eea; color: white; transform: scale(1.05); }',
NULL,
'Neon button với pulse animation effect', 'button,neon,pulse,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Glass Morphism Button', 'button', 'glass-morph', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<button class="btn-glass">Continue</button>',
'.btn-glass { background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(20px); color: #1a1a1a; padding: 1rem 2.5rem; border: 1px solid rgba(255, 255, 255, 0.3); border-radius: 15px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.3s; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); } .btn-glass:hover { background: rgba(255, 255, 255, 0.2); transform: translateY(-2px); box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15); }',
NULL,
'Glass morphism button với backdrop blur', 'button,glass,morphism,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('3D Raised Button', 'button', '3d-raised', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<button class="btn-3d-raised">Press Me</button>',
'.btn-3d-raised { background: linear-gradient(to bottom, #667eea, #5568d3); color: white; padding: 1.2rem 3rem; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; position: relative; box-shadow: 0 6px 0 #4451a8, 0 8px 20px rgba(0,0,0,0.3); transition: all 0.1s; } .btn-3d-raised:hover { transform: translateY(2px); box-shadow: 0 4px 0 #4451a8, 0 6px 15px rgba(0,0,0,0.3); } .btn-3d-raised:active { transform: translateY(6px); box-shadow: 0 0 0 #4451a8, 0 2px 10px rgba(0,0,0,0.3); }',
NULL,
'3D raised button với depth effect', 'button,3d,raised,interactive', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Liquid Fill Button', 'button', 'liquid-fill', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<button class="btn-liquid">Hover Me</button>',
'.btn-liquid { background: transparent; color: #667eea; padding: 1rem 2.5rem; border: 2px solid #667eea; border-radius: 50px; font-size: 1rem; font-weight: 700; cursor: pointer; position: relative; overflow: hidden; z-index: 1; transition: color 0.5s; } .btn-liquid::before { content: ""; position: absolute; bottom: 0; left: 0; width: 100%; height: 0; background: #667eea; z-index: -1; transition: height 0.5s; border-radius: 50px; } .btn-liquid:hover { color: white; } .btn-liquid:hover::before { height: 100%; }',
NULL,
'Liquid fill button với smooth animation', 'button,liquid,animated,creative', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Icon Button Group', 'button', 'icon-group', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="btn-icon-group">
  <button class="btn-icon">💼 Dashboard</button>
  <button class="btn-icon">📊 Analytics</button>
  <button class="btn-icon">⚙️ Settings</button>
</div>',
'.btn-icon-group { display: flex; gap: 1rem; flex-wrap: wrap; } .btn-icon { background: white; color: #1a1a1a; padding: 0.9rem 1.8rem; border: 2px solid #e5e5e5; border-radius: 12px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.3s; display: flex; align-items: center; gap: 0.5rem; } .btn-icon:hover { border-color: #667eea; color: #667eea; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2); }',
NULL,
'Icon button group với hover effects', 'button,icon,group,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Gradient Border Button', 'button', 'gradient-border', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<button class="btn-gradient-border">Learn More</button>',
'.btn-gradient-border { background: white; color: #667eea; padding: 1rem 2.5rem; border: none; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; position: relative; transition: all 0.3s; } .btn-gradient-border::before { content: ""; position: absolute; inset: -3px; background: linear-gradient(135deg, #667eea, #764ba2, #f093fb); border-radius: 14px; z-index: -1; } .btn-gradient-border:hover { transform: translateY(-2px); color: white; background: linear-gradient(135deg, #667eea, #764ba2); }',
NULL,
'Button với gradient border effect', 'button,gradient,border,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Neumorphism Button', 'button', 'neumorphism', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<button class="btn-neuro">Submit</button>',
'.btn-neuro { background: #e0e5ec; color: #4a5568; padding: 1rem 2.5rem; border: none; border-radius: 15px; font-size: 1rem; font-weight: 700; cursor: pointer; box-shadow: 8px 8px 16px #a3b1c6, -8px -8px 16px #ffffff; transition: all 0.3s; } .btn-neuro:hover { box-shadow: 4px 4px 8px #a3b1c6, -4px -4px 8px #ffffff; } .btn-neuro:active { box-shadow: inset 4px 4px 8px #a3b1c6, inset -4px -4px 8px #ffffff; }',
NULL,
'Neumorphism soft UI button', 'button,neumorphism,soft,ui', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== CARDS (15+ styles) ==========

('Product Card Glass', 'card', 'product-glass', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="card-product-glass">
  <div class="card-image-glass">
    <div class="placeholder-image">📱</div>
  </div>
  <div class="card-content-glass">
    <h3>Premium Product</h3>
    <p class="card-price">$299</p>
    <p class="card-desc">High quality product with amazing features</p>
    <button class="card-btn-glass">Add to Cart</button>
  </div>
</div>',
'.card-product-glass { width: 300px; background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 20px; overflow: hidden; transition: all 0.3s; } .card-product-glass:hover { transform: translateY(-10px); box-shadow: 0 20px 60px rgba(0,0,0,0.2); } .card-image-glass { background: linear-gradient(135deg, #667eea, #764ba2); height: 200px; display: flex; align-items: center; justify-content: center; } .placeholder-image { font-size: 4rem; } .card-content-glass { padding: 1.5rem; } .card-content-glass h3 { font-size: 1.3rem; font-weight: 700; color: #1a1a1a; margin-bottom: 0.5rem; } .card-price { font-size: 2rem; font-weight: 800; color: #667eea; margin-bottom: 0.5rem; } .card-desc { color: #666; font-size: 0.9rem; margin-bottom: 1rem; line-height: 1.5; } .card-btn-glass { width: 100%; background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 0.9rem; border-radius: 10px; font-weight: 600; cursor: pointer; transition: all 0.3s; } .card-btn-glass:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4); }',
NULL,
'Glass morphism product card với gradient', 'card,product,glass,gradient', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Profile Card Modern', 'card', 'profile-modern', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="card-profile-modern">
  <div class="profile-header">
    <div class="profile-avatar">👤</div>
  </div>
  <div class="profile-body">
    <h3>John Doe</h3>
    <p class="profile-role">Senior Developer</p>
    <p class="profile-bio">Passionate about creating beautiful UIs and amazing user experiences</p>
    <div class="profile-stats">
      <div class="stat">
        <div class="stat-value">124</div>
        <div class="stat-label">Projects</div>
      </div>
      <div class="stat">
        <div class="stat-value">2.5K</div>
        <div class="stat-label">Followers</div>
      </div>
      <div class="stat">
        <div class="stat-value">890</div>
        <div class="stat-label">Following</div>
      </div>
    </div>
    <button class="profile-btn">Follow</button>
  </div>
</div>',
'.card-profile-modern { width: 320px; background: white; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); overflow: hidden; transition: all 0.3s; } .card-profile-modern:hover { transform: translateY(-5px); box-shadow: 0 20px 60px rgba(0,0,0,0.15); } .profile-header { background: linear-gradient(135deg, #667eea, #764ba2); height: 120px; position: relative; } .profile-avatar { width: 100px; height: 100px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 3rem; position: absolute; bottom: -50px; left: 50%; transform: translateX(-50%); box-shadow: 0 8px 24px rgba(0,0,0,0.15); } .profile-body { padding: 4rem 2rem 2rem; text-align: center; } .profile-body h3 { font-size: 1.5rem; font-weight: 700; color: #1a1a1a; margin-bottom: 0.3rem; } .profile-role { color: #667eea; font-weight: 600; margin-bottom: 1rem; } .profile-bio { color: #666; font-size: 0.9rem; line-height: 1.6; margin-bottom: 1.5rem; } .profile-stats { display: flex; justify-content: space-around; margin-bottom: 2rem; padding: 1.5rem 0; border-top: 1px solid #f0f0f0; border-bottom: 1px solid #f0f0f0; } .stat-value { font-size: 1.5rem; font-weight: 800; color: #1a1a1a; } .stat-label { font-size: 0.8rem; color: #999; margin-top: 0.3rem; } .profile-btn { width: 100%; background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 1rem; border-radius: 12px; font-weight: 700; cursor: pointer; transition: all 0.3s; } .profile-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4); }',
NULL,
'Modern profile card với stats và gradient header', 'card,profile,modern,stats', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Pricing Card Premium', 'card', 'pricing-premium', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="pricing-card-premium">
  <div class="pricing-badge">POPULAR</div>
  <h3 class="pricing-title">Pro Plan</h3>
  <div class="pricing-price">
    <span class="price-currency">$</span>
    <span class="price-amount">49</span>
    <span class="price-period">/month</span>
  </div>
  <ul class="pricing-features">
    <li>✓ Unlimited Projects</li>
    <li>✓ Advanced Analytics</li>
    <li>✓ Priority Support</li>
    <li>✓ Custom Domain</li>
    <li>✓ Team Collaboration</li>
  </ul>
  <button class="pricing-btn">Get Started</button>
</div>',
'.pricing-card-premium { width: 300px; background: white; border-radius: 20px; padding: 2.5rem 2rem; box-shadow: 0 10px 40px rgba(0,0,0,0.1); position: relative; transition: all 0.3s; border: 2px solid transparent; } .pricing-card-premium:hover { transform: translateY(-10px) scale(1.02); box-shadow: 0 30px 80px rgba(102, 126, 234, 0.3); border-color: #667eea; } .pricing-badge { position: absolute; top: 20px; right: 20px; background: linear-gradient(135deg, #667eea, #764ba2); color: white; padding: 0.4rem 1rem; border-radius: 20px; font-size: 0.75rem; font-weight: 700; letter-spacing: 1px; } .pricing-title { font-size: 1.8rem; font-weight: 800; color: #1a1a1a; margin-bottom: 1rem; } .pricing-price { display: flex; align-items: flex-start; margin-bottom: 2rem; } .price-currency { font-size: 1.5rem; font-weight: 700; color: #667eea; margin-top: 0.5rem; } .price-amount { font-size: 4rem; font-weight: 900; color: #667eea; line-height: 1; } .price-period { font-size: 1rem; color: #999; margin-top: 2rem; margin-left: 0.5rem; } .pricing-features { list-style: none; margin-bottom: 2rem; } .pricing-features li { padding: 0.75rem 0; color: #666; font-size: 1rem; border-bottom: 1px solid #f0f0f0; } .pricing-features li:last-child { border-bottom: none; } .pricing-btn { width: 100%; background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 1.2rem; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.3s; } .pricing-btn:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4); }',
NULL,
'Premium pricing card với badge và features', 'card,pricing,premium,features', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Blog Card Minimal', 'card', 'blog-minimal', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="blog-card-minimal">
  <div class="blog-image">
    <div class="blog-placeholder">📝</div>
  </div>
  <div class="blog-content">
    <div class="blog-meta">
      <span class="blog-date">Dec 28, 2024</span>
      <span class="blog-category">Design</span>
    </div>
    <h3>Modern Design Principles</h3>
    <p>Explore the latest trends in web design and how to apply them effectively...</p>
    <a href="#" class="blog-link">Read More →</a>
  </div>
</div>',
'.blog-card-minimal { width: 350px; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.08); transition: all 0.3s; } .blog-card-minimal:hover { transform: translateY(-5px); box-shadow: 0 12px 40px rgba(0,0,0,0.12); } .blog-image { height: 200px; background: linear-gradient(135deg, #667eea20, #764ba220); display: flex; align-items: center; justify-content: center; overflow: hidden; } .blog-placeholder { font-size: 4rem; } .blog-content { padding: 1.5rem; } .blog-meta { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; } .blog-date { font-size: 0.85rem; color: #999; } .blog-category { background: #667eea20; color: #667eea; padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.8rem; font-weight: 600; } .blog-content h3 { font-size: 1.3rem; font-weight: 700; color: #1a1a1a; margin-bottom: 0.8rem; line-height: 1.4; } .blog-content p { color: #666; font-size: 0.95rem; line-height: 1.6; margin-bottom: 1rem; } .blog-link { color: #667eea; font-weight: 600; text-decoration: none; transition: all 0.3s; } .blog-link:hover { color: #764ba2; }',
NULL,
'Minimal blog card với meta information', 'card,blog,minimal,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Testimonial Card', 'card', 'testimonial', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="testimonial-card">
  <div class="testimonial-quote">"</div>
  <p class="testimonial-text">This product has completely transformed how we work. The design is intuitive and the features are exactly what we needed.</p>
  <div class="testimonial-author">
    <div class="author-avatar">👨‍💼</div>
    <div class="author-info">
      <div class="author-name">Michael Chen</div>
      <div class="author-role">CEO, TechCorp</div>
    </div>
  </div>
</div>',
'.testimonial-card { width: 400px; background: white; border-radius: 20px; padding: 2.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.08); position: relative; transition: all 0.3s; } .testimonial-card:hover { transform: translateY(-5px); box-shadow: 0 20px 60px rgba(0,0,0,0.12); } .testimonial-quote { font-size: 6rem; font-weight: 900; color: #667eea20; line-height: 1; position: absolute; top: 20px; left: 20px; } .testimonial-text { font-size: 1.1rem; color: #333; line-height: 1.8; margin-bottom: 2rem; position: relative; z-index: 1; font-style: italic; } .testimonial-author { display: flex; align-items: center; gap: 1rem; } .author-avatar { width: 50px; height: 50px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; } .author-name { font-weight: 700; color: #1a1a1a; margin-bottom: 0.2rem; } .author-role { font-size: 0.9rem; color: #999; }',
NULL,
'Testimonial card với author info và quote', 'card,testimonial,quote,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Stats Card Animated', 'card', 'stats-animated', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="stats-card-animated">
  <div class="stats-icon">📈</div>
  <div class="stats-number">2,847</div>
  <div class="stats-label">Active Users</div>
  <div class="stats-change">↑ 12% from last month</div>
</div>',
'.stats-card-animated { width: 250px; background: white; border-radius: 16px; padding: 2rem; box-shadow: 0 4px 20px rgba(0,0,0,0.08); text-align: center; transition: all 0.3s; cursor: pointer; } .stats-card-animated:hover { transform: translateY(-8px) scale(1.02); box-shadow: 0 20px 50px rgba(102, 126, 234, 0.2); } .stats-icon { font-size: 3rem; margin-bottom: 1rem; animation: stats-bounce 2s infinite; } @keyframes stats-bounce { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-10px); } } .stats-number { font-size: 3rem; font-weight: 900; background: linear-gradient(135deg, #667eea, #764ba2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 0.5rem; } .stats-label { font-size: 1rem; color: #666; font-weight: 600; margin-bottom: 1rem; } .stats-change { font-size: 0.9rem; color: #22c55e; font-weight: 600; }',
NULL,
'Animated stats card với icon bounce effect', 'card,stats,animated,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== FORMS (10+ styles) ==========

('Modern Input Field', 'form', 'input-modern', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="input-modern-wrapper">
  <input type="text" class="input-modern" placeholder=" " id="modern-input">
  <label for="modern-input" class="input-label">Email Address</label>
  <div class="input-underline"></div>
</div>',
'.input-modern-wrapper { position: relative; width: 300px; margin: 2rem 0; } .input-modern { width: 100%; padding: 1rem 0.5rem; font-size: 1rem; border: none; border-bottom: 2px solid #e5e5e5; background: transparent; transition: all 0.3s; outline: none; } .input-modern:focus { border-bottom-color: #667eea; } .input-label { position: absolute; left: 0.5rem; top: 1rem; font-size: 1rem; color: #999; transition: all 0.3s; pointer-events: none; } .input-modern:focus ~ .input-label, .input-modern:not(:placeholder-shown) ~ .input-label { top: -0.5rem; font-size: 0.8rem; color: #667eea; font-weight: 600; } .input-underline { position: absolute; bottom: 0; left: 0; width: 0; height: 2px; background: linear-gradient(135deg, #667eea, #764ba2); transition: width 0.3s; } .input-modern:focus ~ .input-underline { width: 100%; }',
NULL,
'Modern input field với floating label và gradient underline', 'form,input,modern,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Glass Search Bar', 'form', 'search-glass', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="search-glass">
  <input type="text" class="search-input-glass" placeholder="Search...">
  <button class="search-btn-glass">🔍</button>
</div>',
'.search-glass { display: flex; align-items: center; background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 50px; padding: 0.5rem 0.5rem 0.5rem 1.5rem; width: 400px; transition: all 0.3s; } .search-glass:focus-within { background: rgba(255, 255, 255, 0.15); box-shadow: 0 8px 32px rgba(102, 126, 234, 0.2); } .search-input-glass { flex: 1; background: transparent; border: none; outline: none; color: #1a1a1a; font-size: 1rem; } .search-input-glass::placeholder { color: rgba(0,0,0,0.5); } .search-btn-glass { width: 45px; height: 45px; background: linear-gradient(135deg, #667eea, #764ba2); border: none; border-radius: 50%; font-size: 1.2rem; cursor: pointer; transition: all 0.3s; } .search-btn-glass:hover { transform: scale(1.1); box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4); }',
NULL,
'Glass search bar với backdrop blur và gradient button', 'form,search,glass,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Login Form Modern', 'form', 'login-modern', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="login-form-modern">
  <h2 class="login-title">Welcome Back</h2>
  <p class="login-subtitle">Sign in to continue</p>
  <div class="form-group-modern">
    <input type="email" class="form-input-modern" placeholder="Email">
  </div>
  <div class="form-group-modern">
    <input type="password" class="form-input-modern" placeholder="Password">
  </div>
  <div class="form-options">
    <label class="checkbox-modern">
      <input type="checkbox">
      <span>Remember me</span>
    </label>
    <a href="#" class="forgot-link">Forgot?</a>
  </div>
  <button class="login-btn-modern">Sign In</button>
  <p class="login-footer">Don''t have an account? <a href="#">Sign up</a></p>
</div>',
'.login-form-modern { width: 400px; background: white; padding: 3rem; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.1); } .login-title { font-size: 2rem; font-weight: 800; color: #1a1a1a; margin-bottom: 0.5rem; } .login-subtitle { color: #999; margin-bottom: 2rem; } .form-group-modern { margin-bottom: 1.5rem; } .form-input-modern { width: 100%; padding: 1rem 1.5rem; border: 2px solid #e5e5e5; border-radius: 12px; font-size: 1rem; transition: all 0.3s; outline: none; } .form-input-modern:focus { border-color: #667eea; box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1); } .form-options { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; } .checkbox-modern { display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; color: #666; cursor: pointer; } .forgot-link { color: #667eea; text-decoration: none; font-size: 0.9rem; font-weight: 600; } .login-btn-modern { width: 100%; background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 1.2rem; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.3s; } .login-btn-modern:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4); } .login-footer { text-align: center; margin-top: 2rem; color: #999; font-size: 0.9rem; } .login-footer a { color: #667eea; text-decoration: none; font-weight: 600; }',
NULL,
'Modern login form với gradient button và clean design', 'form,login,modern,gradient', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Textarea Animated', 'form', 'textarea-animated', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="textarea-wrapper">
  <textarea class="textarea-animated" placeholder=" " id="message"></textarea>
  <label for="message" class="textarea-label">Your Message</label>
  <div class="char-count">0 / 500</div>
</div>',
'.textarea-wrapper { position: relative; width: 400px; margin: 2rem 0; } .textarea-animated { width: 100%; min-height: 150px; padding: 1.5rem; font-size: 1rem; border: 2px solid #e5e5e5; border-radius: 12px; background: white; transition: all 0.3s; outline: none; resize: vertical; font-family: inherit; } .textarea-animated:focus { border-color: #667eea; box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1); } .textarea-label { position: absolute; left: 1rem; top: 1.5rem; font-size: 1rem; color: #999; transition: all 0.3s; pointer-events: none; background: white; padding: 0 0.5rem; } .textarea-animated:focus ~ .textarea-label, .textarea-animated:not(:placeholder-shown) ~ .textarea-label { top: -0.7rem; font-size: 0.85rem; color: #667eea; font-weight: 600; } .char-count { position: absolute; bottom: -1.5rem; right: 0; font-size: 0.85rem; color: #999; }',
NULL,
'Animated textarea với floating label và character count', 'form,textarea,animated,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Toggle Switch Modern', 'form', 'toggle-modern', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<label class="toggle-modern">
  <input type="checkbox" class="toggle-input">
  <span class="toggle-slider"></span>
  <span class="toggle-label">Enable notifications</span>
</label>',
'.toggle-modern { display: flex; align-items: center; gap: 1rem; cursor: pointer; user-select: none; } .toggle-input { display: none; } .toggle-slider { position: relative; width: 60px; height: 30px; background: #e5e5e5; border-radius: 30px; transition: all 0.3s; } .toggle-slider::before { content: ""; position: absolute; width: 24px; height: 24px; background: white; border-radius: 50%; top: 3px; left: 3px; transition: all 0.3s; box-shadow: 0 2px 8px rgba(0,0,0,0.2); } .toggle-input:checked + .toggle-slider { background: linear-gradient(135deg, #667eea, #764ba2); } .toggle-input:checked + .toggle-slider::before { transform: translateX(30px); } .toggle-label { font-size: 1rem; color: #333; font-weight: 500; }',
NULL,
'Modern toggle switch với gradient active state', 'form,toggle,switch,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Select Dropdown Styled', 'form', 'select-styled', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="select-wrapper">
  <select class="select-styled">
    <option>Select an option</option>
    <option>Option 1</option>
    <option>Option 2</option>
    <option>Option 3</option>
  </select>
  <div class="select-arrow">▼</div>
</div>',
'.select-wrapper { position: relative; width: 300px; } .select-styled { width: 100%; padding: 1rem 1.5rem; font-size: 1rem; border: 2px solid #e5e5e5; border-radius: 12px; background: white; cursor: pointer; appearance: none; transition: all 0.3s; outline: none; } .select-styled:focus { border-color: #667eea; box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1); } .select-arrow { position: absolute; right: 1.5rem; top: 50%; transform: translateY(-50%); pointer-events: none; color: #667eea; font-size: 0.8rem; transition: all 0.3s; } .select-styled:focus ~ .select-arrow { transform: translateY(-50%) rotate(180deg); }',
NULL,
'Styled select dropdown với custom arrow', 'form,select,dropdown,styled', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Radio Button Modern', 'form', 'radio-modern', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="radio-group-modern">
  <label class="radio-modern">
    <input type="radio" name="plan" class="radio-input">
    <span class="radio-custom"></span>
    <span class="radio-text">Monthly Plan</span>
  </label>
  <label class="radio-modern">
    <input type="radio" name="plan" class="radio-input">
    <span class="radio-custom"></span>
    <span class="radio-text">Yearly Plan</span>
  </label>
</div>',
'.radio-group-modern { display: flex; flex-direction: column; gap: 1rem; } .radio-modern { display: flex; align-items: center; gap: 1rem; cursor: pointer; padding: 1rem; border: 2px solid #e5e5e5; border-radius: 12px; transition: all 0.3s; } .radio-modern:hover { border-color: #667eea20; background: #667eea05; } .radio-input { display: none; } .radio-custom { width: 24px; height: 24px; border: 2px solid #e5e5e5; border-radius: 50%; position: relative; transition: all 0.3s; } .radio-custom::after { content: ""; position: absolute; width: 12px; height: 12px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; top: 50%; left: 50%; transform: translate(-50%, -50%) scale(0); transition: all 0.3s; } .radio-input:checked + .radio-custom { border-color: #667eea; } .radio-input:checked + .radio-custom::after { transform: translate(-50%, -50%) scale(1); } .radio-input:checked ~ .radio-text { color: #667eea; font-weight: 600; } .radio-text { font-size: 1rem; color: #333; transition: all 0.3s; }',
NULL,
'Modern radio buttons với custom styling', 'form,radio,modern,styled', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== MODALS & POPUPS ==========

('Alert Modal Modern', 'modal', 'alert-modern', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="modal-overlay">
  <div class="alert-modal-modern">
    <div class="alert-icon">✓</div>
    <h3 class="alert-title">Success!</h3>
    <p class="alert-message">Your action has been completed successfully.</p>
    <button class="alert-btn">Got it</button>
  </div>
</div>',
'.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; z-index: 1000; } .alert-modal-modern { background: white; padding: 3rem 2.5rem; border-radius: 24px; text-align: center; max-width: 400px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); animation: modal-appear 0.3s ease; } @keyframes modal-appear { from { opacity: 0; transform: scale(0.9) translateY(-20px); } to { opacity: 1; transform: scale(1) translateY(0); } } .alert-icon { width: 80px; height: 80px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; font-size: 3rem; color: white; animation: icon-bounce 0.6s ease; } @keyframes icon-bounce { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.1); } } .alert-title { font-size: 1.8rem; font-weight: 800; color: #1a1a1a; margin-bottom: 1rem; } .alert-message { color: #666; font-size: 1rem; line-height: 1.6; margin-bottom: 2rem; } .alert-btn { background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 1rem 3rem; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.3s; } .alert-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4); }',
NULL,
'Modern alert modal với animated icon', 'modal,alert,animated,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Confirmation Dialog', 'modal', 'confirmation', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="modal-overlay">
  <div class="confirmation-dialog">
    <div class="dialog-icon">⚠️</div>
    <h3 class="dialog-title">Are you sure?</h3>
    <p class="dialog-message">This action cannot be undone. Please confirm to proceed.</p>
    <div class="dialog-actions">
      <button class="dialog-btn dialog-btn-cancel">Cancel</button>
      <button class="dialog-btn dialog-btn-confirm">Confirm</button>
    </div>
  </div>
</div>',
'.confirmation-dialog { background: white; padding: 2.5rem; border-radius: 20px; text-align: center; max-width: 450px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); animation: modal-appear 0.3s ease; } .dialog-icon { font-size: 4rem; margin-bottom: 1.5rem; } .dialog-title { font-size: 1.6rem; font-weight: 800; color: #1a1a1a; margin-bottom: 1rem; } .dialog-message { color: #666; font-size: 1rem; line-height: 1.6; margin-bottom: 2rem; } .dialog-actions { display: flex; gap: 1rem; } .dialog-btn { flex: 1; padding: 1rem; border: none; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.3s; } .dialog-btn-cancel { background: #f0f0f0; color: #666; } .dialog-btn-cancel:hover { background: #e5e5e5; } .dialog-btn-confirm { background: linear-gradient(135deg, #667eea, #764ba2); color: white; } .dialog-btn-confirm:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4); }',
NULL,
'Confirmation dialog với two action buttons', 'modal,confirmation,dialog,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Glass Modal', 'modal', 'glass-modal', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="modal-overlay">
  <div class="glass-modal">
    <button class="glass-modal-close">×</button>
    <h2 class="glass-modal-title">Welcome</h2>
    <p class="glass-modal-text">Experience the power of modern design with our glass morphism components.</p>
    <div class="glass-modal-actions">
      <button class="glass-modal-btn">Learn More</button>
    </div>
  </div>
</div>',
'.glass-modal { background: rgba(255, 255, 255, 0.15); backdrop-filter: blur(30px); border: 1px solid rgba(255, 255, 255, 0.3); padding: 3rem; border-radius: 24px; max-width: 500px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); position: relative; animation: modal-appear 0.3s ease; } .glass-modal-close { position: absolute; top: 1.5rem; right: 1.5rem; background: rgba(255,255,255,0.2); border: none; width: 40px; height: 40px; border-radius: 50%; font-size: 1.5rem; cursor: pointer; transition: all 0.3s; color: #1a1a1a; } .glass-modal-close:hover { background: rgba(255,255,255,0.3); transform: rotate(90deg); } .glass-modal-title { font-size: 2rem; font-weight: 800; color: #1a1a1a; margin-bottom: 1rem; } .glass-modal-text { color: #333; font-size: 1.1rem; line-height: 1.8; margin-bottom: 2rem; } .glass-modal-btn { background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 1rem 2.5rem; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.3s; } .glass-modal-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4); }',
NULL,
'Glass morphism modal với backdrop blur', 'modal,glass,morphism,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Side Drawer', 'modal', 'side-drawer', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="drawer-overlay">
  <div class="side-drawer">
    <div class="drawer-header">
      <h3>Menu</h3>
      <button class="drawer-close">×</button>
    </div>
    <nav class="drawer-nav">
      <a href="#" class="drawer-link">Home</a>
      <a href="#" class="drawer-link">Products</a>
      <a href="#" class="drawer-link">Services</a>
      <a href="#" class="drawer-link">About</a>
      <a href="#" class="drawer-link">Contact</a>
    </nav>
    <div class="drawer-footer">
      <button class="drawer-btn">Sign In</button>
    </div>
  </div>
</div>',
'.drawer-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5); backdrop-filter: blur(4px); z-index: 1000; } .side-drawer { position: fixed; right: 0; top: 0; bottom: 0; width: 320px; background: white; box-shadow: -10px 0 60px rgba(0,0,0,0.3); animation: drawer-slide 0.3s ease; display: flex; flex-direction: column; } @keyframes drawer-slide { from { transform: translateX(100%); } to { transform: translateX(0); } } .drawer-header { display: flex; justify-content: space-between; align-items: center; padding: 2rem; border-bottom: 1px solid #e5e5e5; } .drawer-header h3 { font-size: 1.5rem; font-weight: 800; color: #1a1a1a; } .drawer-close { background: none; border: none; font-size: 2rem; cursor: pointer; color: #999; transition: all 0.3s; } .drawer-close:hover { color: #1a1a1a; transform: rotate(90deg); } .drawer-nav { flex: 1; padding: 2rem 0; } .drawer-link { display: block; padding: 1rem 2rem; color: #666; text-decoration: none; font-weight: 600; transition: all 0.3s; border-left: 3px solid transparent; } .drawer-link:hover { color: #667eea; background: #667eea10; border-left-color: #667eea; } .drawer-footer { padding: 2rem; border-top: 1px solid #e5e5e5; } .drawer-btn { width: 100%; background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 1rem; border-radius: 12px; font-weight: 700; cursor: pointer; transition: all 0.3s; } .drawer-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4); }',
NULL,
'Side drawer menu với slide animation', 'modal,drawer,menu,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== TABLES ==========

('Modern Data Table', 'table', 'data-modern', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="table-modern-wrapper">
  <table class="table-modern">
    <thead>
      <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Role</th>
        <th>Status</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>John Doe</td>
        <td>john@example.com</td>
        <td>Developer</td>
        <td><span class="badge-active">Active</span></td>
      </tr>
      <tr>
        <td>Jane Smith</td>
        <td>jane@example.com</td>
        <td>Designer</td>
        <td><span class="badge-active">Active</span></td>
      </tr>
      <tr>
        <td>Mike Johnson</td>
        <td>mike@example.com</td>
        <td>Manager</td>
        <td><span class="badge-inactive">Inactive</span></td>
      </tr>
    </tbody>
  </table>
</div>',
'.table-modern-wrapper { overflow-x: auto; background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); } .table-modern { width: 100%; border-collapse: collapse; } .table-modern thead { background: linear-gradient(135deg, #667eea10, #764ba210); } .table-modern th { padding: 1.2rem 1.5rem; text-align: left; font-weight: 700; color: #667eea; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px; } .table-modern td { padding: 1.2rem 1.5rem; color: #333; border-bottom: 1px solid #f0f0f0; } .table-modern tbody tr { transition: all 0.3s; } .table-modern tbody tr:hover { background: #667eea05; } .table-modern tbody tr:last-child td { border-bottom: none; } .badge-active { background: #22c55e20; color: #22c55e; padding: 0.4rem 1rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600; } .badge-inactive { background: #ef444420; color: #ef4444; padding: 0.4rem 1rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }',
NULL,
'Modern data table với hover effects và badges', 'table,data,modern,badges', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Pricing Comparison Table', 'table', 'pricing-comparison', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="pricing-table">
  <div class="pricing-column">
    <h3 class="pricing-plan">Basic</h3>
    <div class="pricing-amount">$19<span>/mo</span></div>
    <ul class="pricing-features-list">
      <li>✓ 10 Projects</li>
      <li>✓ Basic Support</li>
      <li>✗ Advanced Analytics</li>
      <li>✗ Custom Domain</li>
    </ul>
    <button class="pricing-table-btn">Choose Plan</button>
  </div>
  <div class="pricing-column pricing-featured">
    <div class="featured-badge">Popular</div>
    <h3 class="pricing-plan">Pro</h3>
    <div class="pricing-amount">$49<span>/mo</span></div>
    <ul class="pricing-features-list">
      <li>✓ Unlimited Projects</li>
      <li>✓ Priority Support</li>
      <li>✓ Advanced Analytics</li>
      <li>✓ Custom Domain</li>
    </ul>
    <button class="pricing-table-btn">Choose Plan</button>
  </div>
  <div class="pricing-column">
    <h3 class="pricing-plan">Enterprise</h3>
    <div class="pricing-amount">$99<span>/mo</span></div>
    <ul class="pricing-features-list">
      <li>✓ Everything in Pro</li>
      <li>✓ Dedicated Support</li>
      <li>✓ Custom Integration</li>
      <li>✓ SLA Guarantee</li>
    </ul>
    <button class="pricing-table-btn">Choose Plan</button>
  </div>
</div>',
'.pricing-table { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; max-width: 1200px; margin: 0 auto; } .pricing-column { background: white; padding: 2.5rem 2rem; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.08); text-align: center; transition: all 0.3s; position: relative; } .pricing-column:hover { transform: translateY(-10px); box-shadow: 0 20px 60px rgba(0,0,0,0.12); } .pricing-featured { border: 3px solid #667eea; transform: scale(1.05); } .pricing-featured:hover { transform: scale(1.05) translateY(-10px); } .featured-badge { position: absolute; top: -15px; left: 50%; transform: translateX(-50%); background: linear-gradient(135deg, #667eea, #764ba2); color: white; padding: 0.5rem 1.5rem; border-radius: 20px; font-size: 0.85rem; font-weight: 700; } .pricing-plan { font-size: 1.5rem; font-weight: 800; color: #1a1a1a; margin-bottom: 1.5rem; } .pricing-amount { font-size: 3rem; font-weight: 900; color: #667eea; margin-bottom: 2rem; } .pricing-amount span { font-size: 1.2rem; color: #999; font-weight: 600; } .pricing-features-list { list-style: none; margin-bottom: 2rem; text-align: left; } .pricing-features-list li { padding: 0.75rem 0; color: #666; border-bottom: 1px solid #f0f0f0; } .pricing-features-list li:last-child { border-bottom: none; } .pricing-table-btn { width: 100%; background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 1rem; border-radius: 12px; font-weight: 700; cursor: pointer; transition: all 0.3s; } .pricing-table-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4); }',
NULL,
'Pricing comparison table layout với featured column', 'table,pricing,comparison,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

ON CONFLICT DO NOTHING;

-- ========== LOADING & SPINNERS ==========

INSERT INTO "DesignComponents" ("Name", "Category", "Type", "Preview", "HtmlCode", "CssCode", "JsCode", "Description", "Tags", "Framework", "Views", "Likes", "CreatedAt", "UpdatedAt") VALUES

('Spinner Dots', 'loading', 'spinner-dots', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="spinner-dots">
  <div class="dot"></div>
  <div class="dot"></div>
  <div class="dot"></div>
</div>',
'.spinner-dots { display: flex; gap: 0.5rem; justify-content: center; align-items: center; padding: 2rem; } .dot { width: 12px; height: 12px; border-radius: 50%; background: linear-gradient(135deg, #667eea, #764ba2); animation: dot-bounce 1.4s infinite ease-in-out both; } .dot:nth-child(1) { animation-delay: -0.32s; } .dot:nth-child(2) { animation-delay: -0.16s; } @keyframes dot-bounce { 0%, 80%, 100% { transform: scale(0); } 40% { transform: scale(1); } }',
NULL,
'Animated dots spinner với gradient colors', 'loading,spinner,dots,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Pulse Ring Loader', 'loading', 'pulse-ring', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="pulse-ring-loader">
  <div class="pulse-ring"></div>
  <div class="pulse-ring"></div>
  <div class="pulse-ring"></div>
</div>',
'.pulse-ring-loader { position: relative; width: 80px; height: 80px; margin: 2rem auto; } .pulse-ring { position: absolute; border: 4px solid #667eea; border-radius: 50%; opacity: 1; animation: pulse-ring 1.5s cubic-bezier(0, 0.2, 0.8, 1) infinite; } .pulse-ring:nth-child(2) { animation-delay: -0.5s; } .pulse-ring:nth-child(3) { animation-delay: -1s; } @keyframes pulse-ring { 0% { transform: scale(0.8); opacity: 1; } 100% { transform: scale(1.5); opacity: 0; } }',
NULL,
'Pulse ring loading animation với multiple rings', 'loading,pulse,ring,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Progress Bar Gradient', 'loading', 'progress-gradient', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="progress-container">
  <div class="progress-bar-gradient" style="width: 65%;"></div>
</div>',
'.progress-container { width: 100%; max-width: 400px; height: 8px; background: #e5e5e5; border-radius: 10px; overflow: hidden; position: relative; } .progress-bar-gradient { height: 100%; background: linear-gradient(90deg, #667eea, #764ba2, #f093fb); border-radius: 10px; animation: progress-shimmer 2s infinite; position: relative; } .progress-bar-gradient::after { content: ""; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent); animation: shimmer 1.5s infinite; } @keyframes shimmer { 0% { transform: translateX(-100%); } 100% { transform: translateX(100%); } }',
NULL,
'Gradient progress bar với shimmer effect', 'loading,progress,gradient,shimmer', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== BADGES & TAGS ==========

('Gradient Badge', 'badge', 'gradient-badge', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<span class="badge-gradient">New</span>',
'.badge-gradient { display: inline-block; background: linear-gradient(135deg, #667eea, #764ba2); color: white; padding: 0.4rem 1rem; border-radius: 20px; font-size: 0.85rem; font-weight: 700; letter-spacing: 0.5px; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3); }',
NULL,
'Gradient badge với shadow effect', 'badge,gradient,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Pill Badge', 'badge', 'pill-badge', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="badge-container">
  <span class="badge-pill badge-primary">Featured</span>
  <span class="badge-pill badge-success">Active</span>
  <span class="badge-pill badge-warning">Pending</span>
</div>',
'.badge-container { display: flex; gap: 0.5rem; flex-wrap: wrap; } .badge-pill { display: inline-block; padding: 0.3rem 0.9rem; border-radius: 50px; font-size: 0.8rem; font-weight: 600; } .badge-primary { background: #667eea20; color: #667eea; border: 1px solid #667eea; } .badge-success { background: #22c55e20; color: #22c55e; border: 1px solid #22c55e; } .badge-warning { background: #f59e0b20; color: #f59e0b; border: 1px solid #f59e0b; }',
NULL,
'Pill badges với multiple color variants', 'badge,pill,status,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== TYPOGRAPHY ==========

('Gradient Text Heading', 'typography', 'gradient-heading', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<h1 class="heading-gradient">Beautiful Gradient Text</h1>',
'.heading-gradient { font-size: 3.5rem; font-weight: 900; background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; margin: 2rem 0; line-height: 1.2; }',
NULL,
'Large gradient heading với multiple colors', 'typography,gradient,heading,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Animated Underline Text', 'typography', 'underline-animated', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="text-underline-animated">
  <h2>Hover Me</h2>
</div>',
'.text-underline-animated h2 { font-size: 2.5rem; font-weight: 700; color: #1a1a1a; display: inline-block; position: relative; cursor: pointer; } .text-underline-animated h2::after { content: ""; position: absolute; bottom: -5px; left: 0; width: 0; height: 3px; background: linear-gradient(90deg, #667eea, #764ba2); transition: width 0.4s ease; } .text-underline-animated h2:hover::after { width: 100%; }',
NULL,
'Text với animated underline on hover', 'typography,underline,animated,hover', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== NAVIGATION ==========

('Breadcrumb Navigation', 'navigation', 'breadcrumb', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<nav class="breadcrumb-nav">
  <a href="#" class="breadcrumb-item">Home</a>
  <span class="breadcrumb-separator">/</span>
  <a href="#" class="breadcrumb-item">Products</a>
  <span class="breadcrumb-separator">/</span>
  <span class="breadcrumb-current">Item Details</span>
</nav>',
'.breadcrumb-nav { display: flex; align-items: center; gap: 0.5rem; padding: 1rem 0; } .breadcrumb-item { color: #667eea; text-decoration: none; font-weight: 500; transition: all 0.3s; } .breadcrumb-item:hover { color: #764ba2; text-decoration: underline; } .breadcrumb-separator { color: #999; } .breadcrumb-current { color: #666; font-weight: 600; }',
NULL,
'Breadcrumb navigation với separator', 'navigation,breadcrumb,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('Tab Navigation Modern', 'navigation', 'tab-modern', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="tab-nav-modern">
  <button class="tab-item active">Overview</button>
  <button class="tab-item">Features</button>
  <button class="tab-item">Pricing</button>
  <button class="tab-item">Reviews</button>
</div>',
'.tab-nav-modern { display: flex; gap: 0.5rem; border-bottom: 2px solid #e5e5e5; padding-bottom: 0.5rem; } .tab-item { background: none; border: none; padding: 0.8rem 1.5rem; font-size: 1rem; font-weight: 600; color: #999; cursor: pointer; position: relative; transition: all 0.3s; } .tab-item::after { content: ""; position: absolute; bottom: -0.5rem; left: 0; width: 0; height: 3px; background: linear-gradient(90deg, #667eea, #764ba2); transition: width 0.3s; } .tab-item:hover { color: #667eea; } .tab-item.active { color: #667eea; } .tab-item.active::after { width: 100%; }',
NULL,
'Modern tab navigation với active indicator', 'navigation,tab,modern,animated', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== TOOLTIPS ==========

('Tooltip Top', 'tooltip', 'tooltip-top', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="tooltip-wrapper">
  <button class="tooltip-trigger">Hover Me</button>
  <div class="tooltip tooltip-top">This is a tooltip</div>
</div>',
'.tooltip-wrapper { position: relative; display: inline-block; margin: 3rem; } .tooltip-trigger { background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 0.8rem 2rem; border-radius: 8px; font-weight: 600; cursor: pointer; } .tooltip { position: absolute; background: #1a1a1a; color: white; padding: 0.6rem 1rem; border-radius: 8px; font-size: 0.9rem; white-space: nowrap; opacity: 0; pointer-events: none; transition: all 0.3s; z-index: 1000; } .tooltip-top { bottom: calc(100% + 10px); left: 50%; transform: translateX(-50%) translateY(-5px); } .tooltip-top::after { content: ""; position: absolute; top: 100%; left: 50%; transform: translateX(-50%); border: 6px solid transparent; border-top-color: #1a1a1a; } .tooltip-wrapper:hover .tooltip { opacity: 1; transform: translateX(-50%) translateY(0); }',
NULL,
'Tooltip với top position và arrow', 'tooltip,popover,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== AVATARS ==========

('Avatar Group Stacked', 'avatar', 'avatar-group', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="avatar-group">
  <div class="avatar avatar-1">A</div>
  <div class="avatar avatar-2">B</div>
  <div class="avatar avatar-3">C</div>
  <div class="avatar avatar-4">+5</div>
</div>',
'.avatar-group { display: flex; align-items: center; } .avatar { width: 45px; height: 45px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: white; border: 3px solid white; margin-left: -12px; position: relative; } .avatar:first-child { margin-left: 0; } .avatar-1 { background: linear-gradient(135deg, #667eea, #764ba2); z-index: 4; } .avatar-2 { background: linear-gradient(135deg, #f093fb, #f5576c); z-index: 3; } .avatar-3 { background: linear-gradient(135deg, #4facfe, #00f2fe); z-index: 2; } .avatar-4 { background: #e5e5e5; color: #666; z-index: 1; }',
NULL,
'Stacked avatar group với gradient backgrounds', 'avatar,group,stacked,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- ========== ALERTS & NOTIFICATIONS ==========

('Success Alert Banner', 'alert', 'success-banner', 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=200&fit=crop',
'<div class="alert-banner alert-success">
  <div class="alert-icon">✓</div>
  <div class="alert-content">
    <div class="alert-title">Success!</div>
    <div class="alert-message">Your changes have been saved successfully.</div>
  </div>
  <button class="alert-close">×</button>
</div>',
'.alert-banner { display: flex; align-items: center; gap: 1rem; padding: 1rem 1.5rem; border-radius: 12px; margin: 1rem 0; box-shadow: 0 4px 15px rgba(0,0,0,0.1); } .alert-success { background: #22c55e10; border: 2px solid #22c55e; } .alert-icon { width: 32px; height: 32px; background: #22c55e; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; flex-shrink: 0; } .alert-content { flex: 1; } .alert-title { font-weight: 700; color: #22c55e; margin-bottom: 0.25rem; } .alert-message { color: #666; font-size: 0.9rem; } .alert-close { background: none; border: none; font-size: 1.5rem; color: #999; cursor: pointer; padding: 0; width: 24px; height: 24px; display: flex; align-items: center; justify-content: center; } .alert-close:hover { color: #1a1a1a; }',
NULL,
'Success alert banner với icon và close button', 'alert,success,banner,modern', 'html', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

ON CONFLICT DO NOTHING;