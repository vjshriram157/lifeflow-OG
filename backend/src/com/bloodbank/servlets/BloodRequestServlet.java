package com.bloodbank.servlets;

import com.bloodbank.util.FirebaseConfig;
import com.bloodbank.util.FcmClient;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
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
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BloodRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        String requesterId = (String) session.getAttribute("userId");
        String bloodGroup = request.getParameter("bloodGroup");
        String hospitalName = request.getParameter("hospitalName");
        String city = request.getParameter("city");
        String urgency = request.getParameter("urgency");
        String message = request.getParameter("message");
        String unitsStr = request.getParameter("units");

        try (PrintWriter out = response.getWriter()) {
            if (bloodGroup == null || hospitalName == null || city == null || urgency == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"All fields except message are required\"}");
                return;
            }

            Firestore db = FirebaseConfig.getFirestore();
            
            Map<String, Object> reqData = new HashMap<>();
            reqData.put("requester_id", requesterId);
            reqData.put("blood_group", bloodGroup);
            reqData.put("hospital_name", hospitalName);
            reqData.put("city", city);
            reqData.put("urgency", urgency);
            reqData.put("message", message != null ? message : "");
            reqData.put("units", unitsStr != null ? unitsStr : "1");
            reqData.put("status", "PENDING");
            reqData.put("created_at", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

            DocumentReference docRef = db.collection("blood_requests").document();
            docRef.set(reqData).get();

            // Notify nearby donors with SAME blood group
            triggerNotifications(db, bloodGroup, city, requesterId, docRef.getId(), hospitalName, urgency);

            out.print("{\"status\": \"OK\", \"requestId\": \"" + docRef.getId() + "\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void triggerNotifications(Firestore db, String bloodGroup, String city, String requesterId, String requestId, String hospitalName, String urgency) {
        try {
            // Simple city-based notification for now
            QuerySnapshot donors = db.collection("users")
                    .whereEqualTo("blood_group", bloodGroup)
                    .whereEqualTo("city", city)
                    .whereEqualTo("role", "DONOR")
                    .whereEqualTo("status", "APPROVED")
                    .get().get();

            List<String> tokens = new ArrayList<>();
            List<String> bccEmails = new ArrayList<>();
            for (QueryDocumentSnapshot donor : donors.getDocuments()) {
                if (donor.getId().equals(requesterId)) continue;
                
                // Track emails for dispatch
                String email = donor.getString("email");
                if (email != null && !email.isEmpty()) bccEmails.add(email);

                // Fetch device token
                com.google.cloud.firestore.DocumentSnapshot tokenDoc = db.collection("device_tokens").document(donor.getId()).get().get();
                if (tokenDoc.exists()) {
                    String t = tokenDoc.getString("device_token");
                    if (t != null) tokens.add(t);
                }
            }

            // 📱 Mobile Push Notifications
            if (!tokens.isEmpty()) {
                FcmClient.sendEmergencyAlertToDevices(
                        tokens,
                        "Urgent Blood Needed: " + bloodGroup,
                        "A patient at " + city + " needs blood urgently. Tap for details.",
                        requestId,
                        null, // bankId is null for peer requests
                        bloodGroup
                );
            }

            // 📧 Email Notifications
            if (!bccEmails.isEmpty()) {
                com.bloodbank.util.EmailService.sendPeerEmergencyEmail(bccEmails, bloodGroup, city, hospitalName, urgency);
            }

            // 📧 Notify Admin (Always informed of emergencies)
            if ("Emergency".equalsIgnoreCase(urgency)) {
                com.bloodbank.util.EmailService.notifyAdminOfEmergency(bloodGroup, hospitalName, city, "New Peer-to-Peer emergency raised.", "Donor/Patient");
            }
        } catch (Exception e) {
            System.err.println("Notification failed: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String bloodGroup = request.getParameter("bloodGroup");
        String city = request.getParameter("city");

        PrintWriter out = response.getWriter();
        try {
            Firestore db = FirebaseConfig.getFirestore();
            if (db == null) {
                throw new Exception("Firestore database is null. Initialization must have failed.");
            }
            
            Query query = db.collection("blood_requests").whereEqualTo("status", "PENDING");

            if (bloodGroup != null && !bloodGroup.isEmpty()) {
                query = query.whereEqualTo("blood_group", bloodGroup);
            }
            if (city != null && !city.isEmpty()) {
                query = query.whereEqualTo("city", city);
            }

            QuerySnapshot snapshot = query.limit(50).get().get();
            JSONArray arr = new JSONArray();

            for (QueryDocumentSnapshot doc : snapshot.getDocuments()) {
                Map<String, Object> data = doc.getData();
                if (data == null) continue;
                JSONObject obj = new JSONObject(data);
                obj.put("id", doc.getId());
                
                // Fetch Requester Name from users collection
                String reqId = (String) data.get("requester_id");
                if (reqId != null) {
                    try {
                        com.google.cloud.firestore.DocumentSnapshot userDoc = db.collection("users").document(reqId).get().get();
                        if (userDoc.exists()) {
                            obj.put("full_name", userDoc.getString("full_name"));
                        }
                    } catch (Exception e) {
                        System.err.println("User fetch failed for " + reqId + " : " + e.getMessage());
                    }
                }
                
                arr.put(obj);
            }

            out.print(arr.toString());
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("API Error: " + e.toString());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String msg = (e.getMessage() != null) ? e.getMessage().replace("\"", "'") : e.toString();
            out.print("{\"error\": \"" + msg + "\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
}
