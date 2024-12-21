import 'package:cronosalud/models/recuperar_password_models.dart';

class AuthController {
  final AuthModel _authModel = AuthModel();

  // Manejar el envío de correo de recuperación
  Future<void> handlePasswordResetRequest(String email) async {
    await _authModel.sendPasswordResetEmail(email);
  }

  // Manejar la confirmación de la nueva contraseña
  Future<void> handlePasswordReset(String oobCode, String newPassword) async {
    await _authModel.resetPassword(oobCode, newPassword);
  }
}
