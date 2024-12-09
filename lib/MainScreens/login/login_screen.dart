import 'dart:developer' as developer;
import 'package:cronosalud/MainScreens/login/mainmenuscreen.dart';
import 'package:cronosalud/MainScreens/login/perfilscreen.dart';
import 'package:cronosalud/MainScreens/login/recuperar_password_screen.dart';
import 'package:cronosalud/MainScreens/widgets/widget/signup.dart';
import 'package:cronosalud/MainScreens/widgets/components/buttons/my_back_button.dart';
import 'package:cronosalud/MainScreens/widgets/components/buttons/myloginbutton.dart';
import 'package:cronosalud/MainScreens/widgets/components/container/container_shape01.dart';
import 'package:cronosalud/MainScreens/widgets/components/fields/myfieldform.dart';
import 'package:cronosalud/Utils/logingoogleutils.dart';
import 'package:cronosalud/Utils/textapp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';

//PANTALLA PARA INICAR SESION
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget _usuarioPasswordWidget() {
    return Column(
      children: <Widget>[
        Myfieldform(
          controller: _rutController,
          tittle: TextApp.rut,
          icon: Icons.person, // Añadimos un ícono
        ),
        const SizedBox(height: 15),
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
            child: Divider(thickness: 1, color: Colors.black87),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("O"),
          ),
          Expanded(
            child: Divider(thickness: 1, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                    const SizedBox(height: 30),
                    _usuarioPasswordWidget(),
                    const SizedBox(height: 50),
                    // Botón de inicio de sesión
                    ElevatedButton(
                      onPressed: () async {
                        String rut = _rutController.text.trim();
                        String password = _passwordController.text.trim();

                        if (rut.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor completa todos los campos.',
                              ),
                            ),
                          );
                          return;
                        }
                        await loginUser(rut, password);
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainMenuScreen(userId: rut),
                              // LoginScreen(userId:
                              //   rut), // Asumiendo que `rut` es el identificador del usuario
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.lightBlueAccent, // Color del botón
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Bordes redondeados
                        ),
                      ),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          color: Colors.black, // Color del texto
                          letterSpacing: 1.5,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    MyLoginButton(
                      text: TextApp.signup,
                      colortext: Colors.black,
                      colorbuttonbackground: Colors.lightBlueAccent,
                      widgetToNavigate: SignUp(),
                    ),
                    _forgotpass(context),
                    const SizedBox(height: 10),
                    _divider(),
                    const SizedBox(height: 10),
                    GoogleAuthButton(
                      onPressed: () async {
                        try {
                          // Llama al método para iniciar sesión con Google
                          final user =
                              await LoginGoogleUtils().signInwithGoogle();
                          if (user != null && mounted) {
                            // Accede al UID del usuario para pasarlo a la siguiente pantalla
                            String googleUid = user.uid;
                            // Navega a la pantalla de perfil con el userId
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PerfilScreen(userId: googleUid),
                              ),
                            );
                          } else {
                            // Log para manejo de errores
                            developer.log(
                                "loginScreen-build() ERROR: user viene nulo");
                          }
                        } catch (e) {
                          // Manejo de errores en caso de fallos
                          developer
                              .log("Error al iniciar sesión con Google: $e");
                        }
                      },
                      text: TextApp.googlesign,
                      style: const AuthButtonStyle(
                        buttonType: AuthButtonType.secondary,
                        borderRadius: 10.0,
                        elevation: 5.0,
                      ),
                    ),
                  ],
                ),
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

// Función de inicio de sesión (Login) con RUT
Future<void> loginUser(String rut, String password) async {
  try {
    // Buscar al usuario por su RUT en Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('rut', isEqualTo: rut)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // El RUT existe, obtenemos el email almacenado
      String email = snapshot.docs.first['email'];

      // Intentamos iniciar sesión con Firebase Authentication usando el correo y la contraseña
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Si el login es exitoso, se puede navegar o hacer alguna acción
      developer.log("Usuario logueado: ${userCredential.user!.email}");
    } else {
      developer.log("RUT no encontrado");
      // Mostrar mensaje de error
    }
  } catch (e) {
    developer.log("Error en el inicio de sesión: $e");
  }
}
