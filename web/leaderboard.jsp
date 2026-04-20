<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bloodbank.util.FirebaseConfig,com.google.cloud.firestore.*,com.google.api.core.ApiFuture,java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LifeSaver Leaderboards | LifeFlow</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        body { background-color: #0f172a !important; color: #f8fafc !important; font-family: 'Inter', sans-serif; padding-top: 100px; }
        h1, h2, h3, .brand-text { font-family: 'Outfit', sans-serif; }
        .hero-section { padding: 80px 0 60px 0; background: radial-gradient(circle at 50% 50%, rgba(225, 29, 72, 0.1) 0%, transparent 60%); text-align: center; }
        .glass-card { background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 30px; overflow: hidden; }
        
        .rank-row { padding: 20px 30px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); transition: 0.3s; display: flex; align-items: center; justify-content: space-between; gap: 20px; }
        .rank-row:hover { background: rgba(255, 255, 255, 0.06); transform: translateX(10px); }
        .rank-row:last-child { border-bottom: none; }
        
        .rank-number { font-family: 'Outfit', sans-serif; font-size: 2rem; font-weight: 800; color: rgba(255, 255, 255, 0.2); width: 60px; text-align: center; }
        .rank-number.top-1 { color: #fbbf24; text-shadow: 0 0 20px rgba(251, 191, 36, 0.5); font-size: 2.5rem; }
        .rank-number.top-2 { color: #94a3b8; font-size: 2.2rem; }
        .rank-number.top-3 { color: #b45309; font-size: 2.2rem; }
        
        .donor-avatar { width: 60px; height: 60px; border-radius: 50%; border: 2px solid rgba(255,255,255,0.1); }
        .donor-info { flex-grow: 1; }
        .donor-name { font-family: 'Outfit', sans-serif; font-size: 1.3rem; font-weight: 600; color: #fff; margin-bottom: 2px; }
        .donor-meta { font-size: 0.9rem; color: #94a3b8; }
        
        .score-pill { background: rgba(225, 29, 72, 0.15); border: 1px solid rgba(225, 29, 72, 0.3); color: #fb7185; padding: 10px 25px; border-radius: 50px; font-weight: 700; font-family: 'Outfit', sans-serif; font-size: 1.2rem; text-align: center; min-width: 120px; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<section class="hero-section fade-in-up">
    <div class="container">
        <div class="mb-4 d-inline-block p-3 rounded-circle" style="background: rgba(251, 191, 36, 0.1);">
            <i class="fa-solid fa-trophy" style="font-size: 3rem; color: #fbbf24; filter: drop-shadow(0 0 20px rgba(251,191,36,0.5));"></i>
        </div>
        <h1 class="display-3 fw-bold text-white mb-3">Lifesaver <span class="text-gradient">Leaderboard</span></h1>
        <p class="lead text-secondary mx-auto" style="max-width: 600px;">
            Recognizing the top contributors across the network. Because of these heroes, countless lives are saved every single day.
        </p>
    </div>
</section>

<section class="pb-5 mb-5 fade-in-up delay-100">
    <div class="container" style="max-width: 900px;">
        <div class="glass-card shadow-lg py-3">
        <%
            try {
                Firestore db = FirebaseConfig.getFirestore();
                // Query users where role = DONOR and score > 0, sorted by impact_score DESC, limit 10
                ApiFuture<QuerySnapshot> future = db.collection("users")
                    .whereEqualTo("role", "DONOR")
                    .orderBy("impact_score", Query.Direction.DESCENDING)
                    .limit(10)
                    .get();
                
                List<QueryDocumentSnapshot> docs = future.get().getDocuments();
                
                if (docs.isEmpty()) {
        %>
            <div class="text-center py-5">
                <i class="fa-solid fa-medal text-muted mb-3" style="font-size: 3rem; opacity: 0.5;"></i>
                <h4 class="text-white">Awaiting Our First Heroes</h4>
                <p class="text-secondary">The leaderboard will update as soon as donations are completed.</p>
            </div>
        <%
                } else {
                    int rank = 1;
                    for (QueryDocumentSnapshot doc : docs) {
                        String fullName = doc.getString("full_name");
                        String firstName = fullName != null ? fullName.split(" ")[0] : "Anonymous";
                        String city = doc.getString("city");
                        Long score = doc.getLong("impact_score");
                        Long donations = doc.getLong("donation_count");
                        
                        if (score == null) score = 0L;
                        if (donations == null) donations = 0L;
                        
                        if (score == 0) continue; // Skip 0 score donors if they bypass the query somehow
                        
                        String rankClass = "";
                        if(rank == 1) rankClass = "top-1"; else if(rank == 2) rankClass = "top-2"; else if(rank == 3) rankClass = "top-3";
        %>
            <div class="rank-row">
                <div class="rank-number <%=rankClass%>">#<%=rank%></div>
                <img src="https://ui-avatars.com/api/?name=<%=firstName%>&background=0f172a&color=fff&rounded=true&bold=true&size=128" class="donor-avatar" alt="Avatar">
                <div class="donor-info">
                    <div class="donor-name"><%=firstName%></div>
                    <div class="donor-meta"><i class="fa-solid fa-location-dot me-1 text-danger"></i> <%=city != null ? city : "LifeFlow Network"%> &bull; <%=donations%> Donations</div>
                </div>
                <div class="score-pill">
                    <%=score%> <span class="d-block small" style="font-size:0.7rem; font-weight: 500; opacity:0.8; margin-top:-2px;">Points</span>
                </div>
            </div>
        <%
                        rank++;
                    }
                }
            } catch (Exception e) {
                out.print("<div class='text-center py-5 text-danger'><i class='fa-solid fa-triangle-exclamation mb-3 fs-1'></i><h4>Data Error</h4><p>Could not retrieve rank data: " + e.getMessage() + "</p></div>");
            }
        %>
        </div>
        
        <div class="text-center mt-5">
            <h5 class="text-white mb-3">Want to see your name here?</h5>
            <a href="register.jsp" class="btn btn-premium rounded-pill px-5 py-3 fw-bold shadow-lg">Become a Donor Today</a>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
