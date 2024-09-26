package com.example.chatbasicoprojecto.encapsulaciones;

public class Message {
    private String senderUsername;
    private String content;
    private long timeStamp;

    public Message() {
    }

    public Message(String senderUsername, String content) {
        this.senderUsername = senderUsername;
        this.content = content;
        this.timeStamp = System.currentTimeMillis();
    }

    public String getSenderUsername() {
        return senderUsername;
    }

    public void setSenderUsername(String senderUsername) {
        this.senderUsername = senderUsername;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public long getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(long timeStamp) {
        this.timeStamp = timeStamp;
    }
}
