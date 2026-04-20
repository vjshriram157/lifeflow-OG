<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Find Blood | LifeFlow Locator</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/theme.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #0f172a !important; color: #f8fafc !important; font-family: 'Inter', sans-serif; padding-top: 100px; }
        h1, h2, h3, .brand-text { font-family: 'Outfit', sans-serif; }
        .finder-hero { padding: 40px 0; background: radial-gradient(circle at 50% 0%, rgba(225, 29, 72, 0.1) 0%, transparent 60%); }
        .glass-card { background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 30px; }
        .results-container { min-height: 400px; }
        .table-dark { background: transparent !important; --bs-table-bg: transparent; }
        .table-dark th { border-bottom: 2px solid rgba(255, 255, 255, 0.1); color: #94a3b8; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; padding: 20px; }
        .table-dark td { border-bottom: 1px solid rgba(255, 255, 255, 0.05); color: #cbd5e1; padding: 25px 20px; vertical-align: middle; }
        .bank-name { font-weight: 700; color: #fff; font-size: 1.1rem; }
        .distance-badge { background: rgba(225, 29, 72, 0.1); color: #fb7185; padding: 5px 12px; border-radius: 50px; font-size: 0.75rem; font-weight: 700; }
        .btn-request { background: #e11d48; color: #fff; border: none; border-radius: 50px; padding: 8px 20px; font-weight: 600; font-size: 0.85rem; transition: 0.3s; }
        .btn-request:hover { background: #fb7185; transform: scale(1.05); color: #fff; }
        .search-input { background: rgba(255, 255, 255, 0.05) !important; border: 1px solid rgba(255, 255, 255, 0.1) !important; color: #fff !important; border-radius: 15px !important; padding: 15px 25px; transition: 0.3s; }
        .search-input:focus { background: rgba(255, 255, 255, 0.08) !important; border-color: #e11d48 !important; box-shadow: 0 0 0 4px rgba(225, 29, 72, 0.1) !important; }
        .loading-shimmer { height: 60px; background: linear-gradient(90deg, transparent, rgba(255,255,255,0.03), transparent); background-size: 200% 100%; animation: shimmer 1.5s infinite; border-radius: 10px; margin-bottom: 15px; }
        @keyframes shimmer { 0% { background-position: -200% 0; } 100% { background-position: 200% 0; } }

        /* SEARCH BAR COMPONENT STYLES */
        select option, .form-select option { background-color: #1e293b !important; color: #ffffff !important; }
        .search-container { width: 100%; max-width: 1100px; margin-top: 3rem; }
        .search-glass { background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.1); padding: 12px; border-radius: 50rem; display: flex; align-items: center; gap: 10px; }
        .search-item { flex: 1; padding: 10px 20px; display: flex; align-items: center; gap: 12px; border-right: 1px solid rgba(255, 255, 255, 0.1); }
        .search-item:last-child { border-right: none; }
        .search-select { background: transparent !important; border: none !important; color: #fff !important; width: 100%; outline: none; cursor: pointer; font-weight: 500; }
        .btn-search { height: 55px; width: 55px; border-radius: 50%; display: flex; align-items: center; justify-content: center; background: #e11d48; color: white; border: none; transition: 0.3s; }
        .btn-search:hover { background: #9f1239; transform: scale(1.1); }
        .search-glow-fx { box-shadow: 0 10px 40px rgba(225, 29, 72, 0.15); border: 1px solid rgba(225, 29, 72, 0.3) !important; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<section class="finder-hero">
    <div class="container">
        <div class="text-center mb-5 animate-up">
            <h1 class="display-3 fw-bold text-white mb-3">Donor Locator</h1>
            <p class="text-visible-muted mx-auto" style="max-width: 600px;">Search our real-time grid for available blood units and verified volunteer donors in your city.</p>
        </div>

        <div class="glass-card p-5 animate-up search-glow-fx mt-4">
            <form id="searchForm" class="search-glass w-100">
                <div class="search-item">
                    <i class="fa-solid fa-droplet text-danger"></i>
                    <select class="search-select" id="bloodGroup" required>
                        <option value="" selected disabled>Blood Group</option>
                        <option value="A+">A+</option><option value="A-">A-</option>
                        <option value="B+">B+</option><option value="B-">B-</option>
                        <option value="O+">O+</option><option value="O-">O-</option>
                        <option value="AB+">AB+</option><option value="AB-">AB-</option>
                    </select>
                </div>
                <div class="search-item">
                    <i class="fa-solid fa-map-location-dot text-danger"></i>
                    <select class="search-select" id="stateSelect" required><option value="" selected disabled>Select State</option></select>
                </div>
                <div class="search-item">
                    <i class="fa-solid fa-city text-danger"></i>
                    <select class="search-select" id="cityInput" required><option value="" selected disabled>Select District</option></select>
                </div>
                <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>

            <div class="results-container mt-5">
                <div id="loading" style="display: none;">
                    <div class="loading-shimmer"></div>
                    <div class="loading-shimmer"></div>
                    <div class="loading-shimmer"></div>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-dark" id="resultsTable" style="display: none;">
                        <thead>
                            <tr>
                                <th>Facility / Donor</th>
                                <th>Location</th>
                                <th>Distance</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="resultsBody">
                            <!-- Results will be injected here -->
                        </tbody>
                    </table>
                </div>
                
                <div id="noResults" class="text-center py-5" style="display: none;">
                    <i class="fa-solid fa-map-location-dot text-danger mb-3" style="font-size: 3rem; opacity: 0.3;"></i>
                    <h4 class="text-white">No donors found in this area</h4>
                    <p class="text-visible-muted">Try expanding your search radius or checking a nearby city.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const searchForm = document.getElementById('searchForm');
    const loading = document.getElementById('loading');
    const resultsTable = document.getElementById('resultsTable');
    const resultsBody = document.getElementById('resultsBody');
    const noResults = document.getElementById('noResults');
    const stateSelect = document.getElementById("stateSelect");
    const cityInput = document.getElementById("cityInput");

    // Initialize States & Districts dropdowns
    document.addEventListener("DOMContentLoaded", async function() {
        try {
            const resp = await fetch("https://raw.githubusercontent.com/sab99r/Indian-States-And-Districts/master/states-and-districts.json");
            const data = await resp.json();
            data.states.forEach(s => {
                const opt = document.createElement("option");
                opt.value = opt.textContent = s.state;
                stateSelect.appendChild(opt);
            });
            stateSelect.addEventListener("change", () => {
                cityInput.innerHTML = '<option value="" selected disabled>Select District</option>';
                const state = data.states.find(s => s.state === stateSelect.value);
                state.districts.forEach(d => {
                    const opt = document.createElement("option");
                    opt.value = opt.textContent = d;
                    cityInput.appendChild(opt);
                });
            });
        } catch(e) { console.error("Error loading location data:", e); }
    });

    searchForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const city = document.getElementById('cityInput').value.trim();
        const bloodGroup = document.getElementById('bloodGroup').value;
        
        if (!city) return;

        // Reset state
        loading.style.display = 'block';
        resultsTable.style.display = 'none';
        noResults.style.display = 'none';
        resultsBody.innerHTML = '';

        try {
            // Use the established platform locator API
            const ctx = '<%= request.getContextPath() %>';
            const response = await fetch(`\${ctx}/api/locator?city=\${encodeURIComponent(city)}&bloodGroup=\${encodeURIComponent(bloodGroup)}`);
            
            if (!response.ok) throw new Error('Search failed');
            
            const data = await response.json();
            
            if (!data.banks || data.banks.length === 0) {
                noResults.style.display = 'block';
            } else {
                data.banks.forEach(bank => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>
                            <div class="bank-name">\${bank.name}</div>
                            <small class="text-visible-muted">Verified Medical Facility</small>
                        </td>
                        <td>
                            <i class="fa-solid fa-location-dot text-danger me-2"></i>
                            \${bank.city}
                        </td>
                        <td>
                            <span class="distance-badge">\${bank.distanceKm.toFixed(1)} km away</span>
                        </td>
                        <td>
                            <span class="badge rounded-pill" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                                <i class="fa-solid fa-check-circle me-1"></i> Active
                            </span>
                        </td>
                        <td>
                            <button class="btn-request" onclick="requestBlood('\${bank.id}')">Request</button>
                        </td>
                    `;
                    resultsBody.appendChild(row);
                });
                resultsTable.style.display = 'table';
            }
        } catch (err) {
            console.error(err);
            alert('An error occurred while searching. Please try again later.');
        } finally {
            loading.style.display = 'none';
        }
    });

    function requestBlood(bankId) {
        window.location.href = `login.jsp?redirect=request.jsp&bankId=\${bankId}`;
    }
</script>

</body>
</html>