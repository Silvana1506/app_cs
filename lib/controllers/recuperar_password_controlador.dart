import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Envía un enlace de restablecimiento de contraseña al correo
  Future<void> handlePasswordResetRequest(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('No se pudo enviar el enlace: ${e.toString()}');
    }
  }

  // Restablece la contraseña usando el código recibido
  Future<void> handlePasswordReset(String oobCode, String newPassword) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
        code: oobCode,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception('Error al restablecer la contraseña: ${e.toString()}');
    }
  }
}
