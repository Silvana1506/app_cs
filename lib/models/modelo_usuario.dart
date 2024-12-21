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

  factory Users.fromJson(Map<String, dynamic> json, String id) {
    return Users(
      id: id,
      name: json['nombre'],
      apaterno: json['apaterno'],
      amaterno: json['amaterno'],
      rut: json['rut'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      sexo: json['sexo'],
      fnacimiento: json['fnacimiento'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
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
