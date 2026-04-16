<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bloodbank.util.FirebaseConfig,com.google.cloud.firestore.*,com.google.api.core.ApiFuture,java.util.List" %>
<%
    String userId = (String) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");
    if (userId == null || role == null || !"DONOR".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Request Blood | LifeFlow</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR -->
    <div class="sidebar p-4">
        <a href="<%=request.getContextPath()%>/index.jsp" class="brand mb-5 text-decoration-none">
            <i class="fa-solid fa-droplet text-danger"></i> Life<span class="text-white">Flow</span>
            <span class="badge bg-danger ms-2 fs-6 rounded-pill">Donor</span>
        </a>
        <ul class="nav flex-column gap-2 mt-4">
            <li><a href="<%=request.getContextPath()%>/dashboard/donor/home.jsp" class="nav-link"><i class="fa-solid fa-clock-rotate-left"></i> My History</a></li>
            <li><a href="<%=request.getContextPath()%>/dashboard/donor/requestBlood.jsp" class="nav-link active"><i class="fa-solid fa-hand-holding-hand"></i> Request Blood</a></li>
            <li><a href="<%=request.getContextPath()%>/dashboard/donor/findDonors.jsp" class="nav-link"><i class="fa-solid fa-magnifying-glass-location"></i> Find Donors</a></li>
        </ul>
        <div class="mt-auto pt-5 pb-3">
            <a href="<%=request.getContextPath()%>/LogoutServlet" class="btn btn-outline-light btn-sm w-100 rounded-pill"><i class="fa-solid fa-right-from-bracket me-2"></i>Sign Out</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="container-fluid p-4 p-md-5 w-100">
        <div class="d-flex justify-content-between align-items-center mb-5 fade-in-up">
            <div>
                <h2 class="fw-bold mb-1">Post a Blood Request</h2>
                <p class="text-muted">Broadcast your need to nearby donors and blood banks.</p>
            </div>
            <a href="home.jsp" class="btn btn-outline-secondary rounded-pill px-4 shadow-sm">
                <i class="fa-solid fa-arrow-left me-2"></i> Back to Dashboard
            </a>
        </div>

        <div class="row">
            <div class="col-lg-7">
                <div class="card card-modern shadow-lg border-0 fade-in-up delay-100">
                    <div class="card-body p-4 p-md-5">
                        <form id="bloodRequestForm">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Blood Group Needed</label>
                                    <select name="bloodGroup" class="form-select rounded-3 p-3 bg-light border-0" required>
                                        <option value="">Select Group</option>
                                        <option value="A+">A+</option>
                                        <option value="A-">A-</option>
                                        <option value="B+">B+</option>
                                        <option value="B-">B-</option>
                                        <option value="O+">O+</option>
                                        <option value="O-">O-</option>
                                        <option value="AB+">AB+</option>
                                        <option value="AB-">AB-</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Urgency Level</label>
                                    <select name="urgency" class="form-select rounded-3 p-3 bg-light border-0" required>
                                        <option value="Normal">Normal</option>
                                        <option value="Urgent">Urgent (24h)</option>
                                        <option value="Emergency">Emergency (Immediate)</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-bold">Hospital Name / Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="fa-solid fa-hospital text-danger"></i></span>
                                        <input type="text" name="hospitalName" class="form-control rounded-end-3 p-3 bg-light border-0" placeholder="e.g. City General Hospital, Apollo" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">City</label>
                                    <input type="text" name="city" class="form-control rounded-3 p-3 bg-light border-0" placeholder="Where is blood needed?" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Units Required</label>
                                    <input type="number" name="units" class="form-control rounded-3 p-3 bg-light border-0" value="1" min="1" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-bold">Additional Message (Optional)</label>
                                    <textarea name="message" class="form-control rounded-3 p-3 bg-light border-0" rows="3" placeholder="Any specific requirements or contact instructions..."></textarea>
                                </div>
                                <div class="col-12 mt-5">
                                    <button type="submit" class="btn btn-premium w-100 py-3 rounded-pill shadow-lg fw-bold">
                                        <i class="fa-solid fa-bullhorn me-2"></i> Broadcast Blood Request
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-5 ps-lg-4 mt-5 mt-lg-0">
                <div class="alert alert-info border-0 shadow-sm rounded-4 mb-4">
                    <h5 class="fw-bold"><i class="fa-solid fa-shield-halved me-2"></i> Safe & Secure</h5>
                    <p class="small mb-0">Your request will be visible to matched donors and local blood banks. High-urgency requests will also trigger mobile push notifications to donors in your city.</p>
                </div>
                
                <h5 class="fw-bold mb-3"><i class="fa-solid fa-history me-2"></i> Your Recent Requests</h5>
                <div id="recentRequests" class="d-flex flex-column gap-3">
                    <!-- Loaded via JS -->
                    <div class="text-center py-5 text-muted">
                        <div class="spinner-border spinner-border-sm me-2"></div> Loading your requests...
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('bloodRequestForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const btn = this.querySelector('button[type="submit"]');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Broadcasting...';

        const formData = new URLSearchParams(new FormData(this));

        fetch('<%= request.getContextPath() %>/api/blood-request', {
            method: 'POST',
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if(data.status === 'OK') {
                alert('Blood request broadcasted successfully!');
                location.reload();
            } else {
                alert('Error: ' + data.error);
                btn.disabled = false;
                btn.innerHTML = '<i class="fa-solid fa-bullhorn me-2"></i> Broadcast Blood Request';
            }
        })
        .catch(err => {
            console.error(err);
            alert('A connection error occurred.');
            btn.disabled = false;
        });
    });

    // Load recent requests for this user
    function loadRequests() {
        // We'll refine this but for now we list all open requests matching the user's focus
        fetch('<%= request.getContextPath() %>/api/blood-request')
        .then(res => res.json())
        .then(data => {
            const container = document.getElementById('recentRequests');
            if(!data || data.length === 0) {
                container.innerHTML = '<div class="text-center text-muted p-4 border rounded-4 border-dashed">No active requests found.</div>';
                return;
            }
            container.innerHTML = '';
            data.forEach(req => {
                const card = document.createElement('div');
                card.className = 'card border-0 shadow-sm rounded-4';
                card.innerHTML = '<div class="card-body p-3">' +
                    '<div class="d-flex justify-content-between align-items-start mb-2">' +
                        '<h6 class="fw-bold mb-0"><i class="fa-solid fa-hospital-user text-danger me-1"></i> ' + req.hospital_name + '</h6>' +
                        '<span class="badge bg-danger rounded-pill">' + req.blood_group + '</span>' +
                    '</div>' +
                    '<div class="text-muted small mb-1"><i class="fa-solid fa-location-dot me-1"></i> ' + req.city + '</div>' +
                    '<div class="small fw-medium ' + (req.urgency === 'Emergency' ? 'text-danger' : 'text-primary') + '"><i class="fa-solid fa-circle-exclamation me-1"></i> ' + req.urgency + '</div>' +
                '</div>';
                container.appendChild(card);
            });
        });
    }
    loadRequests();
</script>
<jsp:include page="../../chatWidget.jsp" />
</body>
</html>
