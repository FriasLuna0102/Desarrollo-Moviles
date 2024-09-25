package com.example.chatbasicoprojecto;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.chatbasicoprojecto.adapters.MessageItemRecyclerAdapter;
import com.example.chatbasicoprojecto.databinding.ActivityLoginBinding;
import com.example.chatbasicoprojecto.databinding.ActivityPrivateChatBinding;
import com.google.firebase.database.DatabaseReference;

public class PrivateChatActivity extends AppCompatActivity {
    private ActivityPrivateChatBinding binding;
    private RecyclerView recyclerView;
    private MessageItemRecyclerAdapter messageItemRecyclerAdapter;
    private DatabaseReference databaseReference;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityPrivateChatBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        Intent intent = getIntent();

        recyclerView = findViewById(R.id.messages_view);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        messageItemRecyclerAdapter = new MessageItemRecyclerAdapter(intent.getStringExtra("username"), intent.getStringExtra("contactUsername"));
        recyclerView.setAdapter(messageItemRecyclerAdapter);
    }

    public void sendMessage(View view) {
        EditText editText = (EditText) findViewById(R.id.message_content);
        String text = editText.getText().toString();
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
}
