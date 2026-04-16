package com.bloodbank.servlets;

import com.bloodbank.util.FirebaseConfig;
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
import java.io.IOException;
import java.io.PrintWriter;

public class DonorLocatorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String bloodGroup = request.getParameter("bloodGroup");
        String city = request.getParameter("city");

        if (bloodGroup == null || bloodGroup.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"bloodGroup is required\"}");
            return;
        }

        PrintWriter out = response.getWriter();
        try {
            Firestore db = FirebaseConfig.getFirestore();
            if (db == null) throw new Exception("Firestore is null.");

            // Query for approved donors of the same blood group
            Query query = db.collection("users")
                    .whereEqualTo("role", "DONOR")
                    .whereEqualTo("status", "APPROVED")
                    .whereEqualTo("blood_group", bloodGroup);

            if (city != null && !city.trim().isEmpty()) {
                query = query.whereEqualTo("city", city);
            }

            QuerySnapshot snapshot = query.get().get();
            JSONArray arr = new JSONArray();

            for (QueryDocumentSnapshot doc : snapshot.getDocuments()) {
                JSONObject donor = new JSONObject();
                donor.put("name", doc.getString("full_name"));
                donor.put("city", doc.getString("city"));
                donor.put("phone", doc.getString("phone"));
                donor.put("email", doc.getString("email"));
                donor.put("bloodGroup", doc.getString("blood_group"));
                arr.put(donor);
            }

            out.print(arr.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String msg = (e.getMessage() != null) ? e.getMessage().replace("\"", "'") : e.toString();
            out.print("{\"error\": \"" + msg + "\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
}
