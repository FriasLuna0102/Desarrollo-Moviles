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

public class MessageItemRecyclerAdapter extends RecyclerView.Adapter<MessageItemRecyclerAdapter.ViewHolder> {
    private PrivateChat privateChat;

    public MessageItemRecyclerAdapter(PrivateChat privateChat){
        this.privateChat = privateChat;
    }

    public static class ViewHolder extends RecyclerView.ViewHolder{
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
            holder.ownerNameDisplay.setText(message.getSenderUsername());
            holder.ownerMessageDate.setText(message.getDate());

            if (message.getImageUrl() != null && !message.getImageUrl().isEmpty()) {
                holder.ownerMessage.setVisibility(View.GONE);
                holder.ownerImageMessage.setVisibility(View.VISIBLE);
                Glide.with(holder.itemView.getContext())
                        .load(message.getImageUrl())
                        .into(holder.ownerImageMessage);
            } else {
                holder.ownerMessage.setVisibility(View.VISIBLE);
                holder.ownerImageMessage.setVisibility(View.GONE);
                holder.ownerMessage.setText(message.getContent());
            }

            holder.ownerMessageContainer.setVisibility(View.VISIBLE);
            holder.contactMessageContainer.setVisibility(View.GONE);
        } else {
            holder.contactNameDisplay.setText(message.getSenderUsername());
            holder.contactMessageDate.setText(message.getDate());

            if (message.getImageUrl() != null && !message.getImageUrl().isEmpty()) {
                holder.contactMessage.setVisibility(View.GONE);
                holder.contactImageMessage.setVisibility(View.VISIBLE);
                Glide.with(holder.itemView.getContext())
                        .load(message.getImageUrl())
                        .into(holder.contactImageMessage);
            } else {
                holder.contactMessage.setVisibility(View.VISIBLE);
                holder.contactImageMessage.setVisibility(View.GONE);
                holder.contactMessage.setText(message.getContent());
            }

            holder.contactMessageContainer.setVisibility(View.VISIBLE);
            holder.ownerMessageContainer.setVisibility(View.GONE);
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