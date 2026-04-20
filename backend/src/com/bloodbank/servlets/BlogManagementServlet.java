package com.bloodbank.servlets;

import com.bloodbank.util.FirebaseConfig;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import com.google.api.core.ApiFuture;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class BlogManagementServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            result.addProperty("error", "Unauthorized access.");
            out.print(gson.toJson(result));
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.addProperty("error", "Action parameter is missing.");
            out.print(gson.toJson(result));
            return;
        }

        try {
            Firestore db = FirebaseConfig.getFirestore();

            if ("create".equalsIgnoreCase(action)) {
                String title = request.getParameter("title");
                String category = request.getParameter("category");
                String excerpt = request.getParameter("excerpt");
                String content = request.getParameter("content");
                String imageUrl = request.getParameter("imageUrl");

                if (title == null || content == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    result.addProperty("error", "Title and content are required.");
                    out.print(gson.toJson(result));
                    return;
                }
                
                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    imageUrl = "https://images.unsplash.com/photo-1505751172107-573220a964d6?q=80&w=2070";
                }

                String id = UUID.randomUUID().toString();
                Map<String, Object> blogData = new HashMap<>();
                blogData.put("id", id);
                blogData.put("title", title);
                blogData.put("category", category != null ? category : "General");
                blogData.put("excerpt", excerpt != null ? excerpt : "");
                blogData.put("content", content);
                blogData.put("imageUrl", imageUrl);
                blogData.put("author", "LifeFlow Medical Team");
                blogData.put("timestamp", com.google.cloud.Timestamp.now());

                ApiFuture<WriteResult> future = db.collection("health_blogs").document(id).set(blogData);
                future.get(); // block until completion

                result.addProperty("success", true);
                result.addProperty("message", "Blog created successfully");
                result.addProperty("id", id);

            } else if ("delete".equalsIgnoreCase(action)) {
                String id = request.getParameter("id");
                if (id == null || id.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    result.addProperty("error", "Blog ID is required for deletion.");
                    out.print(gson.toJson(result));
                    return;
                }

                ApiFuture<WriteResult> future = db.collection("health_blogs").document(id).delete();
                future.get(); // block until completion

                result.addProperty("success", true);
                result.addProperty("message", "Blog deleted successfully");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                result.addProperty("error", "Invalid action.");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            result.addProperty("error", "Server Error: " + e.getMessage());
            e.printStackTrace();
        }

        out.print(gson.toJson(result));
    }
}
