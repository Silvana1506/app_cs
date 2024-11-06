import 'package:app_cs/MainScreens/widgets/design_widgets.dart';
import 'package:app_cs/Utils/textapp.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

Widget _perfilButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 100.0, bottom: 5),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => print('Botón Perfil Paciente pulsado'),
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        backgroundColor: const Color.fromARGB(255, 25, 207, 244),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ), // Color de fondo
      ),
      child: Text(
        TextApp.perfilPaciente,
        style: TextStyle(
          color: Colors.black,
          letterSpacing: 1.5,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _perfilButton2(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 25.0, bottom: 25),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => print('Botón Perfil Profesional de Salud pulsado'),
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        backgroundColor: const Color.fromARGB(255, 25, 207, 244),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ), // Color de fondo
      ),
      child: Text(
        TextApp.perfilProfesional,
        style: TextStyle(
          color: Colors.black,
          letterSpacing: 1.5,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: Designwidgets.linearGradientMain(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Designwidgets.titleCustom(),
                  _perfilButton(context),
                  _perfilButton2(context)
                ],
              )),
        ),
      ),
    );
  }
}
