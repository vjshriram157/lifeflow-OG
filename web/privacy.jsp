<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Privacy Policy | LifeFlow</title>
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
            <h1 class="display-3 fw-bold text-white mb-4">Privacy Policy</h1>
            <p class="lead mx-auto" style="max-width: 700px; color: #94a3b8;">How LifeFlow secures your personal health identifiers and medical records within our autonomous healthcare network.</p>
        </div>

        <div class="legal-card animate-up delay-1">
            <div class="legal-section">
                <h2><i class="fa-solid fa-user-shield"></i> 1. Medical Data Sovereignty</h2>
                <p>Your blood type, donation history, and health screenings are considered **highly sensitive** information. We adhere to localized healthcare standards:</p>
                <ul>
                    <li>All patient records are encrypted at rest using **AES-256 standard encryption**.</li>
                    <li>Access to donor records is audited and restricted to authorized medical administrators at partner hospitals.</li>
                    <li>We never store your direct government ID numbers locally; we use verified hash tokens for account validation.</li>
                </ul>
            </div>

            <div class="legal-section">
                <h2><i class="fa-solid fa-map-location-dot"></i> 2. Geolocation & Proximity Data</h2>
                <p>To enable the "Find Blood" features, we use transient geolocation data:</p>
                <ul>
                    <li>Your precise location is used only to calculate distance to the nearest blood bank or donor pool.</li>
                    <li>We do not log a permanent history of your movements.</li>
                    <li>You can opt-out of sharing location data, though this will disable the emergency broadcast reception in your immediate vicinity.</li>
                </ul>
            </div>

            <div class="legal-section">
                <h2><i class="fa-solid fa-cloud-arrow-up"></i> 3. Security Infrastructure</h2>
                <p>LifeFlow is hosted on a secure infrastructure powered by Google Firebase:</p>
                <ul>
                    <li><strong>Realtime Database Security:</strong> We use granular Firestore Security Rules to prevent unauthorized read/write access.</li>
                    <li><strong>Encrypted Transport:</strong> All data moving between your browser and our servers is protected by SSL/TLS encryption.</li>
                    <li><strong>Anonymization:</strong> For analytics and demand prediction (AI), we use anonymized data sets that cannot be traced back to individual donors.</li>
                </ul>
            </div>

            <div class="legal-section">
                <h2><i class="fa-solid fa-user-minus"></i> 4. Right to Erasure</h2>
                <p>You have the right to request the permanent deletion of your donor profile:</p>
                <ul>
                    <li>Upon request, all personal contact details and location history will be erased from our active servers within 72 hours.</li>
                    <li>Medical transaction logs (donation history) may be kept in an anonymized format for clinical audit purposes as required by national health laws.</li>
                </ul>
            </div>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
