import 'package:cronosalud/MainScreens/widgets/widget/msncuentacreada.dart';
import 'package:cronosalud/MainScreens/widgets/components/buttons/my_back_button.dart';
import 'package:cronosalud/MainScreens/widgets/components/buttons/myloginbuttonvalidacion.dart';
import 'package:cronosalud/MainScreens/widgets/components/container/container_shape01.dart';
import 'package:cronosalud/MainScreens/widgets/components/fields/myfieldform.dart';
import 'package:cronosalud/Utils/textapp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//pantalla para crear usuario
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  // Define el GlobalKey para el Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _apaternoController = TextEditingController();
  final TextEditingController _amaternoController = TextEditingController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _fnacimientoController = TextEditingController();

  Widget _usuarioPasswordWidget() {
    return Column(
      children: <Widget>[
        Myfieldform(
          tittle: TextApp.name,
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El nombre es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        Myfieldform(
          tittle: TextApp.apaterno,
          controller: _apaternoController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El Apellido Paterno es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        Myfieldform(
          tittle: TextApp.amaterno,
          controller: _amaternoController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El Apellido Materno es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        Myfieldform(
          tittle: TextApp.rut,
          controller: _rutController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El RUT es requerido';
            }
            if (!RegExp(r'^\d{1,2}\.\d{3}\.\d{3}-[0-9kK]$').hasMatch(value)) {
              return 'Ingrese un RUT válido (formato: 12.345.678-9)';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        Myfieldform(
          tittle: TextApp.password,
          isPassword: true,
          controller: _passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La contraseña es requerida';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        Myfieldform(
          tittle: TextApp.email,
          controller: _emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El correo es requerido';
            } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
              return 'Ingrese un correo válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        Myfieldform(
          tittle: TextApp.phone,
          controller: _phoneController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El teléfono es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        Myfieldform(
          tittle: TextApp.sexo,
          controller: _sexoController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El sexo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        Myfieldform(
          tittle: TextApp.fnacimiento,
          controller: _fnacimientoController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La fecha de nacimiento es requerida';
            }
            return null;
          },
        ),
      ],
    );
  }

// Función de registro (SignUp)
  Future<void> _submitForm(String email, String password, String rut) async {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Crear el usuario en Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        String userId =
            userCredential.user!.uid; // Obtener el UID del usuario creado
        // Guardar información adicional del usuario en Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'nombre': _nameController.text.trim(),
          'apaterno': _apaternoController.text.trim(),
          'amaterno': _amaternoController.text.trim(),
          'rut': _rutController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'sexo': _sexoController.text.trim(),
          'fnacimiento': _fnacimientoController.text.trim(),
        });

        if (mounted) {
          Navigator.of(context).pop(); // Cerrar el indicador de carga
          // Navegar a la pantalla de cuenta creada
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MsnCuentaCreada()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.of(context).pop(); // Cerrar el indicador de carga
        }

        String errorMessage = 'Ocurrió un error';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'El correo ya está registrado';
        } else if (e.code == 'weak-password') {
          errorMessage = 'La contraseña es demasiado débil';
        }

        if (mounted) {
          // Mostrar un mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Mostrar un mensaje de error inesperado
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error inesperado: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
                  image: AssetImage('assets/images/imagen4.jpg'),
                  fit: BoxFit.cover, // La imagen cubre toda la pantalla
                ),
              ),
            ),
            // Fondo decorativo en la parte superior
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ContainerShape01(),
            ),
            // Contenido principal
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey, // Asocia el formulario con el GlobalKey
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.15),
                      Text(
                        "Crea tu cuenta !",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Completa los campos para registrarte",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      // Formulario de entrada
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: _usuarioPasswordWidget(),
                      ),
                      const SizedBox(height: 5),
                      // Botón de registro
                      MyLoginButtonValidacion(
                        text: TextApp.signup,
                        colortext: Colors.black,
                        colorbuttonbackground: Colors.lightBlueAccent,
                        onPressed: () async {
                          // Aquí envuelves la llamada a la función asincrónica
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          String rut = _rutController.text.trim();
                          await _submitForm(email, password, rut);
                        },
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
            // Botón de retroceso
            Positioned(
              top: height * 0.02,
              left: 0.01,
              child: MyBackButton(),
            ),
          ],
        ),
      ),
    );
  }
}
