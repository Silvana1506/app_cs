import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String name;
  final String apaterno;
  final String amaterno;
  final String rut;
  final String email;
  final String password;
  final String phone;
  final String sexo;
  final String fnacimiento;
  final String userType;

  Users({
    required this.id,
    required this.name,
    required this.apaterno,
    required this.amaterno,
    required this.rut,
    required this.email,
    required this.password,
    required this.phone,
    required this.sexo,
    required this.fnacimiento,
    required this.userType,
  });

  // Constructor para crear una instancia desde un documento de Firestore
  factory Users.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Users(
      id: doc.id, // Utiliza el ID del documento como ID del usuario
      name: data['nombre'] ?? '',
      apaterno: data['apaterno'] ?? '',
      amaterno: data['amaterno'] ?? '',
      rut: data['rut'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phone: data['phone'] ?? '',
      sexo: data['sexo'] ?? '',
      fnacimiento: data['fnacimiento'] ?? '',
      userType: data['userType'] ?? '',
    );
  }

  // Convertir la instancia de usuario en un mapa para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': name,
      'apaterno': apaterno,
      'amaterno': amaterno,
      'rut': rut,
      'email': email,
      'password': password,
      'phone': phone,
      'sexo': sexo,
      'fnacimiento': fnacimiento,
      'userType': userType,
    };
  }

  // Método para actualizar valores específicos
  Users copyWith({
    String? name,
    String? apaterno,
    String? amaterno,
    String? email,
    String? phone,
    String? sexo,
    String? fnacimiento,
    String? userType,
  }) {
    return Users(
      id: id,
      name: name ?? this.name,
      apaterno: apaterno ?? this.apaterno,
      amaterno: amaterno ?? this.amaterno,
      rut: rut,
      email: email ?? this.email,
      password: password,
      phone: phone ?? this.phone,
      sexo: sexo ?? this.sexo,
      fnacimiento: fnacimiento ?? this.fnacimiento,
      userType: userType ?? this.userType,
    );
  }

  @override
  String toString() {
    return 'Users(nombre: $name, email: $email, userType: $userType)';
  }
}
