import 'package:cronosalud/controllers/localauth.dart';
import 'package:cronosalud/controllers/loginscreenvalidate.dart';
import 'package:cronosalud/views/login/recuperar_password_screen.dart';
import 'package:cronosalud/widgets/buttons/biometric_button.dart';
import 'package:cronosalud/widgets/buttons/googleauthbutton.dart';
import 'package:cronosalud/views/login/registrar_screen.dart';
import 'package:cronosalud/widgets/buttons/my_back_button.dart';
import 'package:cronosalud/widgets/buttons/my_login_button.dart';
import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:cronosalud/widgets/fields/myfieldform.dart';
import 'package:cronosalud/Utils/textapp.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

//PANTALLA PARA INICAR SESION
class LoginScreen extends StatefulWidget {
  final String? userType;
  const LoginScreen({super.key, this.userType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget usuarioPasswordWidget() {
    return Column(
      children: <Widget>[
        Myfieldform(
          controller: _rutController,
          tittle: TextApp.rut,
          icon: Icons.person, // Añadimos un ícono
        ),
        const SizedBox(height: 10),
        Myfieldform(
          controller: _passwordController,
          tittle: TextApp.password,
          isPassword: true,
          icon: Icons.lock, // Añadimos un ícono
        ),
      ],
    );
  }

  Widget _forgotpass(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          // Navega a la pantalla de recuperación de contraseña
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecuperarPasswordScreen()),
          );
        },
        child: Text(
          TextApp.forgotpass,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(thickness: 2, color: Colors.black),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("O"),
          ),
          Expanded(
            child: Divider(thickness: 2, color: Colors.black),
          ),
        ],
      ),
    );
  }

  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Método para autenticación biométrica
  Future<void> _loginWithBiometrics() async {
    bool isAuthenticated = await LocalAuth.authenticate();
    if (isAuthenticated) {
      developer.log("Inicio de sesión biométrico exitoso");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreenValidate(
              rut:
                  "BiometricUser", // Usuario ficticio o ID para usuarios biométricos
              password: "", // Puede adaptarse según tus necesidades
              userType: "usuario",
            ),
          ),
        );
      }
    } else {
      developer.log("Autenticación biométrica fallida");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticación biométrica fallida'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Imagen de fondo
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/imagen3.jpg'),
                  fit: BoxFit.cover, // La imagen cubre toda la pantalla
                ),
              ),
            ),
            // Contenido principal
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ContainerShape01(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.2),
                      const Text(
                        "Inicia sesión !",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Aquí agregamos el texto que muestra el tipo de usuario
                      Text(
                        "Iniciar sesión como ${widget.userType}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      usuarioPasswordWidget(),
                      const SizedBox(height: 10),
                      // Botón de inicio de sesión
                      MyLoginButton(
                          text: TextApp.iniciosesion,
                          colortext: Colors.black,
                          colorbuttonbackground: Colors.lightBlueAccent,
                          widgetToNavigate:
                              null, // No es necesario especificar aquí la navegación directa
                          onPressed: () async {
                            String rut = _rutController.text.trim();
                            String password = _passwordController.text.trim();
                            // Validar campos vacíos
                            if (rut.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Por favor completa todos los campos.'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }
                            // Navegar a la pantalla LoginScreenValidate
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreenValidate(
                                  rut: rut,
                                  password: password,
                                  userType: widget.userType,
                                ),
                              ),
                            );
                          }),

                      const SizedBox(height: 5),
                      //boton registrarse
                      MyLoginButton(
                        text: TextApp.signup,
                        colortext: Colors.black,
                        colorbuttonbackground: Colors.lightBlueAccent,
                        widgetToNavigate: RegistroScreen(),
                      ),
                      const SizedBox(height: 5),
                      _forgotpass(context),
                      const SizedBox(height: 5),
                      _divider(),
                      const SizedBox(height: 5),
                      GoogleAuthButtonWidget(), // Google Auth Button iniciar sesion con google
                      const SizedBox(height: 20),
                      // Botón para inicio de sesión biométrico
                      BiometricButton(
                        icon: Icons.fingerprint, // Icono de biometría
                        onPressed:
                            _loginWithBiometrics, // Llama al método de autenticación biométrica
                      ),
                    ]),
              ),
            ),
            Positioned(
              top: height * 0.01,
              left: 0.01,
              child: MyBackButton(),
            ),
          ],
        ),
      ),
    );
  }
}
