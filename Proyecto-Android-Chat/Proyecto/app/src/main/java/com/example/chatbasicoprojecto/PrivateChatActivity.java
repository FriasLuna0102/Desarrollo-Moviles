package com.example.chatbasicoprojecto;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.LinearSmoothScroller;
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
import com.google.firebase.database.ValueEventListener;

import java.util.List;
import java.util.Random;
import java.util.UUID;

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
        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        messageItemRecyclerAdapter = new MessageItemRecyclerAdapter(ownerUsername, contactUsername);
        recyclerView.setAdapter(messageItemRecyclerAdapter);

        TextView chatTitle = findViewById(R.id.private_chat_title);
        chatTitle.setText(contactUsername);
    }

    public void sendMessage(View view) {
        EditText editText = findViewById(R.id.message_content);
        String text = editText.getText().toString();

        if (!text.isEmpty()) {
            Message message = new Message(ownerUsername, text);

            // Generar una nueva clave para el mensaje
            String messageKey = databaseReference.child("privateChat").child(ownerUsername + "-" + contactUsername)
                    .child("messageMap").push().getKey();

            if (messageKey != null) {
                // Enviar el mensaje y guardarlo en el mapa de mensajes
                databaseReference.child("privateChat").child(ownerUsername + "-" + contactUsername)
                        .child("messageList").child(messageKey).setValue(message);

                editText.setText("");
            } else {
                Toast.makeText(this, "Error al generar la clave del mensaje", Toast.LENGTH_SHORT).show();
            }
        } else {
            Toast.makeText(this, "No puedes enviar un mensaje vacío", Toast.LENGTH_SHORT).show();
        }
    }
}
