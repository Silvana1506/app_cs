import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

Future<void> exportarPDF(List<QueryDocumentSnapshot> tratamientos) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.ListView.builder(
          itemCount: tratamientos.length,
          itemBuilder: (context, index) {
            final tratamiento = tratamientos[index];
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Tratamiento: ${tratamiento['tratamiento']}"),
                pw.Text("Descripción: ${tratamiento['descripcion']}"),
                pw.Text("Fecha Inicio: ${tratamiento['fechaInicio'].toDate()}"),
                pw.Text("Fecha Fin: ${tratamiento['fechaFin'].toDate()}"),
                pw.Text("Estado: ${tratamiento['estatus']}"),
                pw.Divider(),
              ],
            );
          },
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/tratamientos.pdf");
  await file.writeAsBytes(await pdf.save());

  developer.log("PDF guardado en ${file.path}");
}
