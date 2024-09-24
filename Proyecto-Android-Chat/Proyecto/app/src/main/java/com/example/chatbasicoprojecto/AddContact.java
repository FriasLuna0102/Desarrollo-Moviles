package com.example.chatbasicoprojecto;

import static android.app.PendingIntent.getActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.PixelCopy;
import android.view.View;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.chatbasicoprojecto.adapters.AddContactRecyclerAdapter;
import com.example.chatbasicoprojecto.databinding.ActivityAddContactBinding;
import com.example.chatbasicoprojecto.encapsulaciones.Contacto;
import com.example.chatbasicoprojecto.encapsulaciones.User;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.FirebaseApp;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.ArrayList;
import java.util.Objects;

public class AddContact extends AppCompatActivity implements AddContactRecyclerAdapter.OnItemClickListener {
    private ActivityAddContactBinding binding;
    private FirebaseDatabase database = FirebaseDatabase.getInstance();
    private DatabaseReference databaseReference = database.getReference();
    private AddContactRecyclerAdapter addContactRecyclerAdapter;
    private RecyclerView recyclerView;
    private FirebaseAuth mAuth = FirebaseAuth.getInstance();
    private String userEmail = mAuth.getCurrentUser().getEmail();
    private String username = userEmail.substring(0, userEmail.indexOf("@"));

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityAddContactBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        recyclerView = findViewById(R.id.contactList);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        listarUsuariosNoAgregados();
    }

    public void listarUsuariosNoAgregados(){
        addContactRecyclerAdapter = new AddContactRecyclerAdapter(this);
        recyclerView.setAdapter(addContactRecyclerAdapter);
    }

    public void volverToMain(View view){
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
    }

    @Override
    public void onClick(int position, String email) {
        addUserToContacts(email);
        Toast toast = Toast.makeText(AddContact.this,email + " Agregado!",Toast.LENGTH_SHORT);
        toast.show();
    }

    public void addUserToContacts(String email){

        // Retrieve the current Contacto object from the database
        databaseReference.child("contactos").child(username).get().addOnCompleteListener(task -> {
            if (task.isSuccessful() && task.getResult() != null) {

                Contacto contacto = task.getResult().getValue(Contacto.class);
                if (contacto == null) {
                    contacto = new Contacto(userEmail);
                }

                if (contacto.getContactsEmail() == null) {
                    contacto.setContactsEmail(new ArrayList<>());
                }

                if (!contacto.getContactsEmail().contains(email)) {
                    contacto.getContactsEmail().add(email);
                }

                databaseReference.child("contactos").child(username).setValue(contacto);
            } else {
                Log.e("DatabaseError", "Failed to retrieve contact", task.getException());
            }
        });
    }
}