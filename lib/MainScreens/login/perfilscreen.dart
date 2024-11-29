import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/MainScreens/login/editinfopersonal.dart';
import 'package:cronosalud/MainScreens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class PerfilScreen extends StatelessWidget {
  final String userId; // El RUT del usuario

  const PerfilScreen({super.key, required this.userId});

  Future<Map<String, dynamic>?> fetchUserData(String rut) async {
    try {
      // Consultar datos del usuario por su RUT en Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('rut', isEqualTo: rut)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Retornar los datos del usuario
        return snapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null; // Si no se encuentra el usuario
      }
    } catch (e) {
      developer.log("Error al obtener datos del usuario: $e");
      return null;
    }
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Cierra sesión en Firebase
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Elimina todas las rutas anteriores
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cerrar sesión: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
                child: Text('No se encontraron datos del usuario'));
          } else {
            // Datos del usuario
            final userData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Información del usuario
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueAccent,
                        backgroundImage:
                            AssetImage('assets/images/profile_placeholder.png'),
                        child: const Icon(Icons.account_circle,
                            color: Colors.white),
                      ),
                      title: Text(
                        'Nombre: ${userData['username'] ?? 'No especificado'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        'Correo: ${userData['email'] ?? 'No especificado'}',
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.phone, color: Colors.blueAccent),
                      title: Text(
                        'Teléfono: ${userData['phone'] ?? 'No especificado'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.blueAccent),
                      title: Text(
                        'Sexo: ${userData['sexo'] ?? 'No especificado'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading:
                          Icon(Icons.calendar_today, color: Colors.blueAccent),
                      title: Text(
                        'Fecha de nacimiento: ${userData['fnacimiento'] ?? 'No especificado'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Botón para editar información
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            userId: userId, // Pasamos el RUT o ID del usuario
                            userData: snapshot
                                .data!, // Pasamos los datos actuales del usuario
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Editar Perfil',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Botón para cerrar sesión
                  ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
