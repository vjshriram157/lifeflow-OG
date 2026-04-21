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
            // Load configuration
            java.util.Properties props = new java.util.Properties();
            java.io.InputStream propStream = FirebaseConfig.class.getClassLoader().getResourceAsStream("config.properties");
            if (propStream != null) {
                props.load(propStream);
            }

            String serviceAccountName = props.getProperty("firebase.service.account.filename", "lifeflow-30d1a-firebase-adminsdk-fbsvc-387a43696d.json");
            
            // Search for key file in multiple locations for portability
            File keyFile = new File(serviceAccountName);
            
            // Fallback to searching in 'backend' directory (common in dev)
            if (!keyFile.exists()) {
                keyFile = new File("backend/" + serviceAccountName);
            }
            
            // Fallback to searching in parent (if running from nested build dir)
            if (!keyFile.exists()) {
                keyFile = new File("../" + serviceAccountName);
            }

            if (!keyFile.exists()) {
                throw new java.io.FileNotFoundException("Firebase key file not found: " + serviceAccountName);
            }

            FileInputStream serviceAccount = new FileInputStream(keyFile);

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
            }

            firestore = FirestoreClient.getFirestore();
            System.out.println("Firebase Firestore initialized successfully from: " + keyFile.getAbsolutePath());

        } catch (IOException e) {
            System.err.println("Firebase initialization error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Firestore getFirestore() {
        return firestore;
    }
}
