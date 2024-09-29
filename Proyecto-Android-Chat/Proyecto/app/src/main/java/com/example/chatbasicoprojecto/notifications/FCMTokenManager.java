package com.example.chatbasicoprojecto.notifications;

import android.util.Log;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.messaging.FirebaseMessaging;

public class FCMTokenManager {
    private static final String TAG = "FCMTokenManager";

    public static void getFCMTokenAndSaveToRealtimeDatabase(String username) {
        Log.d(TAG, "Iniciando obtención del token FCM");
        FirebaseMessaging.getInstance().getToken()
                .addOnCompleteListener(task -> {
                    if (!task.isSuccessful()) {
                        Log.w(TAG, "Fetching FCM registration token failed", task.getException());
                        return;
                    }

                    String token = task.getResult();
                    Log.d(TAG, "Token FCM obtenido: " + token);

                    FirebaseUser currentUser = FirebaseAuth.getInstance().getCurrentUser();
                    if (currentUser == null) {
                        Log.w(TAG, "No user is currently signed in");
                        return;
                    }

                    Log.d(TAG, "Usuario actual: " + currentUser.getUid());

                    DatabaseReference userRef = FirebaseDatabase.getInstance().getReference("users")
                            .child(username);
                    userRef.child("fcmToken").setValue(token)
                            .addOnSuccessListener(aVoid -> Log.d(TAG, "FCM Token successfully saved to Realtime Database"))
                            .addOnFailureListener(e -> Log.w(TAG, "Error saving FCM token to Realtime Database", e));
                });
    }
}