import 'package:cronosalud/Utils/textapp.dart';
import 'package:cronosalud/controllers/perfil_usuario_controlador.dart';
import 'package:cronosalud/models/modelo_usuario.dart';
import 'package:cronosalud/widgets/buttons/my_login_button.dart';
import 'package:cronosalud/widgets/fields/myfieldform.dart';
import 'package:flutter/material.dart';

//pantalla para actualizar perfil
class EditProfileScreen extends StatefulWidget {
  final String userId;
  final Users userData;
  final String? userType;
  //final Map<String, dynamic> userData;

  const EditProfileScreen(
      {super.key, required this.userId, required this.userData, this.userType});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final PerfilController _controller = PerfilController();
  late TextEditingController _nameController;
  late TextEditingController _apaternoController;
  late TextEditingController _amaternoController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _sexoController;
  late TextEditingController _fnacimientoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData.name);
    _apaternoController = TextEditingController(text: widget.userData.apaterno);
    _amaternoController = TextEditingController(text: widget.userData.amaterno);
    _emailController = TextEditingController(text: widget.userData.email);
    _phoneController = TextEditingController(text: widget.userData.phone);
    _sexoController = TextEditingController(text: widget.userData.sexo);
    _fnacimientoController =
        TextEditingController(text: widget.userData.fnacimiento);
  }

  Future<void> _savePerfil() async {
    final updatedUser = widget.userData.copyWith(
      name: _nameController.text.trim(),
      apaterno: _apaternoController.text.trim(),
      amaterno: _amaternoController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      sexo: _sexoController.text.trim(),
      fnacimiento: _fnacimientoController.text.trim(),
    );

    try {
      // Actualizar los datos en la base de datos
      await _controller.updateUserData(updatedUser);
      // Regresar a la pantalla anterior con los datos actualizados
      if (mounted) {
        Navigator.pop(context, updatedUser); // Regresa a la pantalla anterior
      }
    } catch (e) {
      // Mostrar mensaje de error si algo falla
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar el perfil: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        title: const Text(
          'Edita tu Perfil',
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
                    Myfieldform(
                      tittle: TextApp.name,
                      controller: _nameController,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    Myfieldform(
                      tittle: TextApp.apaterno,
                      controller: _apaternoController,
                      icon: Icons.badge,
                    ),
                    const SizedBox(height: 10),
                    Myfieldform(
                      tittle: TextApp.amaterno,
                      controller: _amaternoController,
                      icon: Icons.badge_outlined,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Encabezado para Contacto
            const Text(
              'Información de Contacto',
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
                    Myfieldform(
                      tittle: TextApp.email,
                      controller: _emailController,
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    Myfieldform(
                      tittle: TextApp.phone,
                      controller: _phoneController,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    Myfieldform(
                      tittle: TextApp.sexo,
                      controller: _sexoController,
                      icon: Icons.wc,
                    ),
                    const SizedBox(height: 10),
                    Myfieldform(
                      tittle: TextApp.fnacimiento,
                      controller: _fnacimientoController,
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.datetime,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botón para guardar
            Center(
              child: MyLoginButton(
                text: 'Actualizar', // Texto del botón
                colortext: Colors.black, // Color del texto
                colorbuttonbackground: Colors.lightBlueAccent, // Color de fondo
                onPressed: _savePerfil, // Acción al presionar el botón
              ),
            ),
          ],
        ),
      ),
    );
  }
}
