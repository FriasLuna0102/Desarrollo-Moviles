package com.example.chatbasicoprojecto.adapters;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.chatbasicoprojecto.R;
import com.example.chatbasicoprojecto.encapsulaciones.Contacto;
import com.example.chatbasicoprojecto.encapsulaciones.User;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.ArrayList;
import java.util.List;

public class AddContactRecyclerAdapter extends RecyclerView.Adapter<AddContactRecyclerAdapter.ViewHolder> {

    private FirebaseDatabase database = FirebaseDatabase.getInstance();
    private DatabaseReference databaseReference = database.getReference();
    private List<User> userList = new ArrayList<>();
    private List<String> emailOfAddedContacts = new ArrayList<>();
    private OnItemClickListener onClickListener;
    private FirebaseAuth mAuth = FirebaseAuth.getInstance();
    private String userEmail = mAuth.getCurrentUser().getEmail();
    private String username = userEmail.substring(0, userEmail.indexOf("@"));

    public interface OnItemClickListener {
        void onClick(int position, String email);
    }

    public AddContactRecyclerAdapter(OnItemClickListener onClickListener) {
        this.onClickListener = onClickListener;
        fetchAvailableContacts();
    }

    private void fetchAvailableContacts() {

        databaseReference.child("contactos").child(username).get().addOnCompleteListener(new OnCompleteListener<DataSnapshot>() {
            @Override
            public void onComplete(@NonNull Task<DataSnapshot> task) {
                if (task.isSuccessful()){
                    System.out.println(task.getResult().getValue(Contacto.class).getContactsEmail());
                    emailOfAddedContacts = task.getResult().getValue(Contacto.class).getContactsEmail();
                    notifyDataSetChanged();
                }else {
                    Log.e("Error user contacts", String.valueOf(task.getResult().getValue()));
                }
            }
        });

        databaseReference.child("users").get().addOnCompleteListener(new OnCompleteListener<DataSnapshot>() {
            @Override
            public void onComplete(@NonNull Task<DataSnapshot> task) {
                if (task.isSuccessful()){
                    DataSnapshot dataSnapshot = task.getResult();
                    for (DataSnapshot snapshot: dataSnapshot.getChildren()) {
                        String email = snapshot.child("email").getValue(String.class);
                        if (emailOfAddedContacts == null || !emailOfAddedContacts.contains(email)){
                            userList.add(new User(email));
                        }
                    }
                    notifyDataSetChanged();
                }else {
                    Log.e("Error fetching contacts", String.valueOf(task.getResult().getValue()));
                }
            }
        });
    }

    public static class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener{
        TextView username;
        TextView email;
        OnItemClickListener onItemClickListener;

        public ViewHolder(@NonNull View view, OnItemClickListener onItemClickListener){
            super(view);
            this.username = view.findViewById(R.id.username_add_contact);
            this.email = view.findViewById(R.id.email_add_contact);
            view.setOnClickListener(this);
            this.onItemClickListener = onItemClickListener;
        }

        @Override
        public void onClick(View view) {
            this.onItemClickListener.onClick(getAdapterPosition(), email.getText().toString());
        }
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.contact_recycler_row, parent, false);

        return new ViewHolder(view, this.onClickListener);
    }

    @Override
    public void onBindViewHolder(@NonNull AddContactRecyclerAdapter.ViewHolder holder, int position) {
        holder.username.setText(userList.get(position).getUsername());
        holder.email.setText(userList.get(position).getEmail());
    }

    @Override
    public int getItemCount() {
        return userList.size();
    }
}
