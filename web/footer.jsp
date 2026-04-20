<jsp:include page="chatWidget.jsp" />

<footer style="background-color: #0f172a; padding: 80px 0 20px 0;">
    <div class="container">
        <div class="row g-5">
            <div class="col-lg-4">
                <a class="d-flex align-items-center gap-2 mb-4 text-decoration-none" href="index.jsp">
                    <i class="fa-solid fa-heart-pulse text-danger fs-3"></i>
                    <span class="brand-text fw-bold text-white fs-4" style="font-family: 'Outfit', sans-serif;">LifeFlow</span>
                </a>
                <p style="color: #94a3b8;">National blood management technology provider. Committed to transparency, speed, and safety in healthcare operations.</p>
                <div class="d-flex gap-3 mt-4">
                    <a href="javascript:void(0)" class="text-muted fs-5"><i class="fa-brands fa-twitter"></i></a>
                    <a href="javascript:void(0)" class="text-muted fs-5"><i class="fa-brands fa-linkedin"></i></a>
                    <a href="javascript:void(0)" class="text-muted fs-5"><i class="fa-brands fa-github"></i></a>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <h5 class="text-white fw-bold mb-4" style="font-family: 'Outfit', sans-serif;">Platform</h5>
                <ul class="list-unstyled">
                    <li><a href="findBloodBank.jsp" class="footer-link">Find Blood</a></li>
                    <li><a href="blog.jsp" class="footer-link">Health Blog</a></li>
                    <li><a href="features.jsp" class="footer-link">Features</a></li>
                    <li><a href="login.jsp" class="footer-link">Admin Login</a></li>
                </ul>
            </div>
            <div class="col-6 col-lg-2">
                <h5 class="text-white fw-bold mb-4" style="font-family: 'Outfit', sans-serif;">Legal</h5>
                <ul class="list-unstyled">
                    <li><a href="terms.jsp" class="footer-link">Terms & Conditions</a></li>
                    <li><a href="privacy.jsp" class="footer-link">Privacy Policy</a></li>
                    <li><a href="contact.jsp" class="footer-link">Help Center</a></li>
                </ul>
            </div>
            <div class="col-lg-4">
                <h5 class="text-white fw-bold mb-4" style="font-family: 'Outfit', sans-serif;">Newsletter</h5>
                <p class="small" style="color: #94a3b8;">Stay updated with recovery stories and emergency news.</p>
                <div class="position-relative mt-4">
                    <input type="email" id="globalNewsletterEmail" class="form-control glass-card rounded-pill border-0 px-4 py-3 text-white" placeholder="Enter your email" style="background: rgba(255,255,255,0.05);">
                    <button id="btnGlobalNewsletter" class="btn btn-brand position-absolute end-0 top-0 h-100 rounded-pill px-4" style="margin: 2px;">Join</button>
                </div>
                <div id="globalNewsletterSuccess" class="small mt-2 text-success" style="display:none;"><i class="fa-solid fa-check-circle me-1"></i> Subscribed successfully!</div>
                <div id="globalNewsletterError" class="small mt-2 text-danger" style="display:none;"><i class="fa-solid fa-triangle-exclamation me-1"></i> Failed. Try again.</div>
            </div>
        </div>
        <div class="pt-5 mt-5 border-top border-secondary border-opacity-25 text-center">
            <p class="small mb-0" style="color: #94a3b8;">&copy; 2026 LifeFlow. Developed with <i class="fa-solid fa-heart text-danger"></i> for Humanity.</p>
        </div>
    </div>
</footer>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Sticky Navbar Logic (if present)
        const navbar = document.querySelector('.navbar-floating');
        if (navbar) {
            window.addEventListener('scroll', () => {
                if (window.scrollY > 50) {
                    navbar.style.top = '10px';
                    navbar.style.margin = '0 10px';
                } else {
                    navbar.style.top = '20px';
                    navbar.style.margin = '0 20px';
                }
            });
        }

        // Global Newsletter Submission Logic
        const btnNewsletter = document.getElementById('btnGlobalNewsletter');
        if (btnNewsletter) {
            btnNewsletter.addEventListener('click', async function() {
                const emailInput = document.getElementById('globalNewsletterEmail');
                const email = emailInput.value.trim();
                const successMsg = document.getElementById('globalNewsletterSuccess');
                const errorMsg = document.getElementById('globalNewsletterError');
                
                if (!email || !email.includes('@')) {
                    alert('Please enter a valid email address.');
                    return;
                }
                
                // State update
                this.disabled = true;
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';
                successMsg.style.display = 'none';
                errorMsg.style.display = 'none';
                
                try {
                    const ctx = '<%= request.getContextPath() %>';
                    const response = await fetch(ctx + '/NewsletterServlet', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'email=' + encodeURIComponent(email)
                    });
                    
                    const result = await response.json();
                    
                    if (result.success) {
                        this.innerHTML = '<i class="fa-solid fa-check"></i>';
                        this.classList.replace('btn-brand', 'btn-success');
                        successMsg.style.display = 'block';
                        emailInput.value = '';
                    } else {
                        throw new Error(result.message);
                    }
                } catch (err) {
                    this.disabled = false;
                    this.innerHTML = originalText;
                    errorMsg.style.display = 'block';
                }
            });
        }
    });
</script>
