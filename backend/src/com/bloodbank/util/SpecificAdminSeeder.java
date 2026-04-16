package com.bloodbank.util;

import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.api.core.ApiFuture;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

public class SpecificAdminSeeder {
    public static void main(String[] args) {
        String adminEmail = "lifeflowad@gmail.com";
        String adminPass = "Admin@123";
        
        System.out.println("Configuring Master Admin Account: " + adminEmail);
        try {
            Firestore db = FirebaseConfig.getFirestore();
            String passwordHash = PasswordUtil.hashPassword(adminPass);

            // Check if admin already exists
            ApiFuture<QuerySnapshot> future = db.collection("users").whereEqualTo("role", "ADMIN").get();
            List<QueryDocumentSnapshot> admins = future.get().getDocuments();

            Map<String, Object> userData = new HashMap<>();
            userData.put("full_name", "Master Admin");
            userData.put("email", adminEmail);
            userData.put("password_hash", passwordHash);
            userData.put("role", "ADMIN");
            userData.put("status", "APPROVED");
            userData.put("city", "System");

            if (admins.isEmpty()) {
                db.collection("users").add(userData).get();
                System.out.println("✅ Master Admin account CREATED successfully.");
            } else {
                // Update the first admin found or all of them? Let's just update the first one or add if email doesn't match
                boolean found = false;
                for (QueryDocumentSnapshot admin : admins) {
                    if (adminEmail.equals(admin.getString("email"))) {
                        admin.getReference().update("password_hash", passwordHash).get();
                        System.out.println("✅ Existing Admin password UPDATED for " + adminEmail);
                        found = true;
                    }
                }
                if (!found) {
                    // Change existing admin email or just add new one and remove old one?
                    // Safe approach: Add new admin
                    db.collection("users").add(userData).get();
                    System.out.println("✅ New Master Admin account ADDED.");
                    
                    // Optional: Remove old admin to avoid confusion
                    for (QueryDocumentSnapshot admin : admins) {
                        if (!adminEmail.equals(admin.getString("email"))) {
                            System.out.println("ℹ️ You may want to manually remove the old admin: " + admin.getString("email"));
                        }
                    }
                }
            }
            
            System.out.println("Done!");
            System.exit(0);
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }
}
