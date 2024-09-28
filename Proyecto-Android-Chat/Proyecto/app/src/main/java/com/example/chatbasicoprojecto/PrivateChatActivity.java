package com.example.chatbasicoprojecto;

import android.content.ContentResolver;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.webkit.MimeTypeMap;
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
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

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
    private static final int PICK_IMAGE_REQUEST = 1;
    private Uri imageUri;

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

        if (!text.isEmpty() || imageUri != null) {
            String messageKey = databaseReference.child("privateChat").child(chatID)
                    .child("messageMap").push().getKey();

            if (messageKey != null) {
                if (imageUri != null) {
                    // Enviar imagen
                    uploadImage(messageKey);
                } else {
                    // Enviar texto
                    Message message = new Message(ownerUsername, text, null);
                    databaseReference.child("privateChat").child(chatID)
                            .child("messageList").child(messageKey).setValue(message);
                }

                editText.setText("");
                imageUri = null; // Resetear la URI de la imagen
            } else {
                Toast.makeText(this, "Error al generar la clave del mensaje", Toast.LENGTH_SHORT).show();
            }
        } else {
            Toast.makeText(this, "No puedes enviar un mensaje vacío", Toast.LENGTH_SHORT).show();
        }
    }

    private void uploadImage(final String messageKey) {
        if (imageUri != null) {
            final StorageReference fileReference = FirebaseStorage.getInstance().getReference("chat_images")
                    .child(System.currentTimeMillis() + "." + getFileExtension(imageUri));

            fileReference.putFile(imageUri)
                    .addOnSuccessListener(new OnSuccessListener<UploadTask.TaskSnapshot>() {
                        @Override
                        public void onSuccess(UploadTask.TaskSnapshot taskSnapshot) {
                            fileReference.getDownloadUrl().addOnSuccessListener(new OnSuccessListener<Uri>() {
                                @Override
                                public void onSuccess(Uri uri) {
                                    String imageUrl = uri.toString();
                                    Message message = new Message(ownerUsername, "", imageUrl);
                                    databaseReference.child("privateChat").child(chatID)
                                            .child("messageList").child(messageKey).setValue(message);
                                }
                            });
                        }
                    })
                    .addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            Toast.makeText(PrivateChatActivity.this, "Error al subir la imagen", Toast.LENGTH_SHORT).show();
                        }
                    });
        }
    }

    private String getFileExtension(Uri uri) {
        ContentResolver contentResolver = getContentResolver();
        MimeTypeMap mime = MimeTypeMap.getSingleton();
        return mime.getExtensionFromMimeType(contentResolver.getType(uri));
    }

    // Método para abrir el selector de imágenes
    public void openImageChooser(View view) {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, "Selecciona una imagen"), PICK_IMAGE_REQUEST);
    }

    // Manejo de la selección de la imagen
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == PICK_IMAGE_REQUEST && resultCode == RESULT_OK
                && data != null && data.getData() != null) {
            imageUri = data.getData();
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
