package com.example.chatbasicoprojecto.utils;

import com.google.firebase.auth.FirebaseAuth;

public class UserUtils {
    private static final FirebaseAuth mAuth = FirebaseAuth.getInstance();

    public static String emailToUsername(String email){
        return email.substring(0, email.indexOf("@"));
    }

    public static String getUserEmail(){
        return mAuth.getCurrentUser().getEmail();
    }

    public static String getUsername(){
        return emailToUsername(mAuth.getCurrentUser().getEmail());
    }
}
