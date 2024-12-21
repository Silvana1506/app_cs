import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ExamenesScreen extends StatefulWidget {
  final String userId; // ID del usuario (paciente)

  const ExamenesScreen({super.key, required this.userId});

  @override
  State<ExamenesScreen> createState() => _ExamenesScreenState();
}

class _ExamenesScreenState extends State<ExamenesScreen> {
  List<Map<String, dynamic>> examenes = [
    {'id': '1', 'nombre': 'Examen de Sangre', 'fecha': '2024-12-15'},
    {'id': '2', 'nombre': 'Radiografía de Tórax', 'fecha': '2024-12-10'},
    {'id': '3', 'nombre': 'Electrocardiograma', 'fecha': '2024-12-12'},
    // Esta lista será cargada desde Firestore
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Exámenes'),
      ),
      body: ListView.builder(
        itemCount: examenes.length,
        itemBuilder: (context, index) {
          var examen = examenes[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(examen['nombre']),
              subtitle: Text('Fecha: ${examen['fecha']}'),
              trailing: IconButton(
                icon: Icon(Icons.download),
                onPressed: () {
                  _descargarExamen(
                      examen['id']); // Función para descargar el examen
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _descargarExamen(String examenId) {
    // Aquí implementarás la lógica para generar y descargar el examen en PDF
    developer.log("Descargando examen $examenId");
  }
}
