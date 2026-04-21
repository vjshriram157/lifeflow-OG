<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Floating Chatbot Widget -->
<div id="ai-chat-container">
    <button id="ai-chat-btn" class="btn btn-premium rounded-circle shadow-lg" onclick="toggleChat()">
        <i class="fa-solid fa-robot fs-4"></i>
    </button>
    <div id="ai-chat-window" class="card border-0 shadow-lg d-none fade-in-up">
        <div class="card-header bg-premium text-white d-flex justify-content-between align-items-center" style="border-radius: 1rem 1rem 0 0;">
            <div class="d-flex align-items-center">
                <i class="fa-solid fa-robot fs-4 me-2"></i>
                <h6 class="mb-0 fw-bold">LifeFlow Assistant</h6>
            </div>
            <button class="btn btn-sm btn-link text-white text-decoration-none" onclick="toggleChat()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="card-body p-3" id="ai-chat-messages" style="height: 350px; overflow-y: auto; background: #f8fafc; font-size: 0.9rem;">
            <!-- Welcome message -->
            <div class="d-flex mb-3">
                <div class="bg-light p-2 rounded-3 shadow-sm" style="max-width: 85%; border-left: 3px solid #e11d48;">
                    Hello! I'm your LifeFlow AI Assistant. 🩺<br>I have specific context about your account and blood stocks. How can I help you today?
                </div>
            </div>
        </div>
        <div class="card-footer border-0 bg-white" style="border-radius: 0 0 1rem 1rem;">
            <div class="input-group">
                <input type="text" id="ai-chat-input" class="form-control form-control-sm rounded-pill px-3" placeholder="Ask me anything..." onkeypress="handleKey(event)">
                <button class="btn btn-sm btn-premium text-white rounded-circle ms-2" onclick="sendMessage()"><i class="fa-solid fa-paper-plane"></i></button>
            </div>
            <div class="text-center mt-2" style="font-size: 0.7rem; color: #94a3b8;">Powered by Gemini AI</div>
        </div>
    </div>
</div>

<style>
    #ai-chat-container {
        position: fixed;
        bottom: 30px;
        right: 30px;
        z-index: 1050;
    }
    #ai-chat-btn {
        width: 60px;
        height: 60px;
        transition: transform 0.2s;
    }
    #ai-chat-btn:hover {
        transform: scale(1.1);
    }
    #ai-chat-window {
        position: absolute;
        bottom: 75px;
        right: 0;
        width: 350px;
        border-radius: 1rem;
        transform-origin: bottom right;
    }
    .user-msg {
        background-color: #e11d48;
        color: white;
        padding: 8px 12px;
        border-radius: 12px 12px 0 12px;
        max-width: 85%;
        margin-left: auto;
        word-wrap: break-word;
    }
    .bot-msg {
        background-color: white;
        color: #333;
        padding: 8px 12px;
        border-radius: 12px 12px 12px 0;
        max-width: 85%;
        border-left: 3px solid #e11d48;
        word-wrap: break-word;
    }
    .typing-indicator span {
        display: inline-block;
        width: 5px;
        height: 5px;
        background-color: #e11d48;
        border-radius: 50%;
        margin-right: 3px;
        animation: typing 1s infinite;
    }
    .typing-indicator span:nth-child(2) { animation-delay: 0.2s; }
    .typing-indicator span:nth-child(3) { animation-delay: 0.4s; }
    @keyframes typing { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-5px); } }
    
    /* Ensure markdown lists stay small */
    .bot-msg ul { padding-left: 20px; margin-bottom: 0; }
    .bot-msg p { margin-bottom: 5px; }
</style>

<script>
    const chatWindow = document.getElementById('ai-chat-window');
    const chatInput = document.getElementById('ai-chat-input');
    const msgBox = document.getElementById('ai-chat-messages');

    function toggleChat() {
        chatWindow.classList.toggle('d-none');
        if (!chatWindow.classList.contains('d-none')) {
            chatInput.focus();
        }
    }

    function handleKey(e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    }

    function appendMessage(text, isUser) {
        const div = document.createElement('div');
        div.className = "d-flex mb-3";
        div.innerHTML = `<div class="${isUser ? 'user-msg shadow-sm' : 'bot-msg shadow-sm'}">${text}</div>`;
        msgBox.appendChild(div);
        msgBox.scrollTop = msgBox.scrollHeight;
    }

    function showTyping() {
        const div = document.createElement('div');
        div.id = "typing-indicator";
        div.className = "d-flex mb-3";
        div.innerHTML = `<div class="bot-msg shadow-sm typing-indicator"><span></span><span></span><span></span></div>`;
        msgBox.appendChild(div);
        msgBox.scrollTop = msgBox.scrollHeight;
    }

    function removeTyping() {
        const el = document.getElementById("typing-indicator");
        if (el) el.remove();
    }

    function formatMarkdown(text) {
        let html = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        html = html.replace(/\*(.*?)\*/g, '<em>$1</em>');
        html = html.replace(/\n\n/g, '</p><p>');
        html = html.replace(/\n\*/g, '<br>•');
        return '<p>' + html + '</p>';
    }

    function sendMessage() {
        const msg = chatInput.value.trim();
        if(!msg) return;

        appendMessage(msg, true);
        chatInput.value = '';
        showTyping();

        fetch('<%= request.getContextPath() %>/api/chat', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: new URLSearchParams({"message": msg})
        })
        .then(res => res.json())
        .then(data => {
            removeTyping();
            if(data.error) {
                appendMessage("<span class='text-danger'>Error: " + data.error + "</span>", false);
            } else {
                appendMessage(formatMarkdown(data.reply), false);
            }
        })
        .catch(err => {
            removeTyping();
            appendMessage("<span class='text-danger'>Connection error.</span>", false);
        });
    }
</script>
