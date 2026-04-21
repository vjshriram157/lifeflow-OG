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

    // ⚠️ IMPORTANT: Get a free key from aistudio.google.com and paste it here!
    private static final String GEMINI_API_KEY = "AIzaSyAYWLPTNKJDDOf2SUFOFL1HKLiojI2WAb4";
    private static final String GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-latest:generateContent?key=" + GEMINI_API_KEY;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject jsonResponse = new JSONObject();

        String userMessage = request.getParameter("message");
        System.out.println("🤖 AI CHAT: Received message: " + userMessage);

        if (userMessage == null || userMessage.trim().isEmpty()) {
            jsonResponse.put("error", "Message cannot be empty.");
            response.getWriter().print(jsonResponse.toString());
            return;
        }

        if ("YOUR_GEMINI_API_KEY_HERE".equals(GEMINI_API_KEY)) {
            jsonResponse.put("reply",
                    "⚠️ **Setup Required:** The AI is not connected yet. Please generate a free Google Gemini API key and paste it into `ChatServlet.java`.");
            response.getWriter().print(jsonResponse.toString());
            return;
        }

        HttpSession session = request.getSession(false);
        String userId = session != null ? (String) session.getAttribute("userId") : null;
        String role = session != null ? (String) session.getAttribute("role") : "Guest";

        StringBuilder contextBuilder = new StringBuilder();
        contextBuilder.append("You are the LifeFlow AI Assistant, an expert in blood donation and crisis management. ");
        contextBuilder.append("Be highly helpful, concise, and professional. ");
        contextBuilder.append("The current user's role is: ").append(role).append(". ");

        // LEVEL 2 DATA AWARENESS
        try {
            Firestore db = FirebaseConfig.getFirestore();

            // 1. User specific context
            if (userId != null) {
                DocumentSnapshot userDoc = db.collection("users").document(userId).get().get();
                if (userDoc.exists()) {
                    String name = userDoc.getString("full_name");
                    String bg = userDoc.getString("blood_group");
                    contextBuilder.append("Their name is ").append(name != null ? name : "Unknown").append(". ");
                    if (bg != null)
                        contextBuilder.append("Their blood group is ").append(bg).append(". ");

                    // If Donor, check appointments
                    if ("DONOR".equalsIgnoreCase(role)) {
                        QuerySnapshot apptSnap = db.collection("appointments").whereEqualTo("donor_id", userId).get()
                                .get();
                        int apptCount = apptSnap.size();
                        contextBuilder.append("They have ").append(apptCount)
                                .append(" historical/upcoming appointments. ");
                    }
                }
            }

            // 2. Global Emergency Context
            QuerySnapshot emergencies = db.collection("emergency_alerts").get().get();
            if (!emergencies.isEmpty()) {
                contextBuilder.append("\nCurrently Active Emergencies: ");
                for (QueryDocumentSnapshot em : emergencies.getDocuments()) {
                    String bg = em.getString("blood_group");
                    String msg = em.getString("message");
                    contextBuilder.append("[Needs ").append(bg).append(": '").append(msg).append("'] ");
                }
            } else {
                contextBuilder.append("\nThere are no active blood emergencies currently reported.");
            }

        } catch (Exception e) {
            contextBuilder.append(" (Could not load realtime database context).");
        }

        contextBuilder.append(
                "\n\nAnswer the user's question clearly. Use simple bullet points if needed. Do not output raw JSON, just text.");

        try {
            // Call Gemini API
            URL url = new URL(GEMINI_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            JSONObject part = new JSONObject();
            // Pre-Prompt Technique: Combine instructions with the user message for v1 stability
            part.put("text", "CONTEXT: " + contextBuilder.toString() + "\n\nUSER QUESTION: " + userMessage);

            JSONArray parts = new JSONArray();
            parts.put(part);

            JSONObject content = new JSONObject();
            content.put("role", "user");
            content.put("parts", parts);

            JSONArray contents = new JSONArray();
            contents.put(content);

            JSONObject payload = new JSONObject();
            payload.put("contents", contents);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.toString().getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            System.out.println("🤖 AI CHAT: Sending request to Gemini...");
            int code = conn.getResponseCode();
            System.out.println("🤖 AI CHAT: Gemini response code: " + code);

            if (code == 200) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
                StringBuilder responseString = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    responseString.append(responseLine.trim());
                }

                System.out.println("🤖 AI CHAT: Raw Gemini response: " + responseString.toString());
                JSONObject geminiResponse = new JSONObject(responseString.toString());
                String replyText = geminiResponse.getJSONArray("candidates")
                        .getJSONObject(0)
                        .getJSONObject("content")
                        .getJSONArray("parts")
                        .getJSONObject(0)
                        .getString("text");

                jsonResponse.put("reply", replyText);
            } else {
                // READ ERROR STREAM
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
                StringBuilder errorResponse = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    errorResponse.append(line.trim());
                }
                System.out.println("🤖 AI CHAT: Gemini Error Detail: " + errorResponse.toString());
                jsonResponse.put("error", "AI Server error " + code + ": " + errorResponse.toString());
            }

            response.getWriter().print(jsonResponse.toString());

        } catch (Exception e) {
            System.err.println("🤖 AI CHAT: CRITICAL ERROR: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.put("error", "AI Connection Failed: " + e.getMessage());
            response.getWriter().print(jsonResponse.toString());
        }
    }
}
