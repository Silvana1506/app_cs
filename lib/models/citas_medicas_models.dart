class CitasMedicas {
  final String id;
  final String medico;
  final String date; // Fecha en formato String
  final String time; // Hora en formato String
  final bool isPast; // Indica si la cita es pasada o futura

  CitasMedicas({
    required this.id,
    required this.medico,
    required this.date,
    required this.time,
    required this.isPast,
  });

  // Crear un objeto `CitasMedicas` desde Firestore
  factory CitasMedicas.fromJson(Map<String, dynamic> json, String id) {
    final dateTime = DateTime.parse(json['date']); // Convertimos la fecha
    final now = DateTime.now(); // Obtenemos la fecha/hora actual

    return CitasMedicas(
      id: id,
      medico: json['medico'],
      date: json['date'],
      time: json['time'],
      isPast: dateTime.isBefore(now), // Verificamos si la cita es pasada
    );
  }

  // Convertir un objeto `CitasMedicas` a un mapa para Firestore
  Map<String, dynamic> toJson() {
    return {
      'medico': medico,
      'date': date,
      'time': time,
    };
  }
}
