package com.example.chatbasicoprojecto.adapters;

import android.graphics.Color;
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
import com.google.android.material.imageview.ShapeableImageView;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class ListContactRecyclerAdapter extends RecyclerView.Adapter<ListContactRecyclerAdapter.ViewHolder> {
    private final DatabaseReference databaseReference = FirebaseDatabase.getInstance().getReference();
    private List<User> contactList = new ArrayList<>();
    private OnItemClickListener onClickListener;

    public interface OnItemClickListener {
        void onClick(int position, String username, String email);
    }

    public void fetchContacts() {
        ValueEventListener contactListener = new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if (snapshot.exists()) {
                    contactList.clear();
                    Contacto contacto = snapshot.child("contactos").child(UserUtils.getUsername()).getValue(Contacto.class);
                    if (contacto != null && contacto.getContactsEmail() != null) {
                        List<String> contactos = contacto.getContactsEmail();
                        for (String emailContacto : contactos) {
                            if (emailContacto != null) {
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

    public ListContactRecyclerAdapter(OnItemClickListener onItemClickListener) {
        this.onClickListener = onItemClickListener;
        fetchContacts();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView username;
        TextView email;
        ShapeableImageView avatarImage;
        TextView avatarText;
        View statusIndicator;
        OnItemClickListener onItemClickListener;

        public ViewHolder(@NonNull View itemView, OnItemClickListener onItemClickListener) {
            super(itemView);
            this.username = itemView.findViewById(R.id.username_add_contact);
            this.email = itemView.findViewById(R.id.email_add_contact);
            this.avatarImage = itemView.findViewById(R.id.avatar_image);
            this.avatarText = itemView.findViewById(R.id.avatar_text);
            itemView.setOnClickListener(this);
            this.onItemClickListener = onItemClickListener;
            statusIndicator = itemView.findViewById(R.id.status_indicator);
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
        User user = contactList.get(position);
        holder.username.setText(user.getUsername());
        holder.email.setText(user.getEmail());

        View statusIndicator = holder.itemView.findViewById(R.id.status_indicator);
        if ("online".equals(user.getStatus())) {
            statusIndicator.setBackgroundResource(R.color.status_online);
        } else {
            statusIndicator.setBackgroundResource(R.color.status_offline);
        }

        // Genera las iniciales del nombre de usuario
        String initials = user.getUsername().substring(0, Math.min(user.getUsername().length(), 2)).toUpperCase();
        holder.avatarText.setText(initials);

        // Genera un color aleatorio para el fondo del avatar
        Random rnd = new Random();
        int color = Color.argb(255, rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256));
        holder.avatarImage.setBackgroundColor(color);
    }

    @Override
    public int getItemCount() {
        return contactList.size();
    }

    public List<User> contactList() {
        return contactList;
    }

}