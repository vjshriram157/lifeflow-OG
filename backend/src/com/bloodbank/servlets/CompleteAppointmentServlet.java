package com.bloodbank.servlets;

import com.bloodbank.util.FirebaseConfig;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.FieldValue;
import com.google.cloud.firestore.QuerySnapshot;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/CompleteAppointmentServlet")
public class CompleteAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔐 Ensure only BANK can do this
        HttpSession session = request.getSession(false);
        if (session == null || !"BANK".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId == null || appointmentId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String bankUserId = (String) session.getAttribute("userId");

        try {
            Firestore db = FirebaseConfig.getFirestore();

            // ✅ Step 1: Get correct bank user email from users table
            DocumentSnapshot userDoc = db.collection("users").document(bankUserId).get().get();
            if (!userDoc.exists()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            String email = userDoc.getString("email");

            // ✅ Step 2: Get correct bank_id from blood_banks table
            QuerySnapshot bankSnapshot = db.collection("blood_banks")
                    .whereEqualTo("email", email)
                    .get().get();

            if (bankSnapshot.isEmpty()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            String bankId = bankSnapshot.getDocuments().get(0).getId();

            // ✅ Step 3: Check and Update that bank's appointment
            DocumentSnapshot apptDoc = db.collection("appointments").document(appointmentId).get().get();
            if (apptDoc.exists() && bankId.equals(apptDoc.getString("bank_id"))) {
                db.collection("appointments").document(appointmentId).update("status", "COMPLETED").get();
                
                // 📧 Automated Thank You Email & 🏆 Gamification Scoring
                try {
                    String donorId = apptDoc.getString("donor_id");
                    DocumentSnapshot donorDoc = db.collection("users").document(donorId).get().get();
                    String donorEmail = donorDoc.getString("email");
                    String donorName = donorDoc.getString("full_name");
                    
                    DocumentSnapshot bankMeta = db.collection("blood_banks").document(bankId).get().get();
                    String bankName = bankMeta.getString("bank_name");
                    
                    // Add 50 points and 1 donation to the user profile
                    db.collection("users").document(donorId).update(
                        "impact_score", FieldValue.increment(50),
                        "donation_count", FieldValue.increment(1)
                    );
                    
                    com.bloodbank.util.EmailService.sendDonationThankYou(donorEmail, donorName, bankName);
                } catch (Exception e) {
                    System.err.println("Thank you email or gamification update failed: " + e.getMessage());
                }
            }

        } catch (Exception e) {
            throw new ServletException("Failed to complete appointment", e);
        }

        // 🔁 Back to bank dashboard
        response.sendRedirect(request.getContextPath() + "/dashboard/bank/home.jsp");
    }
}
