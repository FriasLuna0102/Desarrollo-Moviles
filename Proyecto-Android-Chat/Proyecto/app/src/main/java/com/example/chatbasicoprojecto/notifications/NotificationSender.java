package com.example.chatbasicoprojecto.notifications;

import okhttp3.*;

import java.io.IOException;

public class NotificationSender {

    public void sendNotification(String toToken, String title, String body) {
        OkHttpClient client = new OkHttpClient();

        // URL de la Cloud Function
        String url = "https://us-central1-androidchatfb-53eb6.cloudfunctions.net/sendNotification";

        // Cuerpo de la solicitud JSON
        String json = "{"
                + "\"toToken\":\"" + toToken + "\","
                + "\"title\":\"" + title + "\","
                + "\"body\":\"" + body + "\""
                + "}";

        // Crear el cuerpo de la solicitud
        RequestBody requestBody = RequestBody.create(json, MediaType.get("application/json; charset=utf-8"));

        // Crear la solicitud POST
        Request request = new Request.Builder()
                .url(url)
                .post(requestBody)
                .build();

        // Ejecutar la solicitud
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                // Manejar el error
                e.printStackTrace();
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                if (response.isSuccessful()) {
                    // Notificación enviada exitosamente
                    System.out.println("Notificación enviada: " + response.body().string());
                } else {
                    // Error al enviar la notificación
                    System.out.println("Error enviando notificación: " + response.code());
                }
            }
        });
    }
}
