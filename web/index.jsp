<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LifeFlow - Premium Blood Bank Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --brand-primary: #e11d48;
            --brand-primary-deep: #9f1239;
            --brand-accent: #fb7185;
            --brand-bg: #0f172a;
            --glass-bg: rgba(255, 255, 255, 0.08);
            --glass-border: rgba(255, 255, 255, 0.1);
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--brand-bg);
            color: #f8fafc;
            overflow-x: hidden;
            line-height: 1.6;
        }
        h1, h2, h3, h4, h5, .brand-text { font-family: 'Outfit', sans-serif; }
        .glass-card { background: var(--glass-bg); backdrop-filter: blur(20px); border: 1px solid var(--glass-border); border-radius: 24px; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .animate-up { animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards; opacity: 0; }
        .delay-1 { animation-delay: 0.2s; }
        .delay-2 { animation-delay: 0.4s; }
        .hero { min-height: 90vh; background: radial-gradient(circle at top right, rgba(225, 29, 72, 0.15), transparent); display: flex; align-items: center; position: relative; padding-top: 100px; }
        .hero-title { font-size: clamp(2.5rem, 8vw, 4.5rem); font-weight: 800; line-height: 1.1; margin-bottom: 2rem; background: linear-gradient(white, #cbd5e1); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .text-gradient { background: linear-gradient(to right, var(--brand-primary), var(--brand-accent)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .search-container { width: 100%; max-width: 1100px; margin-top: 3rem; }
        .search-glass { background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(20px); border: 1px solid var(--glass-border); padding: 12px; border-radius: 50rem; display: flex; align-items: center; gap: 10px; }
        .search-item { flex: 1; padding: 10px 20px; display: flex; align-items: center; gap: 12px; border-right: 1px solid var(--glass-border); }
        .search-item:last-child { border-right: none; }
        .search-select { background: transparent; border: none; color: #fff; width: 100%; outline: none; cursor: pointer; font-weight: 500; }
        .search-select option { background-color: #1e293b; color: #fff; }
        .btn-search { height: 55px; width: 55px; border-radius: 50%; display: flex; align-items: center; justify-content: center; background: var(--brand-primary); color: white; border: none; transition: 0.3s; }
        .btn-search:hover { background: var(--brand-primary-deep); transform: scale(1.1); }
        .feature-section { padding: 100px 0; }
        .glass-card-hover { transition: 0.4s cubic-bezier(0.2, 0.8, 0.2, 1); padding: 40px; }
        .glass-card-hover:hover { transform: translateY(-15px); background: rgba(255, 255, 255, 0.12); border-color: var(--brand-primary); }
        .icon-box { width: 70px; height: 70px; border-radius: 18px; background: rgba(225, 29, 72, 0.1); display: flex; align-items: center; justify-content: center; font-size: 2rem; color: var(--brand-primary); margin-bottom: 25px; }
    </style>
</head>
<body>

<jsp:include page="splash.jsp" />

<div id="main-wrapper">
    <jsp:include page="navbar.jsp" />

<section class="hero">
    <div class="container text-center">
        <div class="animate-up">
            <h1 class="hero-title">Giving <span class="text-gradient">Blood</span><br>Saves Every <span class="text-gradient">Life</span></h1>
            <p class="lead text-visible-muted mx-auto" style="max-width: 650px; color: #94a3b8;">Empowering the first digital-native blood donation network. Instant availability, direct donor matching, and emergency clinic tracking.</p>
        </div>

        <!-- VISION & MISSION SECTION -->
        <section class="vision-mission mx-auto animate-up delay-1" style="max-width: 1100px; margin-top: 4rem;">
            <div class="row g-4 justify-content-center text-center">
                <div class="col-md-6">
                    <div class="glass-card glass-card-hover h-100 p-5 border-danger" style="background: rgba(225, 29, 72, 0.05);">
                        <i class="fa-solid fa-eye fs-1 text-danger mb-4"></i>
                        <h3 class="text-white fw-bold mb-3">Our Vision</h3>
                        <p class="text-visible-muted lead mb-0">To eliminate blood scarcity globally by creating a universally accessible, verified, and instantaneous life-saving network.</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="glass-card glass-card-hover h-100 p-5">
                        <i class="fa-solid fa-bullseye fs-1 text-danger mb-4"></i>
                        <h3 class="text-white fw-bold mb-3">Our Mission</h3>
                        <p class="text-visible-muted lead mb-0">Bridging the gap between emergency medical requests and willing donors through cutting-edge digital tracking and direct community engagement.</p>
                    </div>
                </div>
            </div>
        </section>
        <!-- END VISION & MISSION -->
    </div>
</section>

<section class="feature-section">
    <div class="container">
        <div class="row g-4 justify-content-center">
            <div class="col-md-4"><div class="glass-card glass-card-hover"><div class="icon-box"><i class="fa-solid fa-clock"></i></div><h4 class="text-white fw-bold">Instant Alerts</h4><p style="color: #94a3b8;">Donors receive real-time notifications for local emergencies.</p></div></div>
            <div class="col-md-4"><div class="glass-card glass-card-hover"><div class="icon-box"><i class="fa-solid fa-user-shield"></i></div><h4 class="text-white fw-bold">Verified Donors</h4><p style="color: #94a3b8;">All participants are audited for safe and voluntary contributions.</p></div></div>
            <div class="col-md-4"><div class="glass-card glass-card-hover"><div class="icon-box"><i class="fa-solid fa-chart-pie"></i></div><h4 class="text-white fw-bold">Stock Tracking</h4><p style="color: #94a3b8;">Real-time inventory dashboards for medical facilities.</p></div></div>
        </div>
    </div>
</section>

<section class="support-section py-5 mt-5 border-top" style="border-color: rgba(255,255,255,0.05) !important; background: radial-gradient(circle at 50% 100%, rgba(225, 29, 72, 0.05), transparent);">
    <div class="container text-center">
        <div class="glass-card mx-auto p-5" style="max-width: 800px;">
            <i class="fa-solid fa-life-ring fs-1 text-danger mb-3"></i>
            <h3 class="text-white fw-bold mb-3">Need Assistance?</h3>
            <p class="text-visible-muted mb-4 mx-auto lead">Our 24/7 technical and administrative support team is always ready to assist hospitals and donors.</p>
            <a href="contact.jsp" class="btn-search mx-auto text-decoration-none d-inline-flex" style="width: auto; padding: 0 35px; border-radius: 50px;">
                <i class="fa-solid fa-headset me-2"></i> Contact Support Center
            </a>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
