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
    <title>Find Donors | LifeFlow</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/overrides_v3.css" rel="stylesheet">
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
            <li><a href="<%=request.getContextPath()%>/dashboard/donor/requestBlood.jsp" class="nav-link"><i class="fa-solid fa-hand-holding-hand"></i> Request Blood</a></li>
            <li><a href="<%=request.getContextPath()%>/dashboard/donor/findDonors.jsp" class="nav-link active"><i class="fa-solid fa-magnifying-glass-location"></i> Find Donors</a></li>
        </ul>
        <div class="mt-auto pt-5 pb-3">
            <a href="<%=request.getContextPath()%>/LogoutServlet" class="btn btn-outline-light btn-sm w-100 rounded-pill"><i class="fa-solid fa-right-from-bracket me-2"></i>Sign Out</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="container-fluid p-4 p-md-5 w-100">
        <div class="d-flex justify-content-between align-items-center mb-5 fade-in-up">
            <div>
                <h2 class="fw-bold mb-1">Find Nearby Donors</h2>
                <p class="text-muted">Connect with life-savers in your community.</p>
            </div>
            <a href="home.jsp" class="btn btn-outline-secondary rounded-pill px-4 shadow-sm">
                <i class="fa-solid fa-arrow-left me-2"></i> Back
            </a>
        </div>

        <div class="card card-modern border-0 shadow-sm fade-in-up mb-5">
            <div class="card-body p-4 p-md-5">
                <form id="donorSearchForm" class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label fw-bold">Blood Group Needed</label>
                        <select name="bloodGroup" id="bloodGroup" class="form-select rounded-pill p-3 bg-light border-0" required>
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
                    <div class="col-md-5">
                        <label class="form-label fw-bold">City (Optional)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0 rounded-start-pill px-3"><i class="fa-solid fa-city text-danger"></i></span>
                            <input type="text" name="city" id="city" class="form-control rounded-end-pill p-3 bg-light border-0" placeholder="e.g. Mumbai, New York">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-premium w-100 py-3 rounded-pill shadow-sm fw-bold">
                            <i class="fa-solid fa-magnifying-glass me-1"></i> Search
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div id="searchResults" class="row g-4">
            <div class="col-12 text-center py-5 text-muted">
                <i class="fa-solid fa-people-arrows fs-1 mb-3 text-light"></i>
                <p>Select a blood group to find donors nearby.</p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('donorSearchForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const bg = document.getElementById('bloodGroup').value;
        const city = document.getElementById('city').value;
        const resultsDiv = document.getElementById('searchResults');

        resultsDiv.innerHTML = '<div class="col-12 text-center py-5"><div class="spinner-border text-danger"></div><p class="mt-2 text-muted">Searching for donors...</p></div>';

        const params = new URLSearchParams({ bloodGroup: bg, city: city });
        fetch('<%= request.getContextPath() %>/api/donors?' + params.toString())
        .then(res => res.json())
        .then(data => {
            if(data && data.error) {
                resultsDiv.innerHTML = '<div class="col-12 text-center py-5 text-danger">Error: ' + data.error + '</div>';
                return;
            }

            if(!Array.isArray(data) || data.length === 0) {
                resultsDiv.innerHTML = '<div class="col-12 text-center py-5">' +
                    '<div class="bg-light d-inline-flex p-4 rounded-circle mb-3"><i class="fa-solid fa-user-slash fs-1 text-muted"></i></div>' +
                    '<h5 class="fw-bold">No donors found</h5>' +
                    '<p class="text-muted">We couldn\'t find any donors matching "' + bg + '" in ' + (city || 'any city') + '.</p>' +
                '</div>';
                return;
            }

            resultsDiv.innerHTML = '';
            data.forEach(donor => {
                const col = document.createElement('div');
                col.className = 'col-md-6 col-lg-4 fade-in-up';
                col.innerHTML = '<div class="card card-modern border-0 shadow-sm h-100 hover-lift">' +
                    '<div class="card-body p-4">' +
                        '<div class="d-flex justify-content-between align-items-start mb-3">' +
                            '<div class="bg-danger bg-opacity-10 text-danger p-3 rounded-circle">' +
                                '<i class="fa-solid fa-user-heart fs-4"></i>' +
                            '</div>' +
                            '<span class="badge bg-danger rounded-pill px-3 shadow-sm">' + donor.bloodGroup + '</span>' +
                        '</div>' +
                        '<h5 class="fw-bold mb-1">' + donor.name + '</h5>' +
                        '<p class="text-muted small mb-4"><i class="fa-solid fa-location-dot me-1"></i> ' + donor.city + '</p>' +
                        '<hr class="opacity-10 mb-4">' +
                        '<div class="d-flex flex-column gap-2 mb-4">' +
                            '<div class="d-flex align-items-center text-dark">' +
                                '<i class="fa-solid fa-phone-flip me-3 text-danger"></i>' +
                                '<span class="fw-medium">' + donor.phone + '</span>' +
                            '</div>' +
                            '<div class="d-flex align-items-center text-dark" style="word-break: break-all;">' +
                                '<i class="fa-solid fa-envelope me-3 text-danger"></i>' +
                                '<span class="fw-medium small">' + donor.email + '</span>' +
                            '</div>' +
                        '</div>' +
                        '<a href="tel:' + donor.phone + '" class="btn btn-outline-danger w-100 rounded-pill fw-bold py-2 mt-auto">' +
                            '<i class="fa-solid fa-phone me-2"></i> Contact Now' +
                        '</a>' +
                    '</div>' +
                '</div>';
                resultsDiv.appendChild(col);
            });
        })
        .catch(err => {
            console.error(err);
            resultsDiv.innerHTML = '<div class="col-12 text-danger text-center py-5">Search failed. Please try again.</div>';
        });
    });
</script>
<jsp:include page="../../chatWidget.jsp" />
</body>
</html>
