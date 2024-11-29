import 'package:cronosalud/MainScreens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String oobCode; // El código del enlace de restablecimiento

  const ResetPasswordScreen({super.key, required this.oobCode});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordMatch = true;

  void _resetPassword() async {
    final String newPassword = _newPasswordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    // Verificar que las contraseñas coincidan
    if (newPassword != confirmPassword) {
      setState(() {
        _passwordMatch = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.oobCode,
        newPassword: newPassword,
      );
      if (mounted) {
        // Si el reset fue exitoso, navega al inicio de sesión o muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña restablecida con éxito'),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (mounted) {
        // Redirige al usuario a la pantalla de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restablecer Contraseña'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Introduce una nueva contraseña:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            if (!_passwordMatch)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Las contraseñas no coinciden',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Restablecer Contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}

void handlePasswordResetLink(BuildContext context) {
  final String? oobCode = Uri.base.queryParameters['oobCode'];
  if (oobCode != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(oobCode: oobCode),
      ),
    );
  } else {
    // Muestra un mensaje de error si no se encuentra el código
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código inválido o inexistente'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
