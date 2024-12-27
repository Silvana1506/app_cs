import 'package:cronosalud/views/login/login_screen.dart';
import 'package:cronosalud/widgets/buttons/my_login_button.dart';
import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:cronosalud/Utils/textapp.dart';
import 'package:flutter/material.dart';

//pantalla para elegir perfil usuario o profesional de salud
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/imagen1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          //color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Fondo decorativo en la parte superior
                const ContainerShape01(),
                const SizedBox(height: 20),
                // Título principal
                const Text(
                  "¡Bienvenido a CronoSalud!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Selecciona tu perfil para continuar",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Botones
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      MyLoginButton(
                          text: TextApp.usuario,
                          colortext: Colors.white,
                          colorbuttonbackground:
                              Colors.lightBlueAccent, // Botón celeste claro
                          widgetToNavigate: null, // Botón celeste claro
                          onPressed: () {
                            // Tipo de perfil asignado a "profesional"
                            String userType = "usuario";
                            // Navegar a LoginScreen y pasar el parámetro tipoPerfil
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen(userType: userType),
                              ),
                            );
                          }),
                      const SizedBox(height: 5),
                      MyLoginButton(
                          text: TextApp.perfilProfesional,
                          colortext: Colors.white,
                          colorbuttonbackground: Colors.lightBlueAccent,
                          widgetToNavigate: null, // Botón celeste claro
                          onPressed: () {
                            // Tipo de perfil asignado a "profesional"
                            String userType = "profesional";
                            // Navegar a LoginScreen y pasar el parámetro tipoPerfil
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                  userType:
                                      userType, // Pasar el tipo de perfil como parámetro
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
