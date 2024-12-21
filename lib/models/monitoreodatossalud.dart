import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonitoreoDatosSaludScreen extends StatefulWidget {
  const MonitoreoDatosSaludScreen({super.key});

  @override
  State<MonitoreoDatosSaludScreen> createState() =>
      _MonitoreoDatosSaludScreenState();
}

class _MonitoreoDatosSaludScreenState extends State<MonitoreoDatosSaludScreen> {
  String _selectedParametro = 'glucosa';
  DateTime? _startDate;
  DateTime? _endDate;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mi Salud en Gráficos"),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Column(
          children: [
            // Widget para filtros
            _buildFiltros(),
// Sección para mostrar datos
            Expanded(
              child: StreamBuilder(
                stream: _getFilteredData(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(
                      child:
                          Text("No hay datos para los filtros seleccionados."),
                    );
                  }

                  return _buildDataTable(docs);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para los filtros
  Widget _buildFiltros() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.lightGreen,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filtrar por Parámetro:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _selectedParametro,
            onChanged: (value) {
              setState(() {
                _selectedParametro = value!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: 'glucosa',
                child: Text("Glucosa"),
              ),
              DropdownMenuItem(
                value: 'presion_arterial',
                child: Text("Presión Arterial"),
              ),
              DropdownMenuItem(
                value: 'peso',
                child: Text("Peso"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _selectDate(context, isStart: true),
                  child: Text(
                    _startDate == null
                        ? "Seleccionar Fecha Inicio"
                        : "Inicio: ${DateFormat('dd/MM/yyyy').format(_startDate!)}",
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _selectDate(context, isStart: false),
                  child: Text(
                    _endDate == null
                        ? "Seleccionar Fecha Fin"
                        : "Fin: ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_startDate != null &&
                  _endDate != null &&
                  _startDate!.isAfter(_endDate!)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "La fecha de inicio debe ser antes de la fecha de fin."),
                  ),
                );
                return;
              }
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
            child: const Text("Aplicar Filtros"),
          ),
        ],
      ),
    );
  }

  /// Muestra la tabla de datos
  Widget _buildDataTable(List<QueryDocumentSnapshot> docs) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Fecha")),
          DataColumn(label: Text("Valor")),
        ],
        rows: docs.map((data) {
          return DataRow(cells: [
            DataCell(
                Text(DateFormat('dd/MM/yyyy').format(data['fecha'].toDate()))),
            DataCell(Text(data[_selectedParametro]?.toString() ?? 'N/A')),
          ]);
        }).toList(),
      ),
    );
  }

  /// Selecciona una fecha
  Future<void> _selectDate(BuildContext context,
      {required bool isStart}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  /// Obtiene los datos filtrados de Firestore
  Stream<QuerySnapshot> _getFilteredData() {
    // Si el usuario no está autenticado, no devuelve datos
    if (user == null) {
      return const Stream.empty();
    }

    Query query = FirebaseFirestore.instance
        .collection('DatosSalud')
        .where('uid', isEqualTo: user!.uid); // Filtra por UID del usuario

    if (_startDate != null) {
      query = query.where('fecha',
          isGreaterThanOrEqualTo: Timestamp.fromDate(_startDate!));
    }
    if (_endDate != null) {
      query = query.where('fecha',
          isLessThanOrEqualTo: Timestamp.fromDate(_endDate!));
    }
    return query.snapshots();
  }
}
