import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//pantalla para actualizar perfil
class EditProfileScreen extends StatefulWidget {
  final String userId; // ID del usuario que se está editando
  final Map<String, dynamic> userData; // Los datos actuales del usuario

  const EditProfileScreen(
      {super.key, required this.userId, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _fnacimientoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Inicializamos los controladores con los datos del usuario
    _usernameController.text = widget.userData['username'] ?? '';
    _emailController.text = widget.userData['email'] ?? '';
    _phoneController.text = widget.userData['telefono'] ?? '';
    _sexoController.text = widget.userData['sexo'] ?? '';
    _fnacimientoController.text = widget.userData['fnacimiento'] ?? '';
  }

  @override
  void dispose() {
    // Dispose of the controllers
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _sexoController.dispose();
    _fnacimientoController.dispose();
    super.dispose();
  }

  Future<void> updateUserData() async {
    // Validar si todos los campos están llenos
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _sexoController.text.isEmpty ||
        _fnacimientoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return; // Detener la ejecución si hay campos vacíos
    }

    try {
      // Buscar el documento por email
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      // Verificar si existe un usuario con ese correo
      if (query.docs.isEmpty) {
        developer
            .log('Usuario no encontrado con email: ${_emailController.text}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Usuario no encontrado en la base de datos')),
          );
        }
        return;
      }

      // Obtener el ID del documento
      String documentId = query.docs.first.id;

      // Actualizar el documento
      await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .update({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'sexo': _sexoController.text.trim(),
        'fnacimiento': _fnacimientoController.text.trim(),
      });

      // Mostrar confirmación y regresar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Información actualizada correctamente')),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context); // Regresar a la pantalla anterior
        }
      }
    } catch (e) {
      // Capturar errores y mostrar mensajes en la interfaz
      developer.log('Error al actualizar los datos: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar los datos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration:
                  const InputDecoration(labelText: 'Correo Electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sexoController,
              decoration: const InputDecoration(labelText: 'Sexo'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fnacimientoController,
              decoration:
                  const InputDecoration(labelText: 'Fecha de Nacimiento'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Guardar Cambios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
