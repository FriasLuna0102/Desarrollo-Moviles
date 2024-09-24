package com.example.chatbasicoprojecto;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.activity.EdgeToEdge;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.example.chatbasicoprojecto.databinding.ActivityLoginBinding;
import com.example.chatbasicoprojecto.databinding.ActivityPrivateChatBinding;

public class PrivateChatActivity extends AppCompatActivity {
    private ActivityPrivateChatBinding binding;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityPrivateChatBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
    }
}
