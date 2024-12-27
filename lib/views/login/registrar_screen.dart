import 'package:cronosalud/controllers/registro_controlador.dart';
import 'package:cronosalud/models/modelo_usuario.dart';
import 'package:cronosalud/widgets/widget/msn_cuenta_creada_screen.dart';
import 'package:cronosalud/widgets/buttons/my_login_button.dart';
import 'package:cronosalud/widgets/fields/myfieldform.dart';
import 'package:flutter/material.dart';
import 'package:cronosalud/widgets/buttons/my_back_button.dart';
import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:cronosalud/Utils/textapp.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final RegistroController _controller = RegistroController();

  // Controladores para los campos del formulario
  final _nameController = TextEditingController();
  final _apaternoController = TextEditingController();
  final _amaternoController = TextEditingController();
  final _rutController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sexoController = TextEditingController();
  final _fnacimientoController = TextEditingController();
  final _userTypeController = TextEditingController();

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState?.validate() ?? false) {
      final users = Users(
        id: '',
        name: _nameController.text.trim(),
        apaterno: _apaternoController.text.trim(),
        amaterno: _amaternoController.text.trim(),
        rut: _rutController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        sexo: _sexoController.text.trim(),
        fnacimiento: _fnacimientoController.text.trim(),
        userType: _userTypeController.text.trim(),
      );

      try {
        await _controller.registrarUsuario(users);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MsnCuentaCreada(),
            ), // Asegúrate de tener la pantalla MsnCuentaCreada implementada
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
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
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Completa los campos para registrarte",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 3),
                      // Formulario de entrada
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: _usuarioPasswordWidget(),
                      ),
                      const SizedBox(height: 3),
                      // Botón de registro
                      MyLoginButton(
                        text: TextApp.signup,
                        colortext: Colors.black,
                        colorbuttonbackground: Colors.lightBlueAccent,
                        widgetToNavigate:
                            null, // No es necesario especificar aquí la navegación directa
                        onPressed: _registrarUsuario,
                        // Aquí envuelves la llamada a la función asincrónica
                      ),
                      const SizedBox(height: 3),
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

  Widget _usuarioPasswordWidget() {
    return Column(
      children: <Widget>[
        Myfieldform(
          tittle: TextApp.name,
          controller: _nameController,
          validator: null,
        ),
        const SizedBox(height: 3),
        Myfieldform(
          tittle: TextApp.apaterno,
          controller: _apaternoController,
          validator: null,
        ),
        const SizedBox(height: 3),
        Myfieldform(
          tittle: TextApp.amaterno,
          controller: _amaternoController,
          validator: null,
        ),
        const SizedBox(height: 3),
        Myfieldform(
          tittle: TextApp.rut,
          controller: _rutController,
          validator: null,
        ),
        const SizedBox(height: 3),
        Myfieldform(
          tittle: TextApp.password,
          isPassword: true,
          controller: _passwordController,
          validator: null,
        ),
        const SizedBox(height: 3),
        Myfieldform(
          tittle: TextApp.email,
          controller: _emailController,
          validator: null,
        ),
        const SizedBox(height: 3),
        Myfieldform(
          tittle: TextApp.phone,
          controller: _phoneController,
          validator: null,
        ),
        const SizedBox(height: 3),
        Myfieldform(
          tittle: TextApp.sexo,
          controller: _sexoController,
          validator: null,
        ),
        const SizedBox(height: 3),
        Myfieldform(
          tittle: TextApp.fnacimiento,
          controller: _fnacimientoController,
          validator: null,
        ),
        const SizedBox(height: 3),
        Myfieldform(
          tittle: "Tipo de usuario",
          controller: _userTypeController,
          validator: (value) => value?.isEmpty ?? true
              ? 'El tipo de usuario es obligatorio'
              : null,
        ),
      ],
    );
  }
}
