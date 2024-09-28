package com.example.chatbasicoprojecto.adapters;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.IdRes;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.chatbasicoprojecto.R;
import com.example.chatbasicoprojecto.encapsulaciones.Message;
import com.example.chatbasicoprojecto.encapsulaciones.PrivateChat;
import com.example.chatbasicoprojecto.utils.UserUtils;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

public class MessageItemRecyclerAdapter extends RecyclerView.Adapter<MessageItemRecyclerAdapter.ViewHolder> {
    private PrivateChat privateChat;
    private DatabaseReference databaseReference = FirebaseDatabase.getInstance().getReference();
    private String chatId;

    public MessageItemRecyclerAdapter(PrivateChat privateChat){
        this.privateChat = privateChat;
    }

    public static class ViewHolder extends RecyclerView.ViewHolder{
        TextView ownerMessage;
        TextView contactMessage;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            this.contactMessage = itemView.findViewById(R.id.contact_message);
            this.ownerMessage = itemView.findViewById(R.id.owner_message);
        }
    }

    @NonNull
    @Override
    public MessageItemRecyclerAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.message_recycler_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MessageItemRecyclerAdapter.ViewHolder holder, int position) {
        List<Message> messageList = new ArrayList<>(privateChat.getMessageList().values());

        messageList.sort(new Comparator<Message>() {
            @Override
            public int compare(Message message, Message t1) {
                return Long.compare(message.getTimeStamp(), t1.getTimeStamp());
            }
        });

        Message message = messageList.get(position);

        if (message.getSenderUsername().equals(UserUtils.getUsername())){
            holder.ownerMessage.setText(message.getContent());
            holder.ownerMessage.setVisibility(View.VISIBLE);
            holder.contactMessage.setVisibility(View.GONE);
        }else {
            holder.contactMessage.setText(message.getContent());
            holder.contactMessage.setVisibility(View.VISIBLE);
            holder.ownerMessage.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        if (privateChat == null || privateChat.getMessageList() == null){
            return 0;
        }
        return privateChat.getMessageList().size();
    }
}
