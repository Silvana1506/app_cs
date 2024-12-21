class Mensaje {
  final String id;
  final String mensaje;
  final String idPaciente;
  final String idMedico;
  final String estado;
  final DateTime fecha;
  final String? respuesta; // Opcional
  final DateTime? fechaRespuesta; // Opcional

  Mensaje({
    required this.id,
    required this.mensaje,
    required this.idPaciente,
    required this.idMedico,
    required this.estado,
    required this.fecha,
    this.respuesta, // Puede ser null si no hay respuesta
    this.fechaRespuesta, // Puede ser null si no hay fecha de respuesta
  });

  // Convertir un documento Firestore a objeto Mensaje
  factory Mensaje.fromFirestore(Map<String, dynamic> data, String id) {
    return Mensaje(
      id: id,
      mensaje: data['mensaje'],
      idPaciente: data['idPaciente'],
      idMedico: data['idMedico'],
      estado: data['estado'],
      fecha: DateTime.parse(data['fecha']),
      respuesta: data['respuesta'], // Puede ser null
      fechaRespuesta: data['fechaRespuesta'] != null
          ? DateTime.parse(data['fechaRespuesta'])
          : null, // Puede ser null
    );
  }

  // Convertir un objeto Mensaje a un mapa de datos para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'mensaje': mensaje,
      'idPaciente': idPaciente,
      'idMedico': idMedico,
      'estado': estado,
      'fecha': fecha.toIso8601String(),
      if (respuesta != null) 'respuesta': respuesta, // Incluir solo si existe
      if (fechaRespuesta != null)
        'fechaRespuesta':
            fechaRespuesta!.toIso8601String(), // Incluir solo si existe
    };
  }
}
