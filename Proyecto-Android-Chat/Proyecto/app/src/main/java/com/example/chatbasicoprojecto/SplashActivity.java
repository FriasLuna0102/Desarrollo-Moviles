package com.example.chatbasicoprojecto;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import androidx.appcompat.app.AppCompatActivity;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class SplashActivity extends AppCompatActivity {

    private static final int SPLASH_TIME_OUT = 2000; // 2 seconds

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                FirebaseUser currentUser = FirebaseAuth.getInstance().getCurrentUser();
                Intent intent;
                if (currentUser != null) {
                    // User is signed in
                    intent = new Intent(SplashActivity.this, MainActivity.class);
                } else {
                    // No user is signed in
                    intent = new Intent(SplashActivity.this, Login.class);
                }
                startActivity(intent);
                finish();
            }
        }, SPLASH_TIME_OUT);
    }
}