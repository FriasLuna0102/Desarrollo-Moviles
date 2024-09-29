const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification = functions.https.onRequest((req, res) => {
  const toToken = req.body.toToken; // Token del destinatario
  const message = {
    notification: {
      title: req.body.title, // Título de la notificación
      body: req.body.body, // Cuerpo de la notificación
    },
    token: toToken, // Token del destinatario
  };

  admin.messaging().send(message)
      .then((response) => {
        res.status(200).send(`Notificación enviada correctamente: ${response}`);
      })
      .catch((error) => {
        res.status(500).send(`Error enviando notificación: ${error}`);
      });
});
