/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();


exports.notificarMedico = functions.firestore
    .document("mensajes/{mensajeId}")
    .onCreate(async (snap, context) => {
      const mensaje = snap.data();
      const idMedico = mensaje.idMedico;

      const medicoDoc = await
      admin.firestore().collection("medicos").doc(idMedico).get();
      if (!medicoDoc.exists) {
        console.error("El médico no tiene un token registrado");
        return null;
      }

      const token = medicoDoc.data().token; // Token del dispositivo del médico

      const payload = {
        notification: {
          title: "Nueva consulta de paciente",
          body: mensaje.mensaje,
          clickAction: "FLUTTER_NOTIFICATION_CLICK", // Redirigir a la app móvil
        },
      };

      return admin.messaging()
          .sendToDevice(token, payload)
          .then(() => console.log("Notificación enviada al médico"))
          .catch((error) => console.error(
              "Error al enviar la notificación:", error));
    });

// Función para enviar una notificación al paciente cuando se responde un mensaje
exports.notificarPaciente = functions.firestore
  .document('mensajes/{mensajeId}')
  .onUpdate((change, context) => {
    const after = change.after.data();
    const before = change.before.data();

    // Verificar si el estado cambió a 'respondido'
    if (before.estado !== 'respondido' && after.estado === 'respondido') {
      return admin.firestore().collection('tokens').doc(after.idPaciente).get()
        .then((doc) => {
          if (!doc.exists) {
            console.error("Token del paciente no encontrado.");
            return null;
          }

          const tokenPaciente = doc.data().token; // Obtener el token de Firestore
          const payload = {
            notification: {
              title: "Respuesta recibida",
              body: `El médico respondió: ${after.respuesta}`,
            },
          };

          return admin.messaging().sendToDevice(tokenPaciente, payload)
            .then(() => console.log("Notificación enviada al paciente"))
            .catch((error) => console.error("Error al enviar notificación:", error));
        });
    }

    return null;
  });