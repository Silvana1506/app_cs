import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/views/dashboard/menuprincipalprofesional.dart';
import 'package:cronosalud/views/dashboard/menuprincipalusuario.dart';
import 'package:cronosalud/views/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class LoginScreenValidate extends StatefulWidget {
  final String rut;
  final String password;
  final String? userType;

  const LoginScreenValidate({
    super.key,
    required this.rut,
    required this.password,
    this.userType,
  });

  @override
  State<LoginScreenValidate> createState() => _LoginScreenValidateState();
}

class _LoginScreenValidateState extends State<LoginScreenValidate> {
  String? userId;
  @override
  void initState() {
    super.initState();
    _loginUser();
  }

  // Validar usuario por RUT y contraseña
  Future<void> _loginUser() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('rut', isEqualTo: widget.rut)
          .get();

      if (snapshot.docs.isEmpty) {
        _mostrarMensajeYRedirigir('RUT no registrado');
        return;
      }

      var userData = snapshot.docs.first.data() as Map<String, dynamic>;
      userId = snapshot.docs.first.id; // Obtiene el ID del documento

      developer.log("Datos del usuario encontrados: $userData");

      if (widget.password == userData['password']) {
        // Verifica que el tipo de usuario en la base de datos sea el mismo que el proporcionado
        if (userData['userType'] != widget.userType) {
          _mostrarMensajeYRedirigir('Tipo de usuario no coincide');
          return;
        }

        await _login(userData['email'], widget.password);
        userId = snapshot.docs.first
            .id; // Usamos el ID del documento en lugar de `userData['id']`

        if (userId == null || userId!.isEmpty) {
          _mostrarMensajeYRedirigir('No se pudo obtener el ID del usuario');
        }
      } else {
        _mostrarMensajeYRedirigir('Clave incorrecta');
      }
    } catch (e) {
      developer.log("Error al validar la información: $e");
      _mostrarMensajeYRedirigir('Ocurrió un error');
    }
  }

  Future<void> _login(String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null && context.mounted) {
        redirigirSegunTipoUsuario(); // Redirigir según el tipo de usuario
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')),
        );
      }
    }
  }

  // Redirigir al menú correspondiente según el tipo de usuario
  void redirigirSegunTipoUsuario() {
    if (mounted) {
      if (widget.userType == "usuario") {
        if (userId != null && userId!.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MenuUsuarioScreen(userId: userId!),
            ),
          );
        } else {
          _mostrarMensajeYRedirigir('No se pudo obtener el ID del usuario');
        }
      } else if (widget.userType == "profesional") {
        if (userId != null && userId!.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MenuProfesionalScreen(userId: userId!),
            ),
          );
        } else {
          _mostrarMensajeYRedirigir('No se pudo obtener el ID del profesional');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de usuario no reconocido')),
        );
      }
    }
  }

  void _mostrarMensajeYRedirigir(String mensaje) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Indicador de carga mientras validamos
      ),
    );
  }
}
