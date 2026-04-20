<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bloodbank.util.FirebaseConfig,com.google.cloud.firestore.*,com.google.api.core.ApiFuture,java.util.Map,java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Article Detail | LifeFlow Health Hub</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #0f172a !important; color: #f8fafc !important; font-family: 'Inter', sans-serif; padding-top: 100px; line-height: 1.8; }
        h1, h2, h3, .brand-text { font-family: 'Outfit', sans-serif; letter-spacing: -0.5px; }
        .article-hero { height: 400px; width: 100%; object-fit: cover; border-radius: 40px; margin-bottom: -100px; box-shadow: 0 20px 40px rgba(0,0,0,0.5); border: 1px solid rgba(255,255,255,0.1); }
        .content-card { background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 40px; padding: 60px; margin-bottom: 80px; position: relative; z-index: 10; }
        .category-badge { background: rgba(225, 29, 72, 0.2); color: #fb7185; padding: 8px 20px; border-radius: 50px; font-size: 0.85rem; font-weight: 700; text-transform: uppercase; margin-bottom: 2rem; display: inline-block; }
        .text-visible-muted { color: #94a3b8 !important; }
        .article-body { font-size: 1.15rem; color: #cbd5e1; }
        .sticky-share { position: sticky; top: 120px; }
        .share-link { width: 50px; height: 50px; background: rgba(255,255,255,0.05); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; text-decoration: none; transition: 0.3s; border: 1px solid rgba(255,255,255,0.1); margin-bottom: 15px; }
        .share-link:hover { background: #e11d48; border-color: #e11d48; transform: scale(1.1); }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container">
    <%
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("blog.jsp");
            return;
        }
        
        String title = "Article Not Found";
        String category = "Unknown";
        String img = "";
        String author = "System";
        String content = "<p>The requested health resource could not be located in the database.</p>";
        String dateStr = "N/A";
        
        try {
            Firestore db = FirebaseConfig.getFirestore();
            DocumentSnapshot doc = db.collection("health_blogs").document(id).get().get();
            
            if (doc.exists()) {
                title = doc.getString("title");
                category = doc.getString("category");
                img = doc.getString("imageUrl");
                author = doc.getString("author");
                content = doc.getString("content");
                
                com.google.cloud.Timestamp ts = doc.getTimestamp("timestamp");
                if (ts != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("MMMM d, yyyy");
                    dateStr = sdf.format(ts.toDate());
                }
            } else {
                response.sendRedirect("blog.jsp");
                return;
            }
        } catch (Exception e) {
            content = "<p class='text-danger'>Error retrieving article: " + e.getMessage() + "</p>";
        }
    %>
    
    <img src="<%=img%>" class="article-hero animate-up" alt="Hero">
    
    <div class="row mt-5 pt-5">
        <div class="col-lg-1 d-none d-lg-block">
            <div class="sticky-share animate-up" style="animation-delay: 0.3s;">
                <a href="javascript:void(0)" class="share-link"><i class="fa-brands fa-facebook-f"></i></a>
                <a href="javascript:void(0)" class="share-link"><i class="fa-brands fa-twitter"></i></a>
                <a href="javascript:void(0)" class="share-link"><i class="fa-brands fa-linkedin-in"></i></a>
            </div>
        </div>
        
        <div class="col-lg-10">
            <div class="content-card animate-up" style="animation-delay: 0.1s;">
                <span class="category-badge"><%=category%></span>
                <h1 class="display-3 fw-bold text-white mb-4"><%=title%></h1>
                <div class="d-flex align-items-center gap-3 mb-5 border-bottom border-secondary pb-4">
                    <img src="https://ui-avatars.com/api/?name=<%=author.replace(" ", "+")%>&background=e11d48&color=fff" class="rounded-circle" width="45" alt="Author">
                    <div>
                        <div class="fw-bold text-white"><%=author%></div>
                        <div class="small text-visible-muted">Published: <%=dateStr%></div>
                    </div>
                </div>
                
                <div class="article-body">
                    <%=content%>
                </div>
                
                <div class="mt-5 pt-4 text-center border-top border-secondary border-opacity-25 mt-5 pt-5">
                    <a href="blog.jsp" class="btn btn-outline-premium rounded-pill px-5 py-3 fw-bold">
                        <i class="fa-solid fa-arrow-left me-2"></i> Back to Resource Center
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
