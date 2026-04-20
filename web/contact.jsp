<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Support Center | LifeFlow Premium</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --brand-primary: #e11d48;
            --brand-accent: #fb7185;
            --brand-bg: #0f172a;
            --glass-bg: rgba(30, 41, 59, 0.7);
            --glass-border: rgba(255, 255, 255, 0.1);
        }

        body {
            background: radial-gradient(circle at top right, #1e1b4b, #0f172a 50%, #1e1b4b);
            color: #f8fafc;
            font-family: 'Inter', sans-serif;
            overflow-x: hidden;
            min-height: 100vh;
        }

        /* Mesh Gradient Background Decor */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 0% 0%, rgba(225, 29, 72, 0.05) 0%, transparent 40%),
                radial-gradient(circle at 100% 100%, rgba(59, 130, 246, 0.05) 0%, transparent 40%);
            z-index: -1;
            pointer-events: none;
        }

        h1, h2, h3, h4, .brand-text {
            font-family: 'Outfit', sans-serif;
        }

        /* Standard Navbar */
        .glass-nav {
            background: rgba(15, 23, 42, 0.8);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--glass-border);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 2.5rem;
            transition: all 0.3s ease;
        }

        .btn-brand {
            background: linear-gradient(135deg, var(--brand-primary), #be123c);
            color: white;
            border: none;
            border-radius: 50px;
            padding: 12px 32px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-brand:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px -5px rgba(225, 29, 72, 0.4);
            color: white;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            color: white;
            padding: 12px 18px;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.06);
            border-color: var(--brand-primary);
            box-shadow: none;
            color: white;
        }

        .text-visible-muted {
            color: #94a3b8 !important;
        }

        .animate-up {
            animation: fadeInUp 0.8s ease-out forwards;
            opacity: 0;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .contact-icon {
            width: 60px;
            height: 60px;
            background: rgba(225, 29, 72, 0.1);
            color: var(--brand-primary);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>

<!-- Navigation -->
<nav class="glass-nav">
    <div class="container d-flex justify-content-between align-items-center">
        <a class="d-flex align-items-center text-decoration-none" href="index.jsp">
            <i class="fa-solid fa-heart-pulse text-brand-primary fs-3 me-2" style="color:var(--brand-primary)"></i>
            <span class="brand-text fw-bold text-white fs-4">LifeFlow</span>
        </a>
        <div class="d-flex gap-3">
            <a href="login.jsp" class="btn btn-outline-light rounded-pill px-4 border-opacity-25">Login</a>
            <a href="register.jsp" class="btn btn-brand">Sign Up</a>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="py-5">
    <div class="container py-5 text-center">
        <div class="animate-up">
            <h1 class="display-3 fw-bold mb-4">Support <span style="color:var(--brand-primary)">Center</span></h1>
            <p class="text-visible-muted fs-5 mx-auto" style="max-width: 600px;">
                Have questions or need assistance? Our administration team is ready to help you save lives more effectively.
            </p>
        </div>
    </div>
</section>

<!-- Main Content -->
<section class="pb-5 mb-5 container">
    <div class="row g-5">
        <!-- Info Column -->
        <div class="col-lg-4 animate-up" style="animation-delay: 0.1s;">
            <div class="glass-card mb-4">
                <div class="contact-icon"><i class="fa-solid fa-envelope"></i></div>
                <h5 class="fw-bold">Email Us</h5>
                <p class="text-visible-muted mb-0">lifeflowad@gmail.com</p>
                <p class="text-visible-muted small">Response within 24 hours</p>
            </div>
            <div class="glass-card mb-4">
                <div class="contact-icon"><i class="fa-solid fa-phone"></i></div>
                <h5 class="fw-bold">Emergency Hotline</h5>
                <p class="text-visible-muted mb-0">1800-LIFE-FLOW</p>
                <p class="text-visible-muted small">Available 24/7 for urgent requests</p>
            </div>
            <div class="glass-card">
                <div class="contact-icon"><i class="fa-solid fa-location-dot"></i></div>
                <h5 class="fw-bold">Headquarters</h5>
                <p class="text-visible-muted mb-0">Chennai, Tamil Nadu</p>
                <p class="text-visible-muted small">South India Network Hub</p>
            </div>
        </div>

        <!-- Form Column -->
        <div class="col-lg-8 animate-up" style="animation-delay: 0.2s;">
            <div class="glass-card">
                <% 
                    String success = (String) session.getAttribute("contactSuccess");
                    String error = (String) session.getAttribute("contactError");
                    if (success != null) { 
                %>
                    <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-4 mb-4">
                        <i class="fa-solid fa-circle-check me-2"></i> <%= success %>
                    </div>
                <% session.removeAttribute("contactSuccess"); } %>

                <% if (error != null) { %>
                    <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-4 mb-4">
                        <i class="fa-solid fa-circle-exclamation me-2"></i> <%= error %>
                    </div>
                <% session.removeAttribute("contactError"); } %>

                <form action="${pageContext.request.contextPath}/ContactServlet" method="POST">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-visible-muted">FULL NAME</label>
                            <input type="text" name="name" class="form-control" placeholder="John Doe" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-visible-muted">EMAIL ADDRESS</label>
                            <input type="email" name="email" class="form-control" placeholder="john@example.com" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-visible-muted">HOW CAN WE HELP?</label>
                            <textarea name="message" class="form-control" rows="6" placeholder="Describe your request or issue..." required></textarea>
                        </div>
                        <div class="col-12 mt-4 text-center">
                            <button type="submit" class="btn btn-brand btn-lg px-5 w-100">Send Message</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="py-5 border-top border-secondary border-opacity-10">
    <div class="container text-center">
        <p class="text-visible-muted small mb-0">© 2026 LifeFlow. Empowering the future of blood donation.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
