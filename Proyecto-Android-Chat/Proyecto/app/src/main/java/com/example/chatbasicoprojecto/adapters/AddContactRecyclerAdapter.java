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
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.*;
import java.util.ArrayList;
import java.util.List;

public class AddContactRecyclerAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private static final int VIEW_TYPE_EMPTY = 0;
    private static final int VIEW_TYPE_CONTACT = 1;

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
        ValueEventListener contactosListener = new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                Contacto contacto = snapshot.child("contactos").child(username).getValue(Contacto.class);
                if (contacto != null && contacto.getContactsEmail() != null) {
                    emailOfAddedContacts = contacto.getContactsEmail();
                } else {
                    emailOfAddedContacts.clear();
                }
                fetchUsers();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
                // Manejar el error
            }
        };
        databaseReference.addValueEventListener(contactosListener);
    }

    private void fetchUsers() {
        ValueEventListener userListener = new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                userList.clear();
                for (DataSnapshot data : snapshot.child("users").getChildren()) {
                    String email = data.child("email").getValue(String.class);
                    if (!emailOfAddedContacts.contains(email) && !email.equals(userEmail)) {
                        userList.add(new User(email));
                    }
                }
                notifyDataSetChanged();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
                Log.e("Error fetching users", error.getMessage());
            }
        };
        databaseReference.addValueEventListener(userListener);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (viewType == VIEW_TYPE_EMPTY) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_empty_view, parent, false);
            return new EmptyViewHolder(view);
        } else {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.contact_recycler_row, parent, false);
            return new ContactViewHolder(view, this.onClickListener);
        }
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof ContactViewHolder) {
            ContactViewHolder contactHolder = (ContactViewHolder) holder;
            User user = userList.get(position);
            contactHolder.username.setText(user.getUsername());
            contactHolder.email.setText(user.getEmail());
        } else if (holder instanceof EmptyViewHolder) {
            EmptyViewHolder emptyHolder = (EmptyViewHolder) holder;
            emptyHolder.emptyText.setText("No hay contactos para agregar");
        }
    }

    @Override
    public int getItemCount() {
        return userList.isEmpty() ? 1 : userList.size();
    }

    @Override
    public int getItemViewType(int position) {
        return userList.isEmpty() ? VIEW_TYPE_EMPTY : VIEW_TYPE_CONTACT;
    }

    static class ContactViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView username;
        TextView email;
        OnItemClickListener onItemClickListener;

        public ContactViewHolder(@NonNull View view, OnItemClickListener onItemClickListener) {
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

    static class EmptyViewHolder extends RecyclerView.ViewHolder {
        TextView emptyText;

        public EmptyViewHolder(@NonNull View itemView) {
            super(itemView);
            emptyText = itemView.findViewById(R.id.empty_text);
        }
    }
}