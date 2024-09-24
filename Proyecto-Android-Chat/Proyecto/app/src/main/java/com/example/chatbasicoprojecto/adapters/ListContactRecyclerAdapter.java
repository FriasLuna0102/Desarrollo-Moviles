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
    private OnItemClickListener onClickListener;

    public interface OnItemClickListener {
        void onClick(int position, String username, String email);
    }

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

    public ListContactRecyclerAdapter(OnItemClickListener onItemClickListener){
        this.onClickListener = onItemClickListener;
        fetchContacts();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener{
        TextView username;
        TextView email;
        OnItemClickListener onItemClickListener;

        public ViewHolder(@NonNull View itemView, OnItemClickListener onItemClickListener) {
            super(itemView);
            this.username = itemView.findViewById(R.id.username_add_contact);
            this.email = itemView.findViewById(R.id.email_add_contact);
            itemView.setOnClickListener(this);
            this.onItemClickListener = onItemClickListener;
        }

        @Override
        public void onClick(View view) {
            this.onItemClickListener.onClick(getAdapterPosition(), username.getText().toString(), email.getText().toString());
        }
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.contact_recycler_row, parent, false);

        return new ViewHolder(view, this.onClickListener);
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
