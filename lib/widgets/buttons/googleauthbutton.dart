import 'package:cronosalud/views/dashboard/menuprincipalusuario.dart';
import 'package:cronosalud/views/login/logingoogleutils.dart';
import 'package:cronosalud/Utils/textapp.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'dart:developer' as developer;

class GoogleAuthButtonWidget extends StatelessWidget {
  const GoogleAuthButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleAuthButton(
      onPressed: () async {
        try {
          // Llama al método para iniciar sesión con Google
          final user = await LoginGoogleUtils().signInwithGoogle();
          if (user != null) {
            final String googleUid = user.uid;
            final String? displayName = user.displayName;
            final String? email = user.email;

            // Log para verificar los datos obtenidos
            developer
                .log("UID: $googleUid, Nombre: $displayName, Email: $email");

            // ignore: use_build_context_synchronously
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MenuUsuarioScreen(
                  userId: googleUid,
                ),
              ),
            );
          } else {
            // Caso de usuario no autenticado
            developer.log("Error: Usuario no autenticado.");
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al iniciar sesión con Google.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          // Manejo de errores
          developer.log("Error al iniciar sesión con Google: $e");
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al iniciar sesión: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      text: TextApp.googlesign,
      style: const AuthButtonStyle(
        buttonType: AuthButtonType.secondary,
        borderRadius: 10.0,
        elevation: 5.0,
      ),
    );
  }
}
