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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _apaternoController = TextEditingController();
  final TextEditingController _amaternoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _fnacimientoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Inicializamos los controladores con los datos del usuario
    _nameController.text = widget.userData['name'] ?? '';
    _apaternoController.text = widget.userData['apaterno'] ?? '';
    _amaternoController.text = widget.userData['amaterno'] ?? '';
    _emailController.text = widget.userData['email'] ?? '';
    _phoneController.text = widget.userData['telefono'] ?? '';
    _sexoController.text = widget.userData['sexo'] ?? '';
    _fnacimientoController.text = widget.userData['fnacimiento'] ?? '';
  }

  @override
  void dispose() {
    // Dispose of the controllers
    _nameController.dispose();
    _apaternoController.dispose();
    _amaternoController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _sexoController.dispose();
    _fnacimientoController.dispose();
    super.dispose();
  }

  Future<void> updateUserData() async {
    // Validar si todos los campos están llenos
    if (_nameController.text.isEmpty ||
        _apaternoController.text.isEmpty ||
        _amaternoController.text.isEmpty ||
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
        'name': _nameController.text.trim(),
        'apaterno': _apaternoController.text.trim(),
        'amaterno': _amaternoController.text.trim(),
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
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado para Información Personal
            const Text(
              'Información Personal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      labelText: 'Nombre',
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: _apaternoController,
                      labelText: 'Apellido Paterno',
                      icon: Icons.badge,
                    ),
                    _buildTextField(
                      controller: _amaternoController,
                      labelText: 'Apellido Materno',
                      icon: Icons.badge_outlined,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Encabezado para Contacto
            const Text(
              'Contacto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      labelText: 'Correo Electrónico',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      controller: _phoneController,
                      labelText: 'Teléfono',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextField(
                      controller: _sexoController,
                      labelText: 'Sexo',
                      icon: Icons.wc,
                    ),
                    _buildTextField(
                      controller: _fnacimientoController,
                      labelText: 'Fecha de Nacimiento',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.datetime,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Botón para guardar
            Center(
              child: ElevatedButton(
                onPressed: updateUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Guardar Cambios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Método para construir campos de texto personalizados
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
