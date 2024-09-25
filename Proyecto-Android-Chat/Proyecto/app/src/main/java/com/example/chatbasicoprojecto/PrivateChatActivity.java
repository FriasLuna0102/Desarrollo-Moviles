package com.example.chatbasicoprojecto;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.annotation.NonNull;
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
import com.example.chatbasicoprojecto.encapsulaciones.Message;
import com.example.chatbasicoprojecto.encapsulaciones.PrivateChat;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class PrivateChatActivity extends AppCompatActivity {
    private ActivityPrivateChatBinding binding;
    private RecyclerView recyclerView;
    private MessageItemRecyclerAdapter messageItemRecyclerAdapter;
    private DatabaseReference databaseReference = FirebaseDatabase.getInstance().getReference();
    private String ownerUsername;
    private String contactUsername;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityPrivateChatBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        Intent intent = getIntent();
        ownerUsername = intent.getStringExtra("username");
        contactUsername = intent.getStringExtra("contactUsername");

        recyclerView = findViewById(R.id.messages_view);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        messageItemRecyclerAdapter = new MessageItemRecyclerAdapter(ownerUsername, contactUsername);
        recyclerView.setAdapter(messageItemRecyclerAdapter);
    }

    public void sendMessage(View view) {
        EditText editText = (EditText) findViewById(R.id.message_content);
        String text = editText.getText().toString();
        if (!text.isEmpty()) {
            Message message = new Message(ownerUsername, text);
            databaseReference.child("privateChat").child(ownerUsername + "-" + contactUsername)
                    .child("messageList").push().setValue(message);
            editText.setText("");
            Toast.makeText(this, "Mensaje enviado", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "No puedes enviar un mensaje vacío", Toast.LENGTH_SHORT).show();
        }
    }
}
