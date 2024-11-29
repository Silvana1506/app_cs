import 'package:cronosalud/MainScreens/login/login_screen.dart';
import 'package:cronosalud/MainScreens/widgets/components/buttons/myloginbutton.dart';
import 'package:cronosalud/MainScreens/widgets/components/container/container_shape01.dart';
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
              const SizedBox(height: 10),
              // Título principal
              const Text(
                "¡Bienvenido a CronoSalud!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                "Selecciona tu perfil para continuar",
                style: TextStyle(
                  fontSize: 22,
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
                      widgetToNavigate: const LoginScreen(),
                    ),
                    const SizedBox(height: 5),
                    MyLoginButton(
                      text: TextApp.perfilProfesional,
                      colortext: Colors.white,
                      colorbuttonbackground:
                          Colors.lightBlueAccent, // Botón celeste claro
                      widgetToNavigate: const LoginScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
