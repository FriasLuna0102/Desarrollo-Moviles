package com.example.chatbasicoprojecto.utils;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class UserUtils {
    private static final FirebaseAuth mAuth = FirebaseAuth.getInstance();

    public static String emailToUsername(String email) {
        if (email == null || !email.contains("@")) {
            return "Anonymous";
        }
        return email.substring(0, email.indexOf("@"));
    }

    public static String getUserEmail() {
        FirebaseUser currentUser = mAuth.getCurrentUser();
        return currentUser != null ? currentUser.getEmail() : null;
    }

    public static String getUsername() {
        String email = getUserEmail();
        return email != null ? emailToUsername(email) : "Anonymous";
    }
}