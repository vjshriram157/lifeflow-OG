<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bloodbank.util.FirebaseConfig,com.google.cloud.firestore.*,com.google.api.core.ApiFuture,java.util.List,java.util.Map,java.util.HashMap,java.util.UUID" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Health Blog | LifeFlow</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #0f172a !important; color: #f8fafc !important; font-family: 'Inter', sans-serif; padding-top: 100px; }
        h1, h2, h3, .brand-text { font-family: 'Outfit', sans-serif; }
        .blog-hero { padding: 60px 0; background: radial-gradient(circle at 20% 50%, rgba(225, 29, 72, 0.05) 0%, transparent 50%); }
        .glass-card { background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(15px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 20px; transition: all 0.3s ease; overflow: hidden; height: 100%; border-radius: 30px; }
        .glass-card:hover { border-color: rgba(225, 29, 72, 0.3); transform: translateY(-5px); background: rgba(255, 255, 255, 0.06); }
        .blog-img { height: 220px; object-fit: cover; width: 100%; border-bottom: 1px solid rgba(255, 255, 255, 0.1); transition: 0.5s; }
        .glass-card:hover .blog-img { transform: scale(1.05); }
        .category-badge { background: rgba(225, 29, 72, 0.15); color: #e11d48; padding: 6px 16px; border-radius: 50px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; }
        .text-visible-muted { color: #94a3b8 !important; }
        .read-more-btn { position: relative; color: #e11d48 !important; font-weight: 700; text-decoration: none; padding-right: 25px; transition: 0.3s; }
        .read-more-btn i { position: absolute; right: 0; top: 50%; transform: translateY(-50%); transition: 0.3s; }
        .read-more-btn:hover { color: #fb7185 !important; }
        .read-more-btn:hover i { right: -5px; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<section class="blog-hero animate-up">
    <div class="container text-center">
        <h1 class="display-4 fw-bold text-white mb-3">Health & Recovery</h1>
        <p class="lead text-visible-muted mx-auto" style="max-width: 600px;">Expert insights, donor stories, and the latest in transfusion technology.</p>
    </div>
</section>

<section class="pb-5">
    <div class="container">
        <div class="row g-4">
        <%
            try {
                Firestore db = FirebaseConfig.getFirestore();
                ApiFuture<QuerySnapshot> future = db.collection("health_blogs").orderBy("timestamp", Query.Direction.DESCENDING).get();
                List<QueryDocumentSnapshot> docs = future.get().getDocuments();
                
                // --- AUTO SEEDING LOGIC FOR MIGRATION ---
                if (docs.isEmpty()) {
                    String[][] initialBlogs = {
                        {"Superfoods for Donors", "Nutrition", "https://images.unsplash.com/photo-1490645935967-10de6ba17061?q=80&w=1000&auto=format&fit=crop", "Discover the optimal meal plan to maintain high iron levels and recover instantly after donating...", "<p class=\"lead text-white mb-4\">Maintaining a stable blood supply is a global challenge that requires both cutting-edge technology and a community of healthy, dedicated donors.</p><h2 class=\"text-white mt-5 mb-3\">1. The Science of Recovery</h2><p>When you donate blood, your body works immediately to replace the lost fluids and cells. For most donors, this process is seamless, but it can be enhanced through specific nutritional choices. Increasing your intake of iron-rich foods such as spinach, lentils, and lean meats in the 48 hours following a donation is critical for hemoglobin synthesis.</p>"},
                        {"Future of Transfusions", "Technology", "https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=1000&auto=format&fit=crop", "How LifeFlow's AI-driven distribution system is reducing waste and saving thousands of critical minutes...", "<p class=\"lead text-white mb-4\">Technology is bridging the gap between donors and patients.</p><h2 class=\"text-white mt-5 mb-3\">AI Optimized Routing</h2><p>By leveraging real-time traffic data and historic delivery metrics, the system calculates the fastest route for blood transport, cutting transit times by 35% in dense urban topographies.</p>"},
                        {"Survival Stories", "Impact", "https://images.unsplash.com/photo-1542884748-2b87b36c6b90?q=80&w=1000&auto=format&fit=crop", "A firsthand account of how a timely AB- donation rescued a trauma patient within minutes...", "<p class=\"lead text-white mb-4\">Every drop tells a story of survival.</p><blockquote class=\"p-4 my-5 card border-0 border-start border-danger border-4\" style=\"background: rgba(225, 29, 72, 0.05);\"><p class=\"h4 fst-italic text-white\">\"A single donation isn't just a 450ml contribution; it's a lifeline that supports trauma surgery, cancer treatment, and chronic disease management simultaneously.\"</p></blockquote><p>Our platform is built on the principle of voluntary, non-commercial donation. We believe that by providing donors with real-time feedback on how their contribution saved a life, we can foster a sustainable culture of giving.</p>"}
                    };
                    
                    for (String[] seed : initialBlogs) {
                        String newId = UUID.randomUUID().toString();
                        Map<String, Object> blogData = new HashMap<>();
                        blogData.put("id", newId);
                        blogData.put("title", seed[0]);
                        blogData.put("category", seed[1]);
                        blogData.put("imageUrl", seed[2]);
                        blogData.put("excerpt", seed[3]);
                        blogData.put("content", seed[4]);
                        blogData.put("author", "LifeFlow Database Import");
                        blogData.put("timestamp", com.google.cloud.Timestamp.now());
                        db.collection("health_blogs").document(newId).set(blogData).get();
                    }
                    
                    // Re-fetch after seeding
                    docs = db.collection("health_blogs").orderBy("timestamp", Query.Direction.DESCENDING).get().get().getDocuments();
                }
                
                // --- RENDERING ---
                int delay = 1;
                for (QueryDocumentSnapshot doc : docs) {
                    String id = doc.getString("id");
                    String title = doc.getString("title");
                    String cat = doc.getString("category");
                    String img = doc.getString("imageUrl");
                    String excerpt = doc.getString("excerpt");
        %>
            <!-- Dynamic Article -->
            <div class="col-md-4 animate-up" style="animation-delay: 0.<%=delay%>s;">
                <div class="glass-card">
                    <img src="<%= img != null ? img : "" %>" class="blog-img" alt="Blog Image">
                    <div class="p-4">
                        <span class="category-badge mb-3 d-inline-block"><%= cat != null ? cat : "Article" %></span>
                        <h4 class="text-white fw-bold mb-3"><%= title %></h4>
                        <p class="text-visible-muted small mb-4"><%= excerpt != null ? excerpt : "Read the full article inside to learn more." %></p>
                        <a href="blog_detail.jsp?id=<%= id %>" class="read-more-btn">Read More <i class="fa-solid fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        <%
                    delay++;
                }
            } catch (Exception e) {
                out.print("<div class='col-12 text-center text-danger py-5'>An error occurred loading the Health Resource Engine.</div>");
                e.printStackTrace();
            }
        %>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
