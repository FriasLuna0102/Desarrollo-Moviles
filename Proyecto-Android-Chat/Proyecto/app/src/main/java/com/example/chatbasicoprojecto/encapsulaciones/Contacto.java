package com.example.chatbasicoprojecto.encapsulaciones;

import java.util.ArrayList;
import java.util.List;

public class Contacto {
    private String email;
    private List<String> contactsEmail;

    public Contacto() {
    }

    public Contacto(String email) {
        this.email = email;
        this.contactsEmail = new ArrayList<>();
    }

    public List<String> getContactsEmail() {
        return contactsEmail;
    }

    public void setContactsEmail(List<String> contactsEmail) {
        this.contactsEmail = contactsEmail;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
