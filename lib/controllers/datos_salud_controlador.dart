import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/modelo_datos_salud.dart'; // Asegúrate de importar tu modelo

class ControladorDatosSalud {
  final _collection = FirebaseFirestore.instance.collection('healthData');

  // Guardar datos de salud
  Future<void> guardarDatosSalud({
    required String userId,
    required int glucosa,
    required String presion,
    required String medicamento,
  }) async {
    try {
      await _collection.add({
        'userId': userId,
        'glucosa': glucosa,
        'presion': presion,
        'medicamento': medicamento,
        'timestamp': FieldValue.serverTimestamp(), // Fecha actual
      });
    } catch (e) {
      throw Exception('Error al guardar los datos: $e');
    }
  }

  // Función para obtener los datos de salud de un usuario específico
  Stream<List<HealthData>> getHealthDataByUser(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
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
