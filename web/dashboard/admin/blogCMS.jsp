<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bloodbank.util.FirebaseConfig,com.google.cloud.firestore.*,com.google.api.core.ApiFuture,java.util.List,java.util.Map" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Blog CMS | Admin | LifeFlow</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/overrides_v3.css" rel="stylesheet">
    <style>
        /* Ensure btn-premium is always visible regardless of context */
        .btn-premium {
            background: linear-gradient(135deg, #e11d48, #9f1239) !important;
            color: #fff !important;
            border: none !important;
        }
        .btn-premium:hover, .btn-premium:focus { color: #fff !important; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR -->
    <div class="sidebar p-4">
        <a href="<%=request.getContextPath()%>/index.jsp" class="brand mb-5 text-decoration-none">
            <i class="fa-solid fa-droplet text-danger"></i> Life<span class="text-white">Flow</span>
            <span class="badge bg-danger ms-2 fs-6 rounded-pill" style="font-family:'Inter'; letter-spacing:0">Admin</span>
        </a>
        <ul class="nav flex-column gap-2 mt-4">
            <li><a href="home.jsp" class="nav-link"><i class="fa-solid fa-border-all"></i> Dashboard</a></li>
            <li><a href="<%=request.getContextPath()%>/adminPendingApprovals.jsp" class="nav-link"><i class="fa-solid fa-user-check"></i> Approvals</a></li>
            <li><a href="emergencyBroadcast.jsp" class="nav-link"><i class="fa-solid fa-tower-broadcast"></i> Emergencies</a></li>
            <li><a href="analytics.jsp" class="nav-link"><i class="fa-solid fa-chart-line"></i> Analytics</a></li>
            <li><a href="adminDirectory.jsp" class="nav-link"><i class="fa-solid fa-address-book"></i> User Directory</a></li>
            <li><a href="blogCMS.jsp" class="nav-link active"><i class="fa-solid fa-pen-nib"></i> Content Management</a></li>
        </ul>
        <div class="mt-auto pt-5 pb-3">
            <a href="<%=request.getContextPath()%>/LogoutServlet" class="btn btn-outline-light btn-sm w-100 rounded-pill"><i class="fa-solid fa-right-from-bracket me-2"></i>Sign Out</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="container-fluid p-4 p-md-5 w-100">
        <div class="d-flex justify-content-between align-items-center mb-5 fade-in-up">
            <div>
                <h2 class="fw-bold mb-1">Health Blog Engine</h2>
                <p class="text-muted">Publish, edit, and orchestrate platform news and medical insights.</p>
            </div>
            <button class="btn btn-premium rounded-pill fw-bold" onclick="toggleComposer()">
                <i class="fa-solid fa-plus me-2"></i> New Article
            </button>
        </div>
        
        <!-- COMPOSER SECTION (HIDDEN BY DEFAULT) -->
        <div id="composerCard" class="card card-modern border-0 mb-4 fade-in-up d-none">
            <div class="card-body p-4 p-md-5">
                <h4 class="fw-bold text-dark mb-4"><i class="fa-solid fa-pen-to-square text-danger me-2"></i> Compose Article</h4>
                <form id="blogForm">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label text-muted small fw-bold">Article Title (Required)</label>
                            <input type="text" id="blogTitle" class="form-control form-control-lg bg-light border-0 px-4" placeholder="e.g. Superfoods for Donors" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted small fw-bold">Category</label>
                            <select id="blogCategory" class="form-select form-control-lg bg-light border-0 px-4">
                                <option value="Wellness">Wellness</option>
                                <option value="Nutrition">Nutrition</option>
                                <option value="Technology">Technology</option>
                                <option value="Impact">Impact Stories</option>
                                <option value="Announcements">Announcements</option>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label text-muted small fw-bold">Cover Image URL (Optional)</label>
                            <input type="url" id="blogImage" class="form-control form-control-lg bg-light border-0 px-4" placeholder="https://images.unsplash.com/... (Defaults to standard image)">
                        </div>
                        <div class="col-md-12">
                            <label class="form-label text-muted small fw-bold">Short Excerpt (For Card Display)</label>
                            <textarea id="blogExcerpt" class="form-control bg-light border-0 px-4 py-3" rows="2" placeholder="A brief summary of the article..."></textarea>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label text-muted small fw-bold">Main Content (HTML Supported)</label>
                            <textarea id="blogContent" class="form-control bg-light border-0 px-4 py-3" rows="8" placeholder="<h2>Subheading</h2> <p>Start writing...</p>" required></textarea>
                            <div class="form-text mt-2"><i class="fa-brands fa-html5 text-secondary"></i> You can use basic HTML tags like &lt;h2&gt;, &lt;p&gt;, &lt;b&gt;, &lt;blockquote&gt; for formatting.</div>
                        </div>
                    </div>
                    <div class="mt-4 text-end">
                        <button type="button" class="btn btn-outline-secondary rounded-pill px-4 me-2" onclick="toggleComposer()">Cancel</button>
                        <button type="button" id="btnPublish" class="btn btn-premium rounded-pill px-5 fw-bold shadow-sm" onclick="publishBlog()">
                            <i class="fa-solid fa-paper-plane me-2"></i> Publish LIVE
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card card-modern border-0 mb-4 fade-in-up delay-100">
            <div class="card-body p-4 p-md-5">
                <h4 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-layer-group text-danger me-2"></i> Published Articles</h4>
                <div class="table-responsive">
                    <table class="table table-modern align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th>Article Info</th>
                                <th>Category</th>
                                <th>Author</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>

                        <%
                            boolean any = false;
                            try {
                                Firestore db = FirebaseConfig.getFirestore();
                                ApiFuture<QuerySnapshot> future = db.collection("health_blogs").orderBy("timestamp", Query.Direction.DESCENDING).get();
                                List<QueryDocumentSnapshot> docs = future.get().getDocuments();

                                for (QueryDocumentSnapshot doc : docs) {
                                    any = true;
                                    String id = doc.getString("id");
                                    String title = doc.getString("title");
                                    String cat = doc.getString("category");
                                    String author = doc.getString("author");
                                    String img = doc.getString("imageUrl");
                        %>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="<%= img != null ? img : "" %>" style="width: 50px; height: 50px; object-fit: cover; border-radius: 10px;" alt="...">
                                        <div>
                                            <div class="fw-bold text-dark"><%= title %></div>
                                            <div class="text-muted small"><a href="<%=request.getContextPath()%>/blog_detail.jsp?id=<%=id%>" target="_blank" class="text-decoration-none text-danger"><i class="fa-solid fa-up-right-from-square me-1"></i> View Live</a></div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-danger rounded-pill px-3 shadow-sm"><%= cat %></span>
                                </td>
                                <td class="text-muted"><i class="fa-solid fa-user-doctor me-1"></i> <%= author %></td>
                                <td class="text-end">
                                    <button class="btn btn-outline-danger btn-sm rounded-pill px-3"
                                            onclick="deleteBlog('<%= id %>')">
                                        <i class="fa-solid fa-trash me-1"></i> Retract
                                    </button>
                                </td>
                            </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.print("<tr><td colspan='4' class='text-danger text-center'>Error loading articles: " + e.getMessage() + "</td></tr>");
                            }

                            if (!any) {
                        %>
                            <tr>
                                <td colspan="4" class="text-center text-muted py-5">
                                    <i class="fa-solid fa-newspaper fs-1 text-secondary mb-3 opacity-50"></i>
                                    <h5 class="fw-bold">No Articles Found</h5>
                                    <p class="mb-0">The publishing engine is currently empty. Start drafting your first article above.</p>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleComposer() {
        const composer = document.getElementById('composerCard');
        if (composer.classList.contains('d-none')) {
            composer.classList.remove('d-none');
            document.getElementById('blogTitle').focus();
        } else {
            composer.classList.add('d-none');
            document.getElementById('blogForm').reset();
        }
    }

    function publishBlog() {
        const title = document.getElementById('blogTitle').value.trim();
        const category = document.getElementById('blogCategory').value;
        const excerpt = document.getElementById('blogExcerpt').value.trim();
        const content = document.getElementById('blogContent').value.trim();
        const imageUrl = document.getElementById('blogImage').value.trim();

        if (!title || !content) {
            alert('Title and Content are mandatory fields.');
            return;
        }

        const btn = document.getElementById('btnPublish');
        const originalHtml = btn.innerHTML;
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-2"></i> Publishing...';
        btn.disabled = true;

        const formData = new URLSearchParams();
        formData.append("action", "create");
        formData.append("title", title);
        formData.append("category", category);
        formData.append("excerpt", excerpt);
        formData.append("content", content);
        formData.append("imageUrl", imageUrl);

        fetch("<%= request.getContextPath() %>/api/admin/blogs", {
            method: "POST",
            body: formData,
            headers: { "Content-Type": "application/x-www-form-urlencoded" }
        })
        .then(response => response.json())
        .then(res => {
            if (res.success) {
                window.location.reload();
            } else {
                alert("Error: " + (res.error || "Failed to publish article."));
                btn.innerHTML = originalHtml;
                btn.disabled = false;
            }
        })
        .catch(err => {
            alert("Network error: Could not contact publishing server.");
            console.error(err);
            btn.innerHTML = originalHtml;
            btn.disabled = false;
        });
    }

    function deleteBlog(id) {
        if (!confirm("Are you sure you want to retract and delete this article permanently?")) return;

        const formData = new URLSearchParams();
        formData.append("action", "delete");
        formData.append("id", id);

        fetch("<%= request.getContextPath() %>/api/admin/blogs", {
            method: "POST",
            body: formData,
            headers: { "Content-Type": "application/x-www-form-urlencoded" }
        })
        .then(response => response.json())
        .then(res => {
            if (res.success) {
                window.location.reload();
            } else {
                alert("Error: " + (res.error || "Failed to delete article."));
            }
        })
        .catch(err => {
            alert("Network error.");
            console.error(err);
        });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
