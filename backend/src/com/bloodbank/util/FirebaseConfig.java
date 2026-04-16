package com.bloodbank.util;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import com.google.cloud.firestore.Firestore;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class FirebaseConfig {

    private static Firestore firestore;

    static {
        try {
            // 🛡️ Robust Service Account Path Resolution
            String serviceAccountName = "lifeflow-30d1a-firebase-adminsdk-fbsvc-387a43696d.json";
            File keyFile = new File(serviceAccountName);

            // If not in relative path, check project-specific subdirectories
            if (!keyFile.exists()) {
                keyFile = new File("backend/" + serviceAccountName);
            }
            
            if (!keyFile.exists()) {
                 System.err.println("❌ Critical: Firebase Service Account JSON not found! Searched: " + keyFile.getAbsolutePath());
                 throw new IOException("Service Account file missing.");
            }

            FileInputStream serviceAccount = new FileInputStream(keyFile);

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
            }

            firestore = FirestoreClient.getFirestore();
            System.out.println("Firebase Firestore initialized successfully.");

        } catch (IOException e) {
            System.err.println("Firebase initialization error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Firestore getFirestore() {
        return firestore;
    }
}
