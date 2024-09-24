package com.example.chatbasicoprojecto;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.chatbasicoprojecto.adapters.ListContactRecyclerAdapter;
import com.example.chatbasicoprojecto.databinding.ActivityMainBinding;
import com.example.chatbasicoprojecto.encapsulaciones.User;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.FirebaseApp;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class MainActivity extends AppCompatActivity implements ListContactRecyclerAdapter.OnItemClickListener{

    private ActivityMainBinding binding;
    private FirebaseAuth mAuth;
    private FirebaseDatabase database = FirebaseDatabase.getInstance();
    private DatabaseReference databaseReference = database.getReference();
    private User usuario;
    private RecyclerView recyclerView;
    private ListContactRecyclerAdapter listContactRecyclerAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        FirebaseApp.initializeApp(this);
        mAuth = FirebaseAuth.getInstance();

        databaseReference.child("users").child(mAuth.getCurrentUser().getEmail().substring(0, mAuth.getCurrentUser().getEmail().indexOf("@")))
                .get().addOnCompleteListener(new OnCompleteListener<DataSnapshot>() {
            @Override
            public void onComplete(@NonNull Task<DataSnapshot> task) {
                if (task.isSuccessful()){

                    // usuario = (User) task.getResult().getValue();
                }else {
                    Log.e("No se pudo encontrar el usuario", String.valueOf(task.getResult().getValue()));
                }
            }
        });

        // Setup toolbar
        Toolbar toolbar = binding.toolbar;
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayShowTitleEnabled(false);
        }

        recyclerView = findViewById(R.id.mainList);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        listContactRecyclerAdapter = new ListContactRecyclerAdapter(this);
        recyclerView.setAdapter(listContactRecyclerAdapter);

    }

    @Override
    public void onStart() {
        super.onStart();
        FirebaseUser currentUser = mAuth.getCurrentUser();
        if (currentUser == null) {
            // User is signed in
            Intent intent = new Intent(MainActivity.this, Login.class);
            startActivity(intent);
            finish();
        }
    }

    public void addContact(View view){
        Intent intent = new Intent(this, AddContact.class);
        startActivity(intent);
    }

    public void logout(View view) {
        mAuth.signOut();
        Toast.makeText(MainActivity.this, "Logged out successfully", Toast.LENGTH_SHORT).show();
        Intent intent = new Intent(MainActivity.this, Login.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }

    @Override
    public void onClick(int position, String username, String email) {
        Toast toast = Toast.makeText(MainActivity.this, "click " + username, Toast.LENGTH_SHORT);
        toast.show();
    }
}