import 'package:cronosalud/views/dashboard/tratamientos.dart';
import 'package:cronosalud/widgets/buttons/my_back_button.dart';
import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class PatologiasScreen extends StatefulWidget {
  final String userId;

  const PatologiasScreen({required this.userId, super.key});

  @override
  State<PatologiasScreen> createState() => _PatologiasScreenState();
}

class _PatologiasScreenState extends State<PatologiasScreen> {
  List<String> patologias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarPatologias();
  }

  Future<void> _cargarPatologias() async {
    try {
      setState(() {
        isLoading = true;
      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tratamientos')
          .where('userId', isEqualTo: widget.userId)
          .get();

      // Extrae las patologías únicas
      patologias = querySnapshot.docs
          .map((doc) => doc['patologia'] as String)
          .toSet()
          .toList();
    } catch (e) {
      developer.log("Error al cargar las patologías: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // Definir `height`

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
                    padding: const EdgeInsets.all(10.0), // Espaciado interno

                    child: const Text(
                      'Mis Patologías Crónicas',
                      style: TextStyle(
                        fontSize: 28, // Tamaño de letra mayor
                        fontWeight: FontWeight.bold, // Texto en negrita
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : patologias.isEmpty
                            ? const Center(
                                child: Text('No hay patologías registradas.'))
                            : ListView.builder(
                                itemCount: patologias.length,
                                itemBuilder: (context, index) {
                                  final patologia = patologias[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 20.0),
                                      tileColor: Colors
                                          .grey.shade100, // Fondo gris claro
                                      title: Text(
                                        patologia,
                                        style: const TextStyle(
                                          fontSize: 20, // Tamaño de letra
                                          fontWeight: FontWeight
                                              .bold, // Texto en negrita
                                          color:
                                              Colors.black, // Color del texto
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black, // Color del ícono
                                      ),
                                      onTap: () {
                                        // Navega a la pantalla de tratamientos por patología
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TratamientosScreen(
                                              userId: widget.userId,
                                              patologia: patologia,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
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
