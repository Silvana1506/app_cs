import 'package:cloud_firestore/cloud_firestore.dart';

class HealthData {
  final String id;
  final String userId;
  final int glucosa;
  final String presion;
  final String medicamento;
  final DateTime timestamp;

  HealthData({
    required this.id,
    required this.userId,
    required this.glucosa,
    required this.presion,
    required this.medicamento,
    required this.timestamp,
  });

  // Convertir de JSON a objeto
  factory HealthData.fromJson(Map<String, dynamic> json, String id) {
    return HealthData(
      id: id,
      userId: json['userId'],
      glucosa: json['glucosa'],
      presion: json['presion'],
      medicamento: json['medicamento'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  // Función opcional para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'glucosa': glucosa,
      'presion': presion,
      'medicamento': medicamento,
      'timestamp': timestamp,
    };
  }
}
