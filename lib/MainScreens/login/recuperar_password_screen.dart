import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecuperarPasswordScreen extends StatelessWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // Fondo blanco
        appBar: AppBar(
          title: const Text(
            'Recuperar Contraseña',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Introduce tu correo electrónico para recibir un enlace de recuperación:',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              // Campo de texto para el correo
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon:
                      const Icon(Icons.email, color: Colors.lightBlueAccent),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Botón para enviar enlace de recuperación
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, introduce un correo válido.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    _sendPasswordResetEmail(context, email);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Enviar enlace de recuperación',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Verificar si el widget aún está montado antes de usar el context
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se ha enviado un enlace de recuperación a tu correo.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Verificar si el widget aún está montado antes de usar el context
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar el correo: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
