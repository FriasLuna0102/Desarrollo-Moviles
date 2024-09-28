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
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.HashMap;
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
    private String chatID;
    private PrivateChat privateChat;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityPrivateChatBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        Intent intent = getIntent();
        ownerUsername = intent.getStringExtra("username");
        contactUsername = intent.getStringExtra("contactUsername");

        chatID = contactUsername + "-" + ownerUsername;
        databaseReference.child("privateChat").child(chatID).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if (snapshot.exists()){
                    fetchPrivateChat(ownerUsername,contactUsername);
                }else {
                    chatID = ownerUsername + "-" + contactUsername;
                    fetchPrivateChat(ownerUsername, contactUsername);
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
                Log.e("Error en privatechatactivity", "No fue possible buscar el chat por id");

            }
        });

        recyclerView = findViewById(R.id.messages_view);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
        layoutManager.setStackFromEnd(true);
        recyclerView.setLayoutManager(layoutManager);

        TextView chatTitle = findViewById(R.id.private_chat_title);
        chatTitle.setText(contactUsername);
    }

    public void sendMessage(View view) {
        EditText editText = findViewById(R.id.message_content);
        String text = editText.getText().toString();

        if (!text.isEmpty()) {
            Message message = new Message(ownerUsername, text);

            // Generar una nueva clave para el mensaje
            String messageKey = databaseReference.child("privateChat").child(chatID)
                    .child("messageMap").push().getKey();

            if (messageKey != null) {
                // Enviar el mensaje y guardarlo en el mapa de mensajes
                databaseReference.child("privateChat").child(chatID)
                        .child("messageList").child(messageKey).setValue(message);

                editText.setText("");
            } else {
                Toast.makeText(this, "Error al generar la clave del mensaje", Toast.LENGTH_SHORT).show();
            }
        } else {
            Toast.makeText(this, "No puedes enviar un mensaje vacío", Toast.LENGTH_SHORT).show();
        }
    }

    public void backToMain(View view){
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
    }

    public void fetchPrivateChat(String owner, String contact){
        ValueEventListener privatChatInfo = new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                privateChat = snapshot.child("privateChat").child(chatID).getValue(PrivateChat.class);
                if (privateChat == null){
                    PrivateChat newPrivateChat = new PrivateChat(owner, contact);
                    databaseReference.child("privateChat").child(chatID).setValue(newPrivateChat);
                    privateChat = newPrivateChat;
                }
                messageItemRecyclerAdapter = new MessageItemRecyclerAdapter(privateChat);
                recyclerView.setAdapter(messageItemRecyclerAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
                Log.e("Error al obtener chat privado", error.getMessage());
            }
        };
        databaseReference.addValueEventListener(privatChatInfo);
    }
}
