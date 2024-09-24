package com.example.chatbasicoprojecto.encapsulaciones;

import java.util.ArrayList;
import java.util.List;

public class PrivateChat {
    private String ownerUsername;
    private String contactUsername;
    private List<Message> messageList;

    public PrivateChat() {
    }

    public PrivateChat(String ownerUsername, String contactUsername) {
        this.ownerUsername = ownerUsername;
        this.contactUsername = contactUsername;
        this.messageList = new ArrayList<>();
    }

    public String getOwnerUsername() {
        return ownerUsername;
    }

    public void setOwnerUsername(String ownerUsername) {
        this.ownerUsername = ownerUsername;
    }

    public String getContactUsername() {
        return contactUsername;
    }

    public void setContactUsername(String contactUsername) {
        this.contactUsername = contactUsername;
    }

    public List<Message> getMessageList() {
        return messageList;
    }

    public void setMessageList(List<Message> messageList) {
        this.messageList = messageList;
    }
}
