import 'package:app_cs/MainScreens/login/msncuentacreada.dart';
import 'package:app_cs/MainScreens/widgets/components/buttons/my_back_button.dart';
import 'package:app_cs/MainScreens/widgets/components/buttons/myloginbutton.dart';
import 'package:app_cs/MainScreens/widgets/components/container/container_shape01.dart';
import 'package:app_cs/MainScreens/widgets/components/fields/myfieldform.dart';
import 'package:app_cs/MainScreens/widgets/design_widgets.dart';
import 'package:app_cs/Utils/textapp.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  Widget _usuarioPasswordWidget() {
    return Column(
      children: <Widget>[
        Myfieldform(tittle: TextApp.username),
        Myfieldform(tittle: TextApp.rut),
        Myfieldform(tittle: TextApp.password, isPassword: true),
        Myfieldform(tittle: TextApp.email),
        Myfieldform(tittle: TextApp.phone),
        Myfieldform(tittle: TextApp.sexo),
        Myfieldform(tittle: TextApp.fnacimiento),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          ContainerShape01(),
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height * .10),
                    child: Designwidgets.titleCustomCrear(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * .05),
                    child: _usuarioPasswordWidget(),
                  ),
                  MyLoginButton(
                    text: TextApp.crearcuenta,
                    colortext: Colors.black,
                    colorbuttonbackground: Colors.lightBlueAccent,
                    widgetToNavigate: MsnCuentaCreada(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: height * .015, child: MyBackButton()),
        ]),
      ),
    );
  }
}
