import 'package:cronosalud/views/login/logingoogleutils.dart';
import 'package:cronosalud/views/login/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Widget para el botón de cerrar sesión
class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout; // Función a ejecutar al cerrar sesión

  const LogoutButton({
    super.key,
    required this.onLogout,
  });

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Cierra sesión en Firebase
      // Cierra sesión con Google usando LoginGoogleUtils
      final loginUtils = LoginGoogleUtils();
      await loginUtils.signOutGoogle();

      if (!context.mounted) return;
      // Redirigir a la pantalla de login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (route) => false, // Elimina todas las rutas anteriores
      );
    } catch (e) {
      // Mostrar error al cerrar sesión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cerrar sesión: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => logout(context),
      icon: const Icon(Icons.logout, color: Colors.black), // Ícono en negro
      label: const Text(
        'Cerrar Sesión',
        style: TextStyle(
          fontSize: 18, // Ajustar tamaño de texto
          fontWeight: FontWeight.w600, // Peso del texto
          color: Colors.black, // Texto en negro
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        alignment: Alignment.center, // Alinear contenido al centro
      ),
    );
  }
}
