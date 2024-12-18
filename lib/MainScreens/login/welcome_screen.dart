import 'package:app_cs/MainScreens/login/login_screen.dart';
import 'package:app_cs/MainScreens/widgets/components/buttons/myloginbutton.dart';
import 'package:app_cs/MainScreens/widgets/components/container/container_shape01.dart';
import 'package:app_cs/MainScreens/widgets/design_widgets.dart';
import 'package:app_cs/Utils/textapp.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

Widget _perfilButton2(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 25.0, bottom: 25),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen())),
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        backgroundColor: Colors.lightBlueAccent,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
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
                color: Colors.white,
                //gradient: Designwidgets.linearGradientMain(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContainerShape01(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Designwidgets.titleCustom(),
                  ),
                  MyLoginButton(
                    text: TextApp.usuario,
                    colortext: Colors.black,
                    colorbuttonbackground: Colors.lightBlueAccent,
                    widgetToNavigate: LoginScreen(),
                  ),
                  _perfilButton2(context)
                ],
              )),
        ),
      ),
    );
  }
}
