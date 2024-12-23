import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/modelo_datos_salud.dart'; // Asegúrate de importar tu modelo

class ControladorDatosSalud {
  final _collection = FirebaseFirestore.instance.collection('healthData');
  final _collectionUsuarios = FirebaseFirestore.instance.collection('users');

  // Obtener el RUT de un usuario dado el userId
  Future<String?> obtenerRutDelUsuario(String userId) async {
    try {
      DocumentSnapshot userDoc = await _collectionUsuarios.doc(userId).get();
      if (userDoc.exists) {
        return userDoc['rut']; // Aquí tomamos el RUT del usuario
      }
    } catch (e) {
      throw Exception('Error al obtener el RUT del usuario: $e');
    }
    return null;
  }

  // Guardar datos de salud
  Future<void> guardarDatosSalud({
    required String userId,
    required String rut,
    required int glucosa,
    required String presion,
    required String peso,
  }) async {
    try {
      await _collection.add({
        'userId': userId,
        'rut': rut,
        'glucosa': glucosa,
        'presion': presion,
        'peso': peso,
        'fecha': FieldValue.serverTimestamp(), // Fecha actual
      });
    } catch (e) {
      throw Exception('Error al guardar los datos: $e');
    }
  }

  // Función para obtener los datos de salud de un usuario específico por userId o rut
  Stream<List<HealthData>> getHealthData(String userId, {String? rut}) {
    // Si no se pasa rut, se buscará por userId
    return _collection
        .where('userId', isEqualTo: userId) // Filtrar por userId
        .where('rut', isEqualTo: rut ?? "") // Filtrar por rut si se proporciona
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Convertir el documento en un objeto HealthData
        return HealthData.fromJson(data, doc.id);
      }).toList();
    });
  }
}
