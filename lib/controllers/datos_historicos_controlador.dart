import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/modelo_datos_salud.dart';

class HealthDataController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<HealthData>> getHistoricalData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startTimestamp = Timestamp.fromDate(startDate);
    final endTimestamp = Timestamp.fromDate(endDate);

    try {
      final querySnapshot = await _db
          .collection('healthData')
          .where('userId', isEqualTo: userId)
          .where('fecha', isGreaterThanOrEqualTo: startTimestamp)
          .where('fecha', isLessThanOrEqualTo: endTimestamp)
          .orderBy('fecha')
          .get();

      List<HealthData> data = querySnapshot.docs
          .map((doc) =>
              HealthData.fromJson(doc.data(), doc.id)) // Aquí pasamos el id
          .toList();

      return data;
    } catch (e) {
      throw Exception('Error al obtener los datos históricos: $e');
    }
  }
}
