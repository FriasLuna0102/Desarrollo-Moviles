package com.example.chatbasicoprojecto;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.chatbasicoprojecto.adapters.AddContactRecyclerAdapter;
import com.example.chatbasicoprojecto.databinding.ActivityAddContactBinding;
import com.example.chatbasicoprojecto.encapsulaciones.Contacto;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.ArrayList;

public class AddContact extends AppCompatActivity implements AddContactRecyclerAdapter.OnItemClickListener {
    private ActivityAddContactBinding binding;
    private DatabaseReference databaseReference;
    private AddContactRecyclerAdapter addContactRecyclerAdapter;
    private RecyclerView recyclerView;
    private String userEmail;
    private String username;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityAddContactBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setSupportActionBar(binding.toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);

        databaseReference = FirebaseDatabase.getInstance().getReference();
        FirebaseAuth mAuth = FirebaseAuth.getInstance();
        userEmail = mAuth.getCurrentUser().getEmail();
        username = userEmail.substring(0, userEmail.indexOf("@"));

        recyclerView = binding.contactList;
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        listarUsuariosNoAgregados();

        FloatingActionButton fab = binding.fabAddContact;
        fab.setOnClickListener(view -> {
            // Aquí va la lógica para añadir un nuevo contacto
            Toast.makeText(this, "Añadir nuevo contacto", Toast.LENGTH_SHORT).show();
        });
    }

    public void listarUsuariosNoAgregados() {
        addContactRecyclerAdapter = new AddContactRecyclerAdapter(this);
        recyclerView.setAdapter(addContactRecyclerAdapter);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            volverToMain();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    public void volverToMain() {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
        finish();
    }

    @Override
    public void onClick(int position, String email) {
        addUserToContacts(email);
        Toast.makeText(AddContact.this, email + " Agregado!", Toast.LENGTH_SHORT).show();
    }

    public void addUserToContacts(String email) {
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