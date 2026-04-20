package com.bloodbank.scratch;

import com.bloodbank.util.FirebaseConfig;
import com.google.cloud.firestore.*;
import java.util.List;

public class DebugUsers {
    public static void main(String[] args) {
        try {
            Firestore db = FirebaseConfig.getFirestore();
            System.out.println("--- USERS COLLECTION ---");
            List<QueryDocumentSnapshot> docs = db.collection("users").get().get().getDocuments();
            for (QueryDocumentSnapshot doc : docs) {
                System.out.println("ID: " + doc.getId() + " | Name: " + doc.getString("full_name") + " | Email: " + doc.getString("email"));
            }
            
            System.out.println("\n--- BLOOD REQUESTS ---");
            List<QueryDocumentSnapshot> reqs = db.collection("blood_requests").get().get().getDocuments();
            for (QueryDocumentSnapshot req : reqs) {
                System.out.println("ReqID: " + req.getId() + " | RequesterID: " + req.getString("requester_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
