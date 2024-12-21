import 'package:cronosalud/Utils/textapp.dart';
import 'package:cronosalud/controllers/perfil_usuario_controlador.dart';
import 'package:cronosalud/models/modelo_usuario.dart';
import 'package:cronosalud/widgets/buttons/my_button_out.dart';
import 'package:cronosalud/views/dashboard/editinfopersonal.dart';
import 'package:cronosalud/widgets/buttons/my_login_button.dart';
import 'package:flutter/material.dart';

class PerfilScreenUsuario extends StatefulWidget {
  final String userId;
  final String? email;
  final String? userType;

  const PerfilScreenUsuario({
    super.key,
    required this.userId,
    this.email,
    this.userType,
  });

  @override
  State<PerfilScreenUsuario> createState() => _PerfilScreenUsuarioState();
}

class _PerfilScreenUsuarioState extends State<PerfilScreenUsuario> {
  final PerfilController _controller = PerfilController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder<Users?>(
        future: _controller.fetchUserData(widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
                child: Text('No se encontraron datos del usuario'));
          } else {
            final userData = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Encabezado del perfil
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/images/profile_placeholder.png',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userData.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            widget.email ?? 'Correo no especificado',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Información del usuario
                    _buildUserInfoTile('Apellido Paterno', userData.apaterno),
                    _buildUserInfoTile('Apellido Materno', userData.amaterno),
                    _buildUserInfoTile('Teléfono', userData.phone),
                    _buildUserInfoTile('Sexo', userData.sexo),
                    _buildUserInfoTile(
                        'Fecha de Nacimiento', userData.fnacimiento),
                    const SizedBox(height: 5),
                    // Botón para editar información
                    MyLoginButton(
                      text: TextApp.editarperfil,
                      colortext: Colors.black,
                      colorbuttonbackground: Colors.lightBlueAccent,
                      widgetToNavigate: null,
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              userId: widget.userId,
                              userData: userData,
                              userType: widget.userType,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    // Botón para cerrar sesión
                    LogoutButton(
                      onLogout: () {},
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserInfoTile(String title, String value) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.info, color: Colors.lightBlueAccent),
        title: Text(
          '$title: $value',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
