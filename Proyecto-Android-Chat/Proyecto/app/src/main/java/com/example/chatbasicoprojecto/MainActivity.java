package com.example.chatbasicoprojecto;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.chatbasicoprojecto.adapters.ListContactRecyclerAdapter;
import com.example.chatbasicoprojecto.databinding.ActivityMainBinding;
import com.example.chatbasicoprojecto.encapsulaciones.User;
import com.example.chatbasicoprojecto.notifications.FCMTokenManager;
import com.example.chatbasicoprojecto.utils.UserUtils;
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
    private String username = UserUtils.getUsername();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        FirebaseApp.initializeApp(this);
        mAuth = FirebaseAuth.getInstance();
        FCMTokenManager.getFCMTokenAndSaveToRealtimeDatabase(username);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(MainActivity.this, "android.permission.POST_NOTIFICATIONS") !=
                    PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(MainActivity.this,
                        new String[]{"android.permission.POST_NOTIFICATIONS"}, 1);
            }
        }

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
        Intent intent = new Intent(this, PrivateChatActivity.class);
        intent.putExtra("username", UserUtils.getUsername());
        intent.putExtra("contactUsername", username);
        startActivity(intent);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permiso concedido, puedes inicializar aquí cualquier cosa relacionada con las notificaciones
            } else {
                // Permiso denegado, puedes informar al usuario sobre las limitaciones
                Toast.makeText(this, "Las notificaciones están desactivadas", Toast.LENGTH_SHORT).show();
            }
        }
    }
}