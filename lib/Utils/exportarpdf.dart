import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

Future<void> exportarExamenPDF(List<QueryDocumentSnapshot> examenes) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.ListView.builder(
          itemCount: examenes.length,
          itemBuilder: (context, index) {
            final examen = examenes[index];
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Examen: ${examen['nombre']}"),
                pw.Text("Fecha: ${examen['fechaexamen'].toDate()}"),
                pw.Text("Descripción: ${examen['descripcion']}"),
                // Agrega más campos si es necesario
                pw.Divider(),
              ],
            );
          },
        );
      },
    ),
  );

  // Guardar el PDF en el directorio temporal
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/examenes.pdf");
  await file.writeAsBytes(await pdf.save());

  developer.log("PDF guardado en ${file.path}");
}
