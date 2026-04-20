package com.bloodbank.servlets;

import com.bloodbank.util.FirebaseConfig;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@WebServlet(name = "NewsletterServlet", urlPatterns = {"/NewsletterServlet"})
public class NewsletterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        if (email != null) email = email.trim();

        if (email == null || email.isEmpty() || !email.contains("@")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid email address.\"}");
            return;
        }

        try {
            Firestore db = FirebaseConfig.getFirestore();
            if (db == null) {
                throw new IllegalStateException("Firestore is not initialized.");
            }

            // Check if email already exists
            ApiFuture<QuerySnapshot> future = db.collection("subscribers").whereEqualTo("email", email).get();
            if (!future.get().isEmpty()) {
                response.getWriter().write("{\"success\": true, \"message\": \"You are already subscribed!\"}");
                return;
            }

            // Add new subscriber
            Map<String, Object> data = new HashMap<>();
            data.put("email", email);
            data.put("timestamp", System.currentTimeMillis());
            data.put("status", "ACTIVE");

            ApiFuture<DocumentReference> addedDocRef = db.collection("subscribers").add(data);
            addedDocRef.get(); // Wait for completion

            response.getWriter().write("{\"success\": true, \"message\": \"Thank you for subscribing!\"}");

        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Subscription failed. Please try again later.\"}");
        }
    }
}
