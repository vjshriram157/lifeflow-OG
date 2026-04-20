<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- LifeFlow Premium Splash Preloader -->
<div id="splash-overlay" class="splash-overlay">
    <div id="splash-logo-container" class="splash-logo-container">
        <div class="splash-logo-wrapper">
             <i class="fa-solid fa-heart-pulse splash-heart"></i>
             <span id="splash-text" class="splash-text"></span>
             <span class="typing-cursor">|</span>
        </div>
    </div>
</div>

<style>
    :root {
        --navbar-logo-top: 32px;
        --navbar-logo-left: 65px;
        --splash-bg: #020617;
    }

    .splash-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: radial-gradient(circle at center, #0f172a 0%, var(--splash-bg) 100%);
        z-index: 9999;
        display: flex;
        justify-content: center;
        align-items: center;
        transition: opacity 0.8s ease-out;
    }

    .splash-logo-container {
        display: flex;
        align-items: center;
        transition: all 1.2s cubic-bezier(0.77, 0, 0.175, 1);
        z-index: 10000;
    }

    .splash-logo-wrapper {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .splash-heart {
        font-size: 4rem;
        color: #e11d48;
        filter: drop-shadow(0 0 15px rgba(225, 29, 72, 0.4));
        animation: heartbeat-splash 1.5s ease-in-out infinite;
    }

    .splash-text {
        font-family: 'Outfit', sans-serif;
        font-size: 4.5rem;
        font-weight: 800;
        color: #fff;
        letter-spacing: -1px;
    }

    .typing-cursor {
        font-size: 4.5rem;
        color: #e11d48;
        font-weight: 300;
        animation: blink-splash 0.8s step-end infinite;
    }

    @keyframes heartbeat-splash {
        0%, 100% { transform: scale(1); filter: drop-shadow(0 0 15px rgba(225, 29, 72, 0.4)); }
        15% { transform: scale(1.15); filter: drop-shadow(0 0 25px rgba(225, 29, 72, 0.6)); }
        30% { transform: scale(1); }
        45% { transform: scale(1.1); }
    }

    @keyframes blink-splash {
        from, to { opacity: 1; }
        50% { opacity: 0; }
    }

    /* Transitioning State */
    .splash-overlay.levitate-exit {
        opacity: 0;
        pointer-events: none;
    }

    .splash-logo-container.move-to-nav {
        position: fixed;
        top: var(--navbar-logo-top) !important;
        left: var(--navbar-logo-left) !important;
        transform: translate(0, 0) scale(0.4) !important;
        margin: 0 !important;
    }

    /* Initial Site Content State */
    body.is-loading #main-wrapper { opacity: 0; }
    body.is-ready #main-wrapper { 
        opacity: 1; 
        transition: opacity 1s ease-in;
    }
</style>

<script>
    (function() {
        const checkPlayed = sessionStorage.getItem('lifeflow_splash_played');
        const overlay = document.getElementById('splash-overlay');
        const logo = document.getElementById('splash-logo-container');
        const textEl = document.getElementById('splash-text');
        const cursor = document.querySelector('.typing-cursor');
        const fullText = "LifeFlow";
        
        if (checkPlayed) {
            overlay.style.display = 'none';
            document.body.classList.add('is-ready');
            return;
        }

        document.body.classList.add('is-loading');

        let charIndex = 0;
        function type() {
            if (charIndex < fullText.length) {
                textEl.textContent += fullText.charAt(charIndex);
                charIndex++;
                setTimeout(type, 150); // "Slightly slow typing"
            } else {
                // Done typing
                setTimeout(() => {
                    cursor.style.display = 'none';
                    startLevitation();
                }, 1000); // "Wait 1 second"
            }
        }

        function startLevitation() {
            // Calculate starting position relative to viewport before fixed move
            const rect = logo.getBoundingClientRect();
            logo.style.position = 'fixed';
            logo.style.top = rect.top + 'px';
            logo.style.left = rect.left + 'px';
            logo.style.margin = '0';
            
            // Force reflow
            logo.offsetHeight;

            // Trigger animations
            logo.classList.add('move-to-nav');
            overlay.classList.add('levitate-exit');
            
            setTimeout(() => {
                document.body.classList.remove('is-loading');
                document.body.classList.add('is-ready');
                sessionStorage.setItem('lifeflow_splash_played', 'true');
                
                // Final cleanup
                setTimeout(() => {
                    overlay.style.display = 'none';
                }, 1000);
            }, 800); 
        }

        // Start initial fade-in of logo
        setTimeout(() => {
            type();
        }, 500);

    })();
</script>
