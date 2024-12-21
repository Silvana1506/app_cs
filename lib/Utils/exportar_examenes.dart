import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExamenesScreen extends StatefulWidget {
  final String userId;

  const ExamenesScreen({super.key, required this.userId});

  @override
  State<ExamenesScreen> createState() => _ExamenesScreenState();
}

class _ExamenesScreenState extends State<ExamenesScreen> {
  List<Map<String, dynamic>> examenes = [
    {'id': '1', 'nombre': 'Examen de Sangre', 'fecha': '2024-12-15'},
    {'id': '2', 'nombre': 'Radiografía de Tórax', 'fecha': '2024-12-10'},
    {'id': '3', 'nombre': 'Electrocardiograma', 'fecha': '2024-12-12'},
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
                onPressed: () async {
                  await _descargarExamenPDF(examen); // Generar PDF y descargar
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _descargarExamenPDF(Map<String, dynamic> examen) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child:
            pw.Text('Examen: ${examen['nombre']}\nFecha: ${examen['fecha']}'),
      );
    }));

    // Guardar el archivo PDF
    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/Examen_${examen['id']}.pdf');
    await file.writeAsBytes(await pdf.save());

    // Mostrar un mensaje de éxito o abrir el archivo PDF
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Examen descargado con éxito')),
    );
  }
}
