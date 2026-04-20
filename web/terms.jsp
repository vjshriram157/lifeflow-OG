<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Terms & Conditions | LifeFlow</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-deep: #0f172a;
            --glass-card: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(255, 255, 255, 0.1);
            --text-slate: #f1f5f9;
            --text-muted: #94a3b8;
            --brand-danger: #e11d48;
        }

        body {
            background-color: #0f172a !important;
            color: #f1f5f9 !important;
            font-family: 'Inter', sans-serif;
            overflow-x: hidden;
            padding-top: 100px;
        }

        h1, h2, h3, .brand-text {
            font-family: 'Outfit', sans-serif;
            color: #ffffff !important;
        }

        .main-content {
            padding: 80px 0;
            background-color: #0f172a;
        }

        .legal-card {
            background: rgba(255, 255, 255, 0.03) !important;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            border-radius: 24px;
            padding: 3rem;
            margin-bottom: 2rem;
        }

        .legal-section {
            margin-bottom: 3rem;
        }

        .legal-section h2 {
            color: #ffffff !important;
            font-weight: 700;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .legal-section h2 i {
            color: #e11d48 !important;
            font-size: 1.5rem;
        }

        .legal-section p, .legal-section li {
            color: #94a3b8 !important;
            line-height: 1.8;
            font-size: 1.05rem;
        }

        .legal-section ul {
            padding-left: 1.2rem;
        }

        .legal-section li {
            margin-bottom: 0.8rem;
        }

        .last-updated {
            color: #e11d48 !important;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.85rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<main class="main-content">
    <div class="container">
        <div class="text-center mb-5 animate-up">
            <div class="last-updated">Last Updated: April 20, 2026</div>
            <h1 class="display-3 fw-bold text-white mb-4">Terms of Service</h1>
            <p class="lead mx-auto" style="max-width: 700px; color: #94a3b8;">Welcome to the LifeFlow Network. By using this platform, you agree to uphold these standards of community safety and ethics.</p>
        </div>

        <div class="legal-card animate-up delay-1">
            <div class="legal-section">
                <h2><i class="fa-solid fa-clipboard-check"></i> 1. Eligibility & Registrations</h2>
                <p>Registering as a donor on LifeFlow carries medical and social responsibility:</p>
                <ul>
                    <li>You must be of legal age (18+) and meet the weight/health criteria set by national health guidelines.</li>
                    <li>Accounts must be created using true, verifiable contact details. Multiple accounts for a single user are prohibited.</li>
                    <li>Misrepresentation of your medical history or blood group is a strictly terminable offense.</li>
                </ul>
            </div>

            <div class="legal-section">
                <h2><i class="fa-solid fa-handshake-angle"></i> 2. Platform Ethics</h2>
                <p>LifeFlow is a strictly **non-commercial** health initiative:</p>
                <ul>
                    <li>The sale of blood or blood products is illegal. LifeFlow will report any user attempting to solicit payment for donations to the appropriate law enforcement.</li>
                    <li>Users should interact with hospitals and other donors with professional courtesy. Harassment or misuse of contact details is strictly prohibited.</li>
                    <li>Our locator search is for emergency use only. Do not use the platform for industrial or survey-based data scraping.</li>
                </ul>
            </div>

            <div class="legal-section">
                <h2><i class="fa-solid fa-file-contract"></i> 3. Liability & Medical Advice</h2>
                <p>LifeFlow provides the technology for coordination; we do not provide medical services:</p>
                <ul>
                    <li>All donation procedures are elective. You should only donate at licensed clinics and hospitals listed on our platform.</li>
                    <li>LifeFlow is not responsible for complications arising from a donation. You are advised to follow the post-donation recovery protocols provided by the medical staff.</li>
                    <li>The medical information shared on our "Health Blog" is for informational purposes and does not replace professional medical advice.</li>
                </ul>
            </div>

            <div class="legal-section">
                <h2><i class="fa-solid fa-gavel"></i> 4. Termination of Access</h2>
                <p>We reserve the right to suspend or terminate access if:</p>
                <ul>
                    <li>A user fails to show up for multiple confirmed emergency appointments without prior notice.</li>
                    <li>A user provides fraudulent certificates or medical IDs.</li>
                    <li>A user violates the data security of the platform.</li>
                </ul>
            </div>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
