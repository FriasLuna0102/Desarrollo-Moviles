package com.example.chatbasicoprojecto.encapsulaciones;

import android.os.Build;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class Message {
    private String senderUsername;
    private String content;
    private long timeStamp;
    private String date;

    public Message() {
    }

    public Message(String senderUsername, String content) {
        this.senderUsername = senderUsername;
        this.content = content;
        this.timeStamp = System.currentTimeMillis();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            this.date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("HH:mm"));
        }

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

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
