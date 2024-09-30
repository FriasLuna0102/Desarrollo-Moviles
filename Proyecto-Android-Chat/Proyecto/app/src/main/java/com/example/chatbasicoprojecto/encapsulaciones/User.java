package com.example.chatbasicoprojecto.encapsulaciones;

import com.google.firebase.database.IgnoreExtraProperties;

@IgnoreExtraProperties
public class User {
    private String username;
    private String email;
    private String fcmToken;
    private String status;

    public User() {}

    public User(String email) {
        this.email = email;
        this.username = email.substring(0, email.indexOf('@'));
        this.status = "offline";
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFcmToken() {
        return fcmToken;
    }

    public void setFcmToken(String fcmToken) {
        this.fcmToken = fcmToken;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
