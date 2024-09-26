package com.example.chatbasicoprojecto.encapsulaciones;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PrivateChat {
    private String ownerUsername;
    private String contactUsername;
    private Map<String, Message> messageList;

    public PrivateChat() {
    }

    public PrivateChat(String ownerUsername, String contactUsername) {
        this.ownerUsername = ownerUsername;
        this.contactUsername = contactUsername;
        this.messageList = new HashMap<>();
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

    public Map<String, Message> getMessageList() {
        return messageList;
    }

    public void setMessageList(Map<String, Message> messageList) {
        this.messageList = messageList;
    }
}
