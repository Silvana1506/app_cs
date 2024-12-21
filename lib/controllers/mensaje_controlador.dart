import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/mensajes_models.dart';

class MensajeController {
  final _firestore = FirebaseFirestore.instance;

  // Obtener mensajes pendientes para un médico específico
  Stream<List<Mensaje>> obtenerMensajesPendientes(String idMedico) {
    return _firestore
        .collection('mensajes')
        .where('idMedico', isEqualTo: idMedico)
        .where('estado', isEqualTo: 'pendiente')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Mensaje.fromFirestore(doc.data(), doc.id);
            }).toList());
  }

  // Enviar respuesta al mensaje
  Future<void> enviarRespuesta(String mensajeId, String respuesta) async {
    await _firestore.collection('mensajes').doc(mensajeId).update({
      'respuesta': respuesta,
      'estado': 'respondido',
      'fechaRespuesta': DateTime.now().toIso8601String(),
    });
  }

// Función para enviar un mensaje a Firestore
  Future<void> enviarMensaje(Mensaje mensaje) async {
    try {
      await _firestore.collection('mensajes').add(mensaje.toFirestore());
    } catch (e) {
      throw Exception("Error al enviar el mensaje: $e");
    }
  }
}
