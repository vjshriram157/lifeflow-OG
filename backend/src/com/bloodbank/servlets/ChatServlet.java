package com.bloodbank.servlets;

import com.bloodbank.util.FirebaseConfig;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet(name = "ChatServlet", urlPatterns = { "/api/chat" })
public class ChatServlet extends HttpServlet {

    private static String GEMINI_API_KEY = "AIzaSyAYWLPTNKJDDOf2SUFOFL1HKLiojI2WAb4";
    private static String GEMINI_MODEL = "gemini-1.5-flash";
    
    static {
        java.util.Properties props = new java.util.Properties();
        java.io.File configFile = new java.io.File("backend/ai_config.properties");
        if (!configFile.exists()) configFile = new java.io.File("ai_config.properties");
        
        if (configFile.exists()) {
            try (java.io.FileInputStream fis = new java.io.FileInputStream(configFile)) {
                props.load(fis);
                String key = props.getProperty("gemini.api.key");
                if (key != null && !key.trim().isEmpty()) GEMINI_API_KEY = key;
                String model = props.getProperty("ai.model");
                if (model != null && !model.trim().isEmpty()) GEMINI_MODEL = model;
                System.out.println("🤖 AI CHAT: Config loaded from " + configFile.getAbsolutePath());
            } catch (java.io.IOException e) {
                System.err.println("🤖 AI CHAT: Config load error: " + e.getMessage());
            }
        }
    }

    private static String getGeminiUrl() {
        return "https://generativelanguage.googleapis.com/v1beta/models/" + GEMINI_MODEL + ":generateContent?key=" + GEMINI_API_KEY;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject jsonResponse = new JSONObject();

        String userMessage = request.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            jsonResponse.put("error", "Message cannot be empty.");
            response.getWriter().print(jsonResponse.toString());
            return;
        }

        System.out.println("🤖 AI CHAT: Received message: " + userMessage);

        HttpSession session = request.getSession(false);
        String userId = session != null ? (String) session.getAttribute("userId") : null;
        String role = session != null ? (String) session.getAttribute("role") : "Guest";

        StringBuilder contextBuilder = new StringBuilder();
        contextBuilder.append("User Role: ").append(role).append(". ");

        // LEVEL 2 DATA AWARENESS
        try {
            Firestore db = FirebaseConfig.getFirestore();
            if (userId != null) {
                DocumentSnapshot userDoc = db.collection("users").document(userId).get().get();
                if (userDoc.exists()) {
                    String name = userDoc.getString("full_name");
                    String bg = userDoc.getString("blood_group");
                    contextBuilder.append("Name: ").append(name != null ? name : "Unknown").append(". ");
                    if (bg != null) contextBuilder.append("Blood Group: ").append(bg).append(". ");
                }
            }

            QuerySnapshot emergencies = db.collection("emergency_alerts").get().get();
            if (!emergencies.isEmpty()) {
                contextBuilder.append("Number of Active Emergency Alerts: ").append(emergencies.size()).append(". ");
            }
            
            // Add Platform Stats for smarter answers
            long countDonors = db.collection("users").whereEqualTo("role", "DONOR").get().get().size();
            long countBanks = db.collection("blood_banks").get().get().size();
            contextBuilder.append("Total Registered Donors: ").append(countDonors).append(". ");
            contextBuilder.append("Total Partnered Blood Banks: ").append(countBanks).append(". ");
            
        } catch (Exception e) {
            System.err.println("🤖 AI CHAT: Context loading warning: " + e.getMessage());
        }

        try {
            // Attempt Gemini API Call
            System.out.println("🤖 AI CHAT: [Phase 1] Attempting Gemini API using key: " + GEMINI_API_KEY.substring(0, 8) + "...");
            URL url = new URL(getGeminiUrl());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setConnectTimeout(3000); // Faster timeout
            conn.setReadTimeout(3000);
            conn.setDoOutput(true);

            JSONObject part = new JSONObject();
            part.put("text", "System: You are LifeFlow Assistant. " + contextBuilder.toString() + "\nUser: " + userMessage);

            JSONObject payload = new JSONObject();
            JSONArray contents = new JSONArray();
            JSONObject content = new JSONObject();
            content.put("parts", new JSONArray().put(part));
            contents.put(content);
            payload.put("contents", contents);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(payload.toString().getBytes("utf-8"));
            }

            int code = conn.getResponseCode();
            System.out.println("🤖 AI CHAT: [Phase 2] Gemini response status: " + code);

            if (code == 200) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
                StringBuilder res = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) res.append(line.trim());
                
                JSONObject geminiResponse = new JSONObject(res.toString());
                String replyText = geminiResponse.getJSONArray("candidates")
                        .getJSONObject(0).getJSONObject("content")
                        .getJSONArray("parts").getJSONObject(0).getString("text");

                jsonResponse.put("reply", replyText);
            } else {
                System.out.println("🤖 AI CHAT: [Phase 2] Gemini failed/denied. Switching to Fallback...");
                jsonResponse.put("reply", provideLocalFallback(userMessage, role, contextBuilder.toString()));
            }
        } catch (Exception e) {
            System.err.println("🤖 AI CHAT: [Phase 1 Exception] " + e.getMessage());
            jsonResponse.put("reply", provideLocalFallback(userMessage, role, contextBuilder.toString()));
        }

        System.out.println("🤖 AI CHAT: [Phase 3] Sending final JSON response.");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().print(jsonResponse.toString());
        response.getWriter().flush();
        System.out.println("🤖 AI CHAT: [Completed] Servlet handling finished.");
    }

    /**
     * Intelligent local fallback for base-level assistance when AI is unavailable.
     */
    private String provideLocalFallback(String msg, String role, String context) {
        msg = msg.toLowerCase();
        
        if (msg.contains("hi") || msg.contains("hello") || msg.contains("hey")) {
            return "Hello! I'm the LifeFlow Assistant. I'm currently operating in **Offline Mode** due to high traffic, but I can still help you with basic questions!";
        }
        
        if (msg.contains("donate") || msg.contains("registration") || msg.contains("become a donor")) {
            return "To become a donor, please visit the [Registration Page](register.jsp). You'll need to provide your details and verify your email via OTP. Once approved by our admin, you can start booking appointments!";
        }
        
        if (msg.contains("appointment") || msg.contains("book")) {
            if ("DONOR".equalsIgnoreCase(role)) {
                return "As a registered donor, you can book an appointment from your Dashboard. Just select a nearby blood bank and pick a time slot that works for you.";
            } else {
                return "You need to be a registered and approved Donor to book appointments. Please [Sign Up](register.jsp) first!";
            }
        }
        
        if (msg.contains("blood") || msg.contains("stock") || msg.contains("group")) {
            return "You can check real-time blood availability by using our [Blood Bank Locator](findBloodBank.jsp). Simply select your required blood group and city.";
        }
        
        if (msg.contains("emergency") || msg.contains("urgent") || msg.contains("crisis")) {
            return "🚨 **Emergency Situations:** For urgent blood requirements, please check the 'Emergency Alerts' section in your dashboard or visit the nearest Blood Bank immediately.";
        }

        if (msg.contains("admin") || msg.contains("approval")) {
            return "Admin approvals usually take 24-48 hours. If you've just registered, please keep an eye on your email for the confirmation notification.";
        }

        return "I understand you're asking about '" + msg + "'. While I'm in Offline Mode, I can mainly help with: \n*   How to **donate** or register\n*   Finding **blood stock**\n*   **Booking** appointments\n*   **Emergency** alerts\n\nIs there anything specific among these I can help with?";
    }
}
