import 'package:cronosalud/models/interfazmedicamento.dart';
import 'package:cronosalud/widgets/buttons/my_back_button.dart';
import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class TratamientosScreen extends StatefulWidget {
  final String userId;
  final String patologia;

  const TratamientosScreen({
    required this.userId,
    required this.patologia,
    super.key,
  });

  @override
  State<TratamientosScreen> createState() => _TratamientosScreenState();
}

class _TratamientosScreenState extends State<TratamientosScreen> {
  List<Map<String, dynamic>> tratamientos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarTratamientos();
  }

  Future<void> _cargarTratamientos() async {
    try {
      setState(() {
        isLoading = true;
      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tratamientos')
          .where('userId', isEqualTo: widget.userId)
          .where('patologia', isEqualTo: widget.patologia)
          .get();

      tratamientos = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      developer.log("Error al cargar tratamientos: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
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
                  image: AssetImage('assets/images/imagen4.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Contenedor superior decorativo
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ContainerShape01(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.15),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Tratamiento para: ${widget.patologia}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : tratamientos.isEmpty
                            ? const Center(
                                child: Text(
                                    'No hay tratamientos para esta patología.'),
                              )
                            : ListView.builder(
                                itemCount: tratamientos.length,
                                itemBuilder: (context, index) {
                                  final tratamiento = tratamientos[index];
                                  return Card(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                              tratamiento[
                                                      'nombre_tratamiento'] ??
                                                  'Sin nombre',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Dosis: ${tratamiento['dosis'] ?? 'No especificada'}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Frecuencia: ${tratamiento['frecuencia'] ?? 'No especificada'}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Estado: ${tratamiento['estado'] ?? 'No especificado'}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Observaciones: ${tratamiento['observaciones'] ?? 'Sin observaciones'}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InterfazmedicamentoScreen(
                            documentId: tratamientos.first['id'] ?? '',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.medication, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Notificación de medicamento',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
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
