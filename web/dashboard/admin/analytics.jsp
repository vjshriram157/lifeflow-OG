<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<title>Analytics Dashboard | LifeFlow</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
<style>
    #heatmap { height: 450px; border-radius: var(--radius-md); z-index: 1; }
</style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR -->
    <% request.setAttribute("activePage", "analytics"); %>
    <jsp:include page="../../WEB-INF/fragments/sidebar-admin.jspf" />

    <!-- MAIN CONTENT -->
    <div class="container-fluid p-4 p-md-5 w-100">
        <div class="d-flex justify-content-between align-items-center mb-5 fade-in-up">
            <div>
                <h2 class="fw-bold mb-1">Intelligence & Forecasting</h2>
                <p class="text-muted">Real-time data visualization of donation volume and shortage heatmaps.</p>
            </div>
            <div>
                <button class="btn btn-outline-secondary rounded-pill px-4" onclick="window.location.reload()"><i class="fa-solid fa-rotate-right me-2"></i>Refresh Data</button>
            </div>
        </div>
        
        <div class="row g-4">
            <!-- Chart Section -->
            <div class="col-md-7 fade-in-up delay-100">
                <div class="card card-modern h-100">
                    <div class="card-body p-4 p-md-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-chart-simple text-danger me-2"></i> Donation Trends by Volume</h5>
                        </div>
                        <div style="height: 450px; position: relative;">
                            <canvas id="donationChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Heatmap Section -->
            <div class="col-md-5 fade-in-up delay-200">
                <div class="card card-modern h-100">
                    <div class="card-body p-4 p-md-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-map-location-dot text-danger me-2"></i> Demand Heatmap</h5>
                            <span class="badge badge-soft-danger"><i class="fa-solid fa-circle-dot fa-fade me-1"></i> Live</span>
                        </div>
                        <div id="heatmap" class="border"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.heat/dist/leaflet-heat.js"></script>

<script>
    // Fetch and render Donation Chart
    fetch('<%=request.getContextPath()%>/api/analytics?metric=donationsByMonth')
        .then(res => res.json())
        .then(data => {
            if(data.error) return console.error("Analytics Error: " + data.error);
            const rawData = data.data || [];
            if(rawData.length === 0) {
                document.getElementById('donationChart').parentElement.innerHTML = '<div class="h-100 d-flex align-items-center justify-content-center flex-column text-muted"><i class="fa-solid fa-chart-bar fs-1 mb-3 text-light"></i><p>No completed donations on record yet.</p></div>';
                return;
            }
            
            const labels = [];
            const datasetsMap = {};
            
            rawData.forEach(item => {
                const label = item.year + '-' + item.month.toString().padStart(2, '0');
                if(!labels.includes(label)) labels.push(label);
                
                if(!datasetsMap[item.bloodGroup]) {
                    const colors = {
                        'A+': '#ef4444', 'A-': '#b91c1c', 'B+': '#3b82f6', 'B-': '#1d4ed8',
                        'AB+': '#8b5cf6', 'AB-': '#6d28d9', 'O+': '#10b981', 'O-': '#047857'
                    };
                    datasetsMap[item.bloodGroup] = {
                        label: item.bloodGroup,
                        data: {},
                        backgroundColor: colors[item.bloodGroup] || '#f59e0b',
                        borderRadius: 4
                    };
                }
                datasetsMap[item.bloodGroup].data[label] = item.count;
            });
            
            labels.sort();
            const datasets = Object.values(datasetsMap).map(ds => {
                return {
                    label: ds.label,
                    backgroundColor: ds.backgroundColor,
                    borderRadius: ds.borderRadius,
                    data: labels.map(l => ds.data[l] || 0)
                };
            });

            Chart.defaults.font.family = "'Inter', sans-serif";
            new Chart(document.getElementById('donationChart'), {
                type: 'bar',
                data: { labels, datasets },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: { mode: 'index', intersect: false },
                    plugins: {
                        legend: { position: 'top', labels: { usePointStyle: true, padding: 20 } }
                    },
                    scales: {
                        x: { stacked: true, grid: { display: false } },
                        y: { stacked: true, beginAtZero: true, border: { display: false } }
                    }
                }
            });
        }).catch(err => console.error(err));

    // Fetch and render Heatmap
    const map = L.map('heatmap').setView([20.5937, 78.9629], 4); 
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap', maxZoom: 18
    }).addTo(map);

    fetch('<%=request.getContextPath()%>/api/analytics?metric=heatmapDemand')
        .then(res => res.json())
        .then(data => {
            if(data.error) return console.error("Heatmap Error: " + data.error);
            const points = data.points || [];
            if(points.length === 0) {
                const mapEl = document.getElementById('heatmap');
                mapEl.classList.add('d-flex', 'align-items-center', 'justify-content-center', 'bg-light');
                mapEl.innerHTML = '<div class="text-center text-muted"><i class="fa-solid fa-earth-americas fs-1 mb-3 text-light"></i><p class="m-0">No blood shortages reported across regions.</p></div>';
                return;
            }
            
            if (typeof L.heatLayer !== 'undefined') {
                const heatData = points.map(p => [p.lat, p.lng, p.weight * 5]);
                L.heatLayer(heatData, {radius: 30, blur: 20, maxZoom: 17, gradient: {0.4: 'yellow', 0.65: 'orange', 1: 'red'}}).addTo(map);
            } else {
                points.forEach(p => {
                    L.circleMarker([p.lat, p.lng], {
                        radius: Math.min(p.weight * 2, 20), color: '#e11d48', fillOpacity: 0.6
                    }).addTo(map).bindPopup("Deficit weight: " + p.weight);
                });
            }
            
            if(points.length > 0) {
                const lats = points.map(p => p.lat);
                const lngs = points.map(p => p.lng);
                map.fitBounds([[Math.min(...lats), Math.min(...lngs)], [Math.max(...lats), Math.max(...lngs)]], {padding: [50, 50]});
            }
        }).catch(err => console.error(err));
</script>
</body>
</html>
