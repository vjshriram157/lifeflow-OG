<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error Encountered | LifeFlow</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;800&display=swap" rel="stylesheet">
    <style>
        body { background-color: #0f172a !important; color: #f8fafc !important; font-family: 'Inter', sans-serif; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; }
        .error-card { background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(20px); border: 1px solid rgba(225, 29, 72, 0.2); border-radius: 30px; text-align: center; padding: 60px 40px; max-width: 600px; width: 100%; box-shadow: 0 20px 50px rgba(0,0,0,0.5); position: relative; overflow: hidden; }
        .error-card::before { content: ""; position: absolute; top: 0; left: 0; right: 0; height: 5px; background: linear-gradient(90deg, #e11d48, #fb7185); }
        .error-code { font-family: 'Outfit', sans-serif; font-size: 8rem; font-weight: 800; line-height: 1; background: linear-gradient(135deg, #e11d48, #f43f5e); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 20px; text-shadow: 0 10px 30px rgba(225, 29, 72, 0.3); }
        .error-icon { font-size: 4rem; color: #e11d48; margin-bottom: 20px; opacity: 0.8; }
        .brand-text { font-family: 'Outfit', sans-serif; }
    </style>
</head>
<body>

<div class="error-card mx-3">
    <i class="fa-solid fa-triangle-exclamation error-icon"></i>
    <%
        // Logic to determine error code
        Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
        String message = (String) request.getAttribute("javax.servlet.error.message");
        if (statusCode == null) statusCode = 500;
        
        String title = "Connection Error";
        String description = "We encountered an unexpected issue while routing your request.";
        
        if (statusCode == 404) {
            title = "Page Not Found";
            description = "The medical directory or resource you are looking for has been moved or no longer exists.";
        } else if (statusCode == 403) {
            title = "Access Denied";
            description = "You do not have the required clearance to view this administrative resource.";
        } else if (statusCode == 500) {
            title = "System Fault";
            description = "Our backbone servers experienced a fault while processing. Our technicians have been notified.";
        }
    %>
    <div class="error-code"><%= statusCode %></div>
    <h2 class="fw-bold text-white mb-3"><%= title %></h2>
    <p class="text-secondary mb-5 fs-5"><%= description %></p>
    
    <div class="d-flex justify-content-center gap-3">
        <button onclick="window.history.back()" class="btn btn-outline-premium rounded-pill px-4 py-2 fw-bold">
            <i class="fa-solid fa-arrow-left me-2"></i> Go Back
        </button>
        <a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-premium rounded-pill px-4 py-2 fw-bold">
            <i class="fa-solid fa-house me-2"></i> Return Home
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
