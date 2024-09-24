package com.example.chatbasicoprojecto.adapters;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.chatbasicoprojecto.R;
import com.example.chatbasicoprojecto.encapsulaciones.Contacto;
import com.example.chatbasicoprojecto.encapsulaciones.User;
import com.example.chatbasicoprojecto.utils.UserUtils;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.List;

public class ListContactRecyclerAdapter extends RecyclerView.Adapter<ListContactRecyclerAdapter.ViewHolder> {
    private final DatabaseReference databaseReference = FirebaseDatabase.getInstance().getReference();
    private List<User> contactList = new ArrayList<>();

    public void fetchContacts(){

        ValueEventListener contactListener = new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if (snapshot.exists()){
                    contactList.clear();
                    Contacto contacto = snapshot.child("contactos").child(UserUtils.getUsername()).getValue(Contacto.class);
                    if (contacto != null && contacto.getContactsEmail() != null){
                        List<String> contactos = contacto.getContactsEmail();
                        for (String emailContacto : contactos){
                            if (emailContacto != null){
                                contactList.add(new User(emailContacto));
                            }
                        }
                    }
                    notifyDataSetChanged();
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
                Log.e("Error fetching contacts", error.getMessage());
            }
        };
        databaseReference.addListenerForSingleValueEvent(contactListener);
    }

    public ListContactRecyclerAdapter(){
        fetchContacts();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        TextView username;
        TextView email;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            this.username = itemView.findViewById(R.id.username_add_contact);
            this.email = itemView.findViewById(R.id.email_add_contact);
        }
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.contact_recycler_row, parent, false);

        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ListContactRecyclerAdapter.ViewHolder holder, int position) {
        holder.username.setText(contactList.get(position).getUsername());
        holder.email.setText(contactList.get(position).getEmail());
    }

    @Override
    public int getItemCount() {
        return contactList.size();
    }
}
