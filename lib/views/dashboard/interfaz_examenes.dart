import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class InterfazExamenes extends StatefulWidget {
  final String userId;

  const InterfazExamenes({super.key, required this.userId});

  @override
  State<InterfazExamenes> createState() => _InterfazExamenesState();
}

class _InterfazExamenesState extends State<InterfazExamenes> {
  late Stream<QuerySnapshot> _examenesStream;

  @override
  void initState() {
    super.initState();
    _examenesStream = FirebaseFirestore.instance
        .collection('examenes')
        .where('userId', isEqualTo: widget.userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Exámenes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _examenesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No se encontraron exámenes.'));
          }

          final examenes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: examenes.length,
            itemBuilder: (context, index) {
              var examen = examenes[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(examen['nombre']),
                  subtitle: Text('Fecha: ${examen['fecha']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      String path = await _descargarExamenPDF(examen);
                      OpenFile.open(path);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String> _descargarExamenPDF(Map<String, dynamic> examen) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child:
            pw.Text('Examen: ${examen['nombre']}\nFecha: ${examen['fecha']}'),
      );
    }));

    final output = await getExternalStorageDirectory();
    final filePath = '${output!.path}/Examen_${examen['id']}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Subir el PDF a Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('examenes/${widget.userId}/Examen_${examen['id']}.pdf');
    await storageRef.putFile(file);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Examen descargado con éxito')),
      );
    }

    return filePath;
  }
}
