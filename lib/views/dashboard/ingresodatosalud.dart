import 'package:cronosalud/Utils/textapp.dart';
import 'package:cronosalud/controllers/datos_salud_controlador.dart';
import 'package:cronosalud/widgets/buttons/my_back_button.dart';
import 'package:cronosalud/widgets/buttons/my_login_button.dart';
import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:cronosalud/widgets/fields/myfieldform.dart';
import 'package:flutter/material.dart';

class IngresoDatoSaludScreen extends StatefulWidget {
  final String userId; // El RUT del usuario

  const IngresoDatoSaludScreen({
    super.key,
    required this.userId,
  });

  @override
  State<IngresoDatoSaludScreen> createState() => _IngresoDatoSaludScreenState();
}

class _IngresoDatoSaludScreenState extends State<IngresoDatoSaludScreen> {
  final TextEditingController _glucosaController = TextEditingController();
  final TextEditingController _presionController = TextEditingController();
  final TextEditingController _medicamentoController = TextEditingController();

  String? _glucosaError;
  String? _presionError;
  String? _medicamentoError;

  final ControladorDatosSalud controlador = ControladorDatosSalud();

  @override
  void dispose() {
    _glucosaController.dispose();
    _presionController.dispose();
    _medicamentoController.dispose();
    super.dispose();
  }

  bool validateInputs() {
    setState(() {
      _glucosaError = null;
      _presionError = null;
      _medicamentoError = null;
    });

    bool isValid = true;

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

    if (_medicamentoController.text.isEmpty) {
      _medicamentoError = 'El medicamento es requerido';
      isValid = false;
    }

    return isValid;
  }

  Future<void> _guardarDatosSalud() async {
    if (!validateInputs()) {
      return;
    }

    try {
      await controlador.guardarDatosSalud(
        userId: widget.userId,
        glucosa: int.parse(_glucosaController.text.trim()),
        presion: _presionController.text.trim(),
        medicamento: _medicamentoController.text.trim(),
      );

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
    final height = MediaQuery.of(context).size.height;
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
                  image: AssetImage('assets/images/imagen1.jpg'),
                  fit: BoxFit.cover, // La imagen cubre toda la pantalla
                ),
              ),
            ),
            // Contenido principal
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ContainerShape01(),
            ),
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
                            Myfieldform(
                              tittle: TextApp.glucosa,
                              controller: _glucosaController,
                              icon: Icons.monitor_heart,
                              errorText: _glucosaError,
                              validator: null,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 15),
                            Myfieldform(
                              tittle: TextApp.presion,
                              controller: _presionController,
                              icon: Icons.favorite,
                              errorText: _presionError,
                              validator: null,
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 15),
                            Myfieldform(
                              tittle: TextApp.medicamento,
                              controller: _medicamentoController,
                              icon: Icons.medical_services,
                              errorText: _medicamentoError,
                              validator: null,
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 20),
                            MyLoginButton(
                              text: TextApp.savedatossalud,
                              colortext: Colors.black,
                              colorbuttonbackground: Colors.lightBlueAccent,
                              widgetToNavigate:
                                  null, // No es necesario especificar aquí la navegación directa
                              onPressed: _guardarDatosSalud,
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
