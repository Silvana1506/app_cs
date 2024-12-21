import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/citas_medicas_models.dart';
import 'dart:developer' as developer;

class CitasMedicasController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener las citas médicas del usuario
  Future<List<CitasMedicas>> fetchAppointments(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('citasmedicas')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => CitasMedicas.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      developer.log('Error al obtener citas: $e');
      return [];
    }
  }
}
