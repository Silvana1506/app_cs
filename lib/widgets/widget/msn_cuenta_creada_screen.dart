import 'package:cronosalud/views/login/welcome_screen.dart';
import 'package:cronosalud/widgets/buttons/my_login_button.dart';
import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:cronosalud/Utils/textapp.dart';
import 'package:flutter/material.dart';

// pantalla confirmacion de cuenta creada
class MsnCuentaCreada extends StatefulWidget {
  final String? userType;

  const MsnCuentaCreada({super.key, this.userType});
  @override
  State<MsnCuentaCreada> createState() => _MsnCuentaCreadaState();
}

class _MsnCuentaCreadaState extends State<MsnCuentaCreada> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          color: Colors.white, // Fondo blanco
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Fondo decorativo
              const ContainerShape01(),
              const SizedBox(height: 30),
              // Título del mensaje
              const Text(
                "¡Cuenta creada exitosamente!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Tu cuenta se ha registrado correctamente. Ahora puedes iniciar sesión.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 81, 81, 81),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              // Botón para iniciar sesión
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: MyLoginButton(
                  text: TextApp.iniciosesion,
                  colortext: Colors.black,
                  colorbuttonbackground:
                      Colors.lightBlueAccent, // Botón celeste
                  widgetToNavigate: WelcomeScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
