import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatoSaludScreen extends StatefulWidget {
  final String userId;

  const DatoSaludScreen({super.key, required this.userId});

  @override
  State<DatoSaludScreen> createState() => _DatoSaludScreenState();
}

class _DatoSaludScreenState extends State<DatoSaludScreen> {
  final TextEditingController _glucosaController = TextEditingController();
  final TextEditingController _presionController = TextEditingController();
  final TextEditingController _medicamentoController = TextEditingController();

  @override
  void dispose() {
    // Liberar controladores cuando ya no se necesiten
    _glucosaController.dispose();
    _presionController.dispose();
    _medicamentoController.dispose();
    super.dispose();
  }

  Future<void> saveHealthData() async {
    // Validar si todos los campos están llenos
    if (_glucosaController.text.isEmpty ||
        _presionController.text.isEmpty ||
        _medicamentoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    try {
      // Guardar datos en Firestore
      await FirebaseFirestore.instance.collection('healthData').add({
        'userId': widget.userId,
        'glucosa': _glucosaController.text.trim(),
        'presion': _presionController.text.trim(),
        'medicamento': _medicamentoController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados correctamente')),
        );
      }

      // Limpiar los campos después de guardar
      _glucosaController.clear();
      _presionController.clear();
      _medicamentoController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los datos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar Datos de Salud'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _glucosaController,
              decoration: const InputDecoration(
                labelText: 'Nivel de Glucosa (mg/dL)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _presionController,
              decoration: const InputDecoration(
                labelText: 'Presión Arterial (mmHg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _medicamentoController,
              decoration: const InputDecoration(
                labelText: 'Medicamentos',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveHealthData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Guardar Datos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
