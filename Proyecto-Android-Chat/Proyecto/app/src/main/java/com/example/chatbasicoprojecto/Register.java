package com.example.chatbasicoprojecto;

import static android.content.ContentValues.TAG;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.example.chatbasicoprojecto.databinding.ActivityRegisterBinding;
import com.example.chatbasicoprojecto.encapsulaciones.Contacto;
import com.example.chatbasicoprojecto.encapsulaciones.User;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.FirebaseApp;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthInvalidCredentialsException;
import com.google.firebase.auth.FirebaseAuthUserCollisionException;
import com.google.firebase.auth.FirebaseAuthWeakPasswordException;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class Register extends AppCompatActivity {

    private ActivityRegisterBinding binding;
    private FirebaseAuth mAuth;
    private ProgressBar progressBar;
    private FirebaseDatabase database = FirebaseDatabase.getInstance();
    private DatabaseReference databaseReference = database.getReference();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityRegisterBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        FirebaseApp.initializeApp(this);
        mAuth = FirebaseAuth.getInstance();
        progressBar = binding.progressBar; // Asumiendo que tienes un ProgressBar en tu layout con id progressBar
    }

    public void register(View view) {
        String email = binding.emailRegisterId.getText().toString();
        String password = binding.passwordRegisterId.getText().toString();
        String password2 = binding.passwordRegisterId2.getText().toString();

        if (email.isEmpty() || password.isEmpty() || password2.isEmpty()) {
            Toast.makeText(Register.this, "All fields are required", Toast.LENGTH_SHORT).show();
            return;
        }

        if (!password.equals(password2)) {
            Toast.makeText(Register.this, "Passwords do not match", Toast.LENGTH_SHORT).show();
            return;
        }

        progressBar.setVisibility(View.VISIBLE);

        mAuth.createUserWithEmailAndPassword(email, password)
                .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        progressBar.setVisibility(View.GONE);
                        if (task.isSuccessful()) {
                            Log.d(TAG, "createUserWithEmail:success");

                            User user = new User(email);
                            Contacto contacto = new Contacto(email);
                            databaseReference.child("users").child(email.substring(0, email.indexOf("@"))).setValue(user);
                            databaseReference.child("contactos").child(email.substring(0, email.indexOf("@"))).setValue(contacto);

                            Toast.makeText(Register.this, "Registration successful.",
                                    Toast.LENGTH_SHORT).show();
                            Intent login = new Intent(Register.this, Login.class);
                            startActivity(login);
                            finish();
                        } else {
                            Log.w(TAG, "createUserWithEmail:failure", task.getException());
                            String errorMessage = "Registration failed: ";
                            if (task.getException() instanceof FirebaseAuthWeakPasswordException) {
                                errorMessage += "The password is too weak.";
                            } else if (task.getException() instanceof FirebaseAuthInvalidCredentialsException) {
                                errorMessage += "The email address is badly formatted.";
                            } else if (task.getException() instanceof FirebaseAuthUserCollisionException) {
                                errorMessage += "The email is already in use by another account.";
                            } else {
                                errorMessage += task.getException().getMessage();
                            }
                            Toast.makeText(Register.this, errorMessage, Toast.LENGTH_LONG).show();
                        }
                    }
                });
    }

    public void login(View view) {
        Intent login = new Intent(Register.this, Login.class);
        startActivity(login);
        finish();
    }
}