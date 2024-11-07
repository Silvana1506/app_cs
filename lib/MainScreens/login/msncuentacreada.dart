import 'package:app_cs/MainScreens/login/login_screen.dart';
import 'package:app_cs/MainScreens/widgets/components/buttons/myloginbutton.dart';
import 'package:app_cs/MainScreens/widgets/components/container/container_shape01.dart';
import 'package:app_cs/MainScreens/widgets/design_widgets.dart';
import 'package:app_cs/Utils/textapp.dart';
import 'package:flutter/material.dart';

class MsnCuentaCreada extends StatefulWidget {
  const MsnCuentaCreada({super.key});

  @override
  State<MsnCuentaCreada> createState() => _MsnCuentaCreadaState();
}

class _MsnCuentaCreadaState extends State<MsnCuentaCreada> {
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
                    child: Designwidgets.titleCustomCrear2(),
                  ),
                  MyLoginButton(
                    text: TextApp.iniciosesion,
                    colortext: Colors.black,
                    colorbuttonbackground: Colors.lightBlueAccent,
                    widgetToNavigate: LoginScreen(),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
