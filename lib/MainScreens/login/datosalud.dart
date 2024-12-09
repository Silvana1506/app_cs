import 'package:cronosalud/MainScreens/widgets/components/buttons/my_back_button.dart';
import 'package:cronosalud/MainScreens/widgets/components/container/container_shape01.dart';
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

  String? _glucosaError;
  String? _presionError;

  @override
  void dispose() {
    // Liberar controladores cuando ya no se necesiten
    _glucosaController.dispose();
    _presionController.dispose();
    _medicamentoController.dispose();
    super.dispose();
  }

  bool validateInputs() {
    setState(() {
      _glucosaError = null;
      _presionError = null;
    });

    bool isValid = true;

    // Validar glucosa (70-150 mg/dL)
    if (_glucosaController.text.isEmpty) {
      _glucosaError = 'El nivel de glucosa es requerido';
      isValid = false;
    } else {
      final glucosaValue = int.tryParse(_glucosaController.text.trim());
      if (glucosaValue == null || glucosaValue < 70 || glucosaValue > 150) {
        _glucosaError = 'Ingrese un valor entre 70 y 150 mg/dL';
        isValid = false;
      }
    }

    // Validar presión arterial (ejemplo: 120/80 mmHg)
    if (_presionController.text.isEmpty) {
      _presionError = 'La presión arterial es requerida';
      isValid = false;
    } else if (!_presionController.text.contains('/')) {
      _presionError = 'Formato incorrecto (ejemplo: 120/80)';
      isValid = false;
    } else {
      final presionValues = _presionController.text.split('/');
      if (presionValues.length != 2 ||
          int.tryParse(presionValues[0].trim()) == null ||
          int.tryParse(presionValues[1].trim()) == null) {
        _presionError = 'Ingrese valores numéricos válidos (ejemplo: 120/80)';
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> saveHealthData() async {
    if (!validateInputs()) {
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
    final double height =
        MediaQuery.of(context).size.height; // Obtener altura de pantalla

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Imagen de fondo
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/imagen3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Fondo decorativo en la parte superior
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ContainerShape01(),
            ),
            // Contenido principal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.15),
                    const Text(
                      "Ingresar Datos de Salud",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Campo de glucosa
                            TextField(
                              controller: _glucosaController,
                              decoration: InputDecoration(
                                labelText: 'Nivel de Glucosa (mg/dL)',
                                errorText: _glucosaError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: const Icon(Icons.monitor_heart),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 15),
                            // Campo de presión arterial
                            TextField(
                              controller: _presionController,
                              decoration: InputDecoration(
                                labelText: 'Presión Arterial (mmHg)',
                                errorText: _presionError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: const Icon(Icons.favorite),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 15),
                            // Campo de medicamentos
                            TextField(
                              controller: _medicamentoController,
                              decoration: InputDecoration(
                                labelText: 'Medicamentos',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: const Icon(Icons.medical_services),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 20),
                            // Botón para guardar
                            ElevatedButton(
                              onPressed: saveHealthData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 50.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                'Guardar Datos',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: height * 0.01,
              left: 0.01,
              child: MyBackButton(),
            ),
          ],
        ),
      ),
    );
  }
}
