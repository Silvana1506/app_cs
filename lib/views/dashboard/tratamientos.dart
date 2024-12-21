import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

class TratamientosScreen extends StatefulWidget {
  final String userId; // ID del usuario para filtrar los tratamientos

  const TratamientosScreen({super.key, required this.userId});

  @override
  State<TratamientosScreen> createState() => _TratamientosScreenState();
}

class _TratamientosScreenState extends State<TratamientosScreen> {
  String? selectedTipoTratamiento; // Para el filtro de tipo de tratamiento
  DateTime? selectedFecha; // Para el filtro de fecha
  List<Map<String, dynamic>> tratamientos = []; // Lista de tratamientos

  @override
  void initState() {
    super.initState();
    _loadTratamientos(); // Cargar los tratamientos al inicio
  }

  // Recuperar los datos del historial de tratamientos desde Firebase
  Future<void> _loadTratamientos() async {
    try {
      // Consulta de los tratamientos del usuario
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('healthData')
          .where('userId', isEqualTo: widget.userId)
          .get();

      setState(() {
        tratamientos = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    } catch (e) {
      // Manejo de errores en caso de que la consulta falle
      developer.log("Error al cargar los tratamientos: $e");
    }
  }

  // Filtrar tratamientos según el tipo y la fecha
  List<Map<String, dynamic>> getFilteredTratamientos() {
    return tratamientos.where((tratamiento) {
      bool matchTipo = true;
      bool matchFecha = true;

      // Filtrado por tipo de tratamiento
      if (selectedTipoTratamiento != null) {
        matchTipo = tratamiento['tipoTratamiento'] == selectedTipoTratamiento;
      }

      // Filtrado por fecha
      if (selectedFecha != null) {
        DateTime tratamientoFecha =
            (tratamiento['timestamp'] as Timestamp).toDate();
        matchFecha = tratamientoFecha.year == selectedFecha!.year &&
            tratamientoFecha.month == selectedFecha!.month &&
            tratamientoFecha.day == selectedFecha!.day;
      }

      return matchTipo && matchFecha;
    }).toList();
  }

  // Mostrar un filtro de fecha
  Future<void> _selectFecha(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedFecha) {
      setState(() {
        selectedFecha = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Tratamientos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filtro de tipo de tratamiento
            DropdownButton<String>(
              value: selectedTipoTratamiento,
              hint: const Text("Selecciona un tipo de tratamiento"),
              onChanged: (newValue) {
                setState(() {
                  selectedTipoTratamiento = newValue;
                });
              },
              items: ['Medicamento', 'Terapia', 'Consulta'].map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),

            // Filtro de fecha
            TextButton(
              onPressed: () => _selectFecha(context),
              child: Text(
                selectedFecha == null
                    ? 'Seleccionar Fecha'
                    : 'Fecha: ${selectedFecha!.toLocal()}'.split(' ')[0],
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),

            // Lista de tratamientos
            Expanded(
              child: ListView.builder(
                itemCount: getFilteredTratamientos().length,
                itemBuilder: (context, index) {
                  var tratamiento = getFilteredTratamientos()[index];
                  DateTime tratamientoFecha =
                      (tratamiento['timestamp'] as Timestamp).toDate();

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(tratamiento['tipoTratamiento']),
                      subtitle: Text('Fecha: ${tratamientoFecha.toLocal()}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
