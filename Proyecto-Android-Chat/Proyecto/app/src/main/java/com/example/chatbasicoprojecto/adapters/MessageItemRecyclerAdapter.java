package com.example.chatbasicoprojecto.adapters;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.example.chatbasicoprojecto.R;
import com.example.chatbasicoprojecto.encapsulaciones.Message;
import com.example.chatbasicoprojecto.encapsulaciones.PrivateChat;
import com.example.chatbasicoprojecto.utils.UserUtils;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import com.bumptech.glide.Glide;
import android.content.Context;

public class MessageItemRecyclerAdapter extends RecyclerView.Adapter<MessageItemRecyclerAdapter.ViewHolder> {
    private PrivateChat privateChat;
    private Context context;

    public MessageItemRecyclerAdapter(PrivateChat privateChat, Context context) {
        this.privateChat = privateChat;
        this.context = context;
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        LinearLayout ownerMessageContainer;
        TextView ownerNameDisplay, ownerMessage, ownerMessageDate;
        ImageView ownerImageMessage;
        LinearLayout contactMessageContainer;
        TextView contactNameDisplay, contactMessage, contactMessageDate;
        ImageView contactImageMessage;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            this.ownerMessageContainer = itemView.findViewById(R.id.owner_message_container);
            this.ownerNameDisplay = itemView.findViewById(R.id.owner_message_name_display);
            this.ownerMessage = itemView.findViewById(R.id.owner_message);
            this.ownerMessageDate = itemView.findViewById(R.id.owner_message_time_display);
            this.ownerImageMessage = itemView.findViewById(R.id.owner_image_message);

            this.contactMessageContainer = itemView.findViewById(R.id.contact_message_container);
            this.contactNameDisplay = itemView.findViewById(R.id.contact_message_name_display);
            this.contactMessage = itemView.findViewById(R.id.contact_message);
            this.contactMessageDate = itemView.findViewById(R.id.contact_message_time_display);
            this.contactImageMessage = itemView.findViewById(R.id.contact_image_message);
        }
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.message_recycler_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        List<Message> messageList = new ArrayList<>(privateChat.getMessageList().values());
        messageList.sort(Comparator.comparingLong(Message::getTimeStamp));

        Message message = messageList.get(position);

        if (message.getSenderUsername().equals(UserUtils.getUsername())) {
            configureOwnerMessage(holder, message);
        } else {
            configureContactMessage(holder, message);
        }
    }

    private void configureOwnerMessage(ViewHolder holder, Message message) {
        holder.ownerNameDisplay.setText(message.getSenderUsername());
        holder.ownerMessageDate.setText(message.getDate());

        // Mostrar texto si existe
        if (message.getContent() != null && !message.getContent().isEmpty()) {
            holder.ownerMessage.setVisibility(View.VISIBLE);
            holder.ownerMessage.setText(message.getContent());
        } else {
            holder.ownerMessage.setVisibility(View.GONE);
        }

        // Mostrar imagen si existe
        if (message.getImageUrl() != null && !message.getImageUrl().isEmpty()) {
            holder.ownerImageMessage.setVisibility(View.VISIBLE);
            Glide.with(context)
                    .load(message.getImageUrl())
                    .into(holder.ownerImageMessage);
        } else {
            holder.ownerImageMessage.setVisibility(View.GONE);
        }

        holder.ownerMessageContainer.setVisibility(View.VISIBLE);
        holder.contactMessageContainer.setVisibility(View.GONE);
    }

    private void configureContactMessage(ViewHolder holder, Message message) {
        holder.contactNameDisplay.setText(message.getSenderUsername());
        holder.contactMessageDate.setText(message.getDate());

        // Mostrar texto si existe
        if (message.getContent() != null && !message.getContent().isEmpty()) {
            holder.contactMessage.setVisibility(View.VISIBLE);
            holder.contactMessage.setText(message.getContent());
        } else {
            holder.contactMessage.setVisibility(View.GONE);
        }

        // Mostrar imagen si existe
        if (message.getImageUrl() != null && !message.getImageUrl().isEmpty()) {
            holder.contactImageMessage.setVisibility(View.VISIBLE);
            Glide.with(context)
                    .load(message.getImageUrl())
                    .into(holder.contactImageMessage);
        } else {
            holder.contactImageMessage.setVisibility(View.GONE);
        }

        holder.contactMessageContainer.setVisibility(View.VISIBLE);
        holder.ownerMessageContainer.setVisibility(View.GONE);
    }

    @Override
    public int getItemCount() {
        if (privateChat == null || privateChat.getMessageList() == null) {
            return 0;
        }
        return privateChat.getMessageList().size();
    }
}