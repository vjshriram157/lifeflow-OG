<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Features | LifeFlow Security & Network</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #0f172a !important; color: #f8fafc !important; font-family: 'Inter', sans-serif; padding-top: 100px; }
        h1, h2, h3, .brand-text { font-family: 'Outfit', sans-serif; }
        .features-hero { padding: 60px 0; }
        .feature-box { background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(15px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 30px; padding: 45px; height: 100%; transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .feature-box:hover { border-color: rgba(225, 29, 72, 0.4); transform: translateY(-12px); background: rgba(255, 255, 255, 0.06); }
        .feature-icon { width: 75px; height: 75px; background: rgba(225, 29, 72, 0.15); border-radius: 20px; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; color: #e11d48; margin-bottom: 30px; transition: 0.3s; }
        .feature-box:hover .feature-icon { transform: rotate(10deg) scale(1.1); background: #e11d48; color: #fff; }
        .text-visible-muted { color: #94a3b8 !important; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<section class="features-hero">
    <div class="container">
        <div class="text-center mb-5 animate-up">
            <span class="badge rounded-pill px-4 py-2 mb-4" style="background: rgba(225, 29, 72, 0.1); color: #e11d48; border: 1px solid rgba(225, 29, 72, 0.2);">
                <i class="fa-solid fa-shield-halved me-2"></i> Enterprise-Grade Infrastructure
            </span>
            <h1 class="display-4 fw-bold text-white mb-3">Modular Security Grid</h1>
            <p class="lead text-visible-muted mx-auto" style="max-width: 600px;">The autonomous infrastructure designed to eliminate blood shortages through data-driven intelligence.</p>
        </div>

        <div class="row g-4 pt-4">
            <div class="col-md-4 animate-up" style="animation-delay: 0.1s;">
                <div class="feature-box text-center text-md-start">
                    <div class="feature-icon mx-auto mx-md-0"><i class="fa-solid fa-satellite"></i></div>
                    <h4 class="text-white fw-bold mb-3">Emergency Grid</h4>
                    <p class="text-visible-muted">Hyper-local broadcast system that alerts donors within a 5km radius of a critical patient request, ensuring sub-10 minute response times.</p>
                </div>
            </div>
            <div class="col-md-4 animate-up" style="animation-delay: 0.2s;">
                <div class="feature-box text-center text-md-start">
                    <div class="feature-icon mx-auto mx-md-0"><i class="fa-solid fa-dna"></i></div>
                    <h4 class="text-white fw-bold mb-3">Smart Matching</h4>
                    <p class="text-visible-muted">Intelligent cross-matching algorithms for rare blood types and high-priority trauma surgeries using AI-driven HLA compatibility checks.</p>
                </div>
            </div>
            <div class="col-md-4 animate-up" style="animation-delay: 0.3s;">
                <div class="feature-box text-center text-md-start">
                    <div class="feature-icon mx-auto mx-md-0"><i class="fa-solid fa-file-invoice-dollar"></i></div>
                    <h4 class="text-white fw-bold mb-3">Ethical Sourcing</h4>
                    <p class="text-visible-muted">Strict verification audits to ensure every donation is voluntary and transparently coordinated, preventing any commercialization of human tissue.</p>
                </div>
            </div>
            <div class="col-md-6 animate-up" style="animation-delay: 0.4s;">
                <div class="feature-box text-center text-md-start">
                    <div class="feature-icon mx-auto mx-md-0"><i class="fa-solid fa-certificate"></i></div>
                    <h4 class="text-white fw-bold mb-3">Verified Certificates</h4>
                    <p class="text-visible-muted">Instant, cryptographic digital certificates for every successful donation. These can be shared directly with employers or for public record.</p>
                </div>
            </div>
            <div class="col-md-6 animate-up" style="animation-delay: 0.5s;">
                <div class="feature-box text-center text-md-start">
                    <div class="feature-icon mx-auto mx-md-0"><i class="fa-solid fa-hospital"></i></div>
                    <h4 class="text-white fw-bold mb-3">Live Integration</h4>
                    <p class="text-visible-muted">Direct API connection with hospital management systems (HMS) for real-time stock availability updates and critical shortage alerts.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
