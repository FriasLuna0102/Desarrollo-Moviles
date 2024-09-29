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
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.example.chatbasicoprojecto.databinding.ActivityLoginBinding;
import com.example.chatbasicoprojecto.notifications.FCMTokenManager;
import com.example.chatbasicoprojecto.utils.UserUtils;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.FirebaseApp;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class Login extends AppCompatActivity {

    private ActivityLoginBinding binding;
    private FirebaseAuth mAuth;
    private static final String TAG = "LoginActivity";
    private String username = UserUtils.getUsername();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityLoginBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        FirebaseApp.initializeApp(this);
        mAuth = FirebaseAuth.getInstance();


    }

    @Override
    public void onStart() {
        super.onStart();
        // Check if user is signed in (non-null) and update UI accordingly.
        FirebaseUser currentUser = mAuth.getCurrentUser();
        if(currentUser != null){
            // User is already signed in, you might want to redirect to main activity
            // updateUI(currentUser);
        }
    }

    public void onLoginClick(View view) {

        String email = binding.emailFieldId.getText().toString();
        String password = binding.passwordFieldId.getText().toString();

        // Obtener el token de FCM
        FCMTokenManager.getFCMTokenAndSaveToRealtimeDatabase(username);
        if (email.isEmpty() || password.isEmpty()) {
            Toast.makeText(Login.this, "Email and password are required", Toast.LENGTH_SHORT).show();
            return;
        }
        System.out.println(email);
        System.out.println(password);

        mAuth.signInWithEmailAndPassword(email, password)
                .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        if (task.isSuccessful()) {
                            // Sign in success, update UI with the signed-in user's information
                            Log.d(TAG, "signInWithEmail:success");
                            FirebaseUser user = mAuth.getCurrentUser();
                            Toast.makeText(Login.this, "Authentication successful.",
                                    Toast.LENGTH_SHORT).show();
                            // updateUI(user);

                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                if (ContextCompat.checkSelfPermission(Login.this, "android.permission.POST_NOTIFICATIONS") !=
                                        PackageManager.PERMISSION_GRANTED) {
                                    ActivityCompat.requestPermissions(Login.this,
                                            new String[]{"android.permission.POST_NOTIFICATIONS"}, 1);
                                }
                            }

                            Intent intent = new Intent(Login.this, MainActivity.class);
                            startActivity(intent);

                        } else {
                            // If sign in fails, display a message to the user.
                            Log.w(TAG, "signInWithEmail:failure", task.getException());
                            Toast.makeText(Login.this, "Authentication failed: " + task.getException().getMessage(),
                                    Toast.LENGTH_SHORT).show();
                            // updateUI(null);
                        }
                    }
                });
    }

    public void onRegisterClick(View view) {
        Intent intent = new Intent(Login.this, Register.class);
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