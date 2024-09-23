package com.example.chatbasicoprojecto.encapsulaciones;

import com.google.firebase.database.IgnoreExtraProperties;

@IgnoreExtraProperties
public class User {
    private String username;
    private String email;

    public User() {}

    public User(String email, String username) {
        this.email = email;
        this.username = username.substring(0, username.indexOf('@'));
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
}
