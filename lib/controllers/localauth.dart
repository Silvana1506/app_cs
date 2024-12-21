import 'dart:developer' as developer;
import 'package:local_auth/local_auth.dart';

//metodo de biometria
class LocalAuth {
  static final _auth = LocalAuthentication();

  // Método para verificar si la autenticación biométrica está disponible
  static Future<bool> _canAuth() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      // Verifica si se puede realizar autenticación biométrica
      if (!await _canAuth()) return false;

      // Inicia la autenticación biométrica con un mensaje para el usuario
      return await _auth.authenticate(
          localizedReason: "Necesito tu confirmación de identidad");
    } catch (e) {
      // Registra el error en el log para debugging
      developer.log("Error en autenticación biométrica: $e");
      return false;
    }
  }
}
