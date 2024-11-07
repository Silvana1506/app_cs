import 'package:app_cs/MainScreens/login/signup.dart';
import 'package:app_cs/MainScreens/my_home_page.dart';
import 'package:app_cs/MainScreens/widgets/components/buttons/my_back_button.dart';
import 'package:app_cs/MainScreens/widgets/components/buttons/myloginbutton.dart';
import 'package:app_cs/MainScreens/widgets/components/container/container_shape01.dart';
import 'package:app_cs/MainScreens/widgets/components/fields/myfieldform.dart';
import 'package:app_cs/MainScreens/widgets/design_widgets.dart';
import 'package:app_cs/Utils/textapp.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';

//PANTALLA QUE ENVIA AL INICAR SESION
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  Widget _usuarioPasswordWidget() {
    return Column(
      children: <Widget>[
        Myfieldform(
          tittle: TextApp.usuario,
        ),
        Myfieldform(
          tittle: TextApp.password,
          isPassword: true,
        ),
      ],
    );
  }

  Widget _forgotpass() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      child: Text(TextApp.forgotpass,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(TextApp.or),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpLabel() {
    return TextButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUp())),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //no tienes cuenta google
          Text(
            TextApp.donthaveaccount,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              TextApp.signup,
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
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
                    padding: EdgeInsets.only(top: height * .15),
                    child: Designwidgets.titleCustomDark(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * .05),
                    child: _usuarioPasswordWidget(),
                  ),
                  MyLoginButton(
                    text: TextApp.iniciosesion,
                    colortext: Colors.black,
                    colorbuttonbackground: Colors.lightBlueAccent,
                    widgetToNavigate: MyHomePage(),
                  ),
                  MyLoginButton(
                    text: TextApp.crearcuenta,
                    colortext: Colors.black,
                    colorbuttonbackground: Colors.lightBlueAccent,
                    widgetToNavigate: SignUp(),
                  ),
                  _forgotpass(),
                  _divider(),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: GoogleAuthButton(
                      onPressed: () async {},
                      themeMode:
                          ThemeMode.dark, // Activa modo oscuro si es necesario
                      text: TextApp.googlesign,
                      style: AuthButtonStyle(
                        buttonType: AuthButtonType.secondary, // Tipo de botón
                        borderRadius: 30.0, // Radio de los bordes
                        //padding: EdgeInsets.symmetric(vertical: 12), // Espaciado vertical
                      ),
                    ),
                  ),
                  _signUpLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: height * .015, child: MyBackButton()),
        ],
      ),
    ));
  }
}
