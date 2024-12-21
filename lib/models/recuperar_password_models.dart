import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Enviar correo de recuperación
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Confirmar restablecimiento de contraseña
  Future<void> resetPassword(String oobCode, String newPassword) async {
    await _auth.confirmPasswordReset(
      code: oobCode,
      newPassword: newPassword,
    );
  }
}
