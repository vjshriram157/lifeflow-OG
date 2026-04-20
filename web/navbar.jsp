<style>
    .navbar-floating {
        position: fixed;
        top: 20px;
        left: 0;
        right: 0;
        z-index: 1100;
        margin: 0 20px;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .navbar-glass {
        background: rgba(15, 23, 42, 0.6);
        backdrop-filter: blur(15px);
        -webkit-backdrop-filter: blur(15px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 50rem;
        padding: 10px 25px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    }

    .navbar-floating .nav-link {
        color: #cbd5e1 !important;
        font-weight: 500;
        padding: 10px 20px !important;
        border-radius: 50rem;
        transition: 0.3s;
    }

    .navbar-floating .nav-link:hover {
        color: #fff !important;
        background: rgba(255, 255, 255, 0.05);
    }

    .navbar-floating .nav-link.active {
        color: #e11d48 !important; /* Crimson */
    }

    .btn-brand-pulse {
        background: linear-gradient(135deg, #e11d48, #9f1239);
        color: #fff !important;
        border: none;
        padding: 12px 28px;
        border-radius: 50rem;
        font-weight: 600;
        transition: 0.3s;
        box-shadow: 0 4px 15px rgba(225, 29, 72, 0.3);
        position: relative;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    .btn-brand-pulse:hover {
        transform: scale(1.05);
        box-shadow: 0 8px 25px rgba(225, 29, 72, 0.5);
    }

    .btn-brand-pulse::after {
        content: '';
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        border-radius: 50rem;
        background: #e11d48;
        opacity: 0.3;
        z-index: -1;
        animation: pulse-ring-nav 2s infinite;
    }

    @keyframes pulse-ring-nav {
        0% { transform: scale(1); opacity: 0.5; }
        100% { transform: scale(1.4); opacity: 0; }
    }

    .animate-down {
        animation: slideDownNav 0.5s ease-out;
    }

    @keyframes slideDownNav {
        from { transform: translateY(-100%); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }

    @media (max-width: 991px) {
        .navbar-floating { margin: 10px; }
        .navbar-glass { border-radius: 24px; padding: 15px; }
    }

    /* Localization Overrides */
    body { top: 0 !important; }
    .skiptranslate iframe, .goog-te-banner-frame { display: none !important; }
    #google_translate_element { display: none !important; }
    
    .lang-selector {
        background: rgba(255, 255, 255, 0.05);
        color: #fff;
        border: 1px solid rgba(255, 255, 255, 0.2);
        padding: 8px 15px;
        border-radius: 50rem;
        font-family: 'Inter', sans-serif;
        font-size: 0.9rem;
        cursor: pointer;
        transition: all 0.3s;
        appearance: none;
        -webkit-appearance: none;
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M7 10l5 5 5-5z"/></svg>');
        background-repeat: no-repeat;
        background-position: right 10px center;
        background-size: 20px;
        padding-right: 35px;
    }
    .lang-selector:hover {
        background-color: rgba(255, 255, 255, 0.1);
        border-color: rgba(225, 29, 72, 0.5);
    }
    .lang-selector option {
        background: #0f172a;
        color: #fff;
    }
</style>

<nav class="navbar navbar-expand-lg navbar-floating animate-down">
    <div class="container navbar-glass">
        <a class="navbar-brand d-flex align-items-center gap-2" href="index.jsp" id="nav-main-logo">
            <i class="fa-solid fa-heart-pulse text-danger fs-3"></i>
            <span class="brand-text fw-bold text-white fs-4" style="font-family: 'Outfit', sans-serif;">LifeFlow</span>
        </a>
        
        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navMain">
            <i class="fa-solid fa-bars-staggered text-white"></i>
        </button>

        <div class="collapse navbar-collapse" id="navMain">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0 gap-lg-2">
                <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="findBloodBank.jsp">Find Blood</a></li>
                <li class="nav-item"><a class="nav-link" href="blog.jsp">Health Blog</a></li>
                <li class="nav-item"><a class="nav-link" href="features.jsp">Features</a></li>
                <li class="nav-item align-self-lg-center">
                    <a class="nav-link <% if(request.getRequestURI().contains("leaderboard.jsp")) out.print("active"); %>" href="leaderboard.jsp">Leaderboard <i class="fa-solid fa-ranking-star ms-1 text-warning"></i></a>
                </li>
            </ul>
            <div class="d-flex align-items-center gap-3">
                <!-- Google API Hidden Target -->
                <div id="google_translate_element"></div>
                
                <i class="fa-solid fa-globe text-muted d-none d-lg-block"></i>
                <select class="lang-selector d-none d-lg-block" id="customLanguageSelector">
                    <option value="en">&#127760; English (US)</option>
                    <option value="hi">&#127470;&#127475; Hindi</option>
                    <option value="ta">&#127470;&#127475; Tamil</option>
                    <option value="te">&#127470;&#127475; Telugu</option>
                    <option value="bn">&#127470;&#127475; Bengali</option>
                    <option value="mr">&#127470;&#127475; Marathi</option>
                </select>

                <a href="login.jsp" class="nav-link d-none d-lg-block ms-2">Login</a>
                <a href="register.jsp" class="btn-brand-pulse">Join Network</a>
            </div>
        </div>
    </div>
</nav>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Sync with Splash Screen if present
        const logo = document.getElementById('nav-main-logo');
        const isLanding = window.location.pathname.endsWith('index.jsp') || window.location.pathname.endsWith('/');
        
        if (isLanding && !sessionStorage.getItem('lifeflow_splash_played')) {
            if (logo) logo.style.opacity = '0';
            
            const observer = new MutationObserver((mutations) => {
                if (document.body.classList.contains('is-ready')) {
                    if (logo) {
                        logo.style.transition = 'opacity 0.6s ease-in';
                        logo.style.opacity = '1';
                    }
                    observer.disconnect();
                }
            });
            observer.observe(document.body, { attributes: true, attributeFilter: ['class'] });
        }

        const navbar = document.querySelector('.navbar-floating');
        if (navbar) {
            const handleScroll = () => {
                if (window.scrollY > 50) {
                    navbar.style.top = '10px';
                    navbar.style.margin = '0 10px';
                    // Optional: increase blur on scroll
                } else {
                    navbar.style.top = '20px';
                    navbar.style.margin = '0 20px';
                }
            };
            window.addEventListener('scroll', handleScroll);
            handleScroll(); // Initialize state
        }

        // Auto-set Active Link
        const currentPath = window.location.pathname.split("/").pop();
        document.querySelectorAll('.navbar-floating .nav-link').forEach(link => {
            const linkPath = link.getAttribute('href');
            if (linkPath === currentPath) {
                link.classList.add('active');
            }
        });
    });

    // --- Localization Engine ---
    function googleTranslateElementInit() {
        new google.translate.TranslateElement({
            pageLanguage: 'en',
            includedLanguages: 'en,hi,ta,te,bn,mr',
            layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
            autoDisplay: false
        }, 'google_translate_element');
    }

    function triggerTranslation(langCode) {
        if (langCode === 'en') {
            // Reset to English by clearing the cookie
            document.cookie = 'googtrans=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
            document.cookie = 'googtrans=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/; domain=' + window.location.hostname;
        } else {
            // Set the Google Translate cookie (format: /en/hi for English -> Hindi)
            var cookieVal = '/en/' + langCode;
            document.cookie = 'googtrans=' + cookieVal + '; path=/';
            document.cookie = 'googtrans=' + cookieVal + '; path=/; domain=' + window.location.hostname;
        }
        // Reload so Google Translate picks up the new language from the cookie
        window.location.reload();
    }

    // Sync custom dropdown to translation engine
    document.getElementById('customLanguageSelector').addEventListener('change', function() {
        triggerTranslation(this.value);
    });

    // On page load, read the current cookie to sync the dropdown display
    (function syncDropdownFromCookie() {
        var match = document.cookie.match(/googtrans=\/en\/([a-z]+)/);
        if (match && match[1]) {
            var sel = document.getElementById('customLanguageSelector');
            if (sel) sel.value = match[1];
        }
    })();

</script>

<script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
