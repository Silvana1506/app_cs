import 'package:cloud_firestore/cloud_firestore.dart';

class HealthData {
  final String id;
  final String userId;
  final String rut;
  final int glucosa;
  final String presion;
  final String peso;
  final DateTime fecha;

  HealthData(
      {required this.id,
      required this.userId,
      required this.rut,
      required this.glucosa,
      required this.presion,
      required this.peso,
      required this.fecha});

  // Convertir de JSON a objeto
  factory HealthData.fromJson(Map<String, dynamic> json, String id) {
    return HealthData(
      id: id,
      userId: json['userId'],
      rut: json['rut'],
      glucosa: json['glucosa'],
      presion: json['presion'],
      peso: json['peso'],
      fecha: (json['fecha'] as Timestamp).toDate(),
    );
  }

  // Función opcional para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'rut': rut,
      'glucosa': glucosa,
      'presion': presion,
      'peso': peso,
      'fecha': fecha,
    };
  }
}
