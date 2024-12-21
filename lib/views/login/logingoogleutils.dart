import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginGoogleUtils {
  static const String tag = "LoginGoogleUtils";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Método para iniciar sesión con Google
  Future<User?> signInwithGoogle() async {
    try {
      // Inicia el flujo de autenticación con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // Obtiene la autenticación de Google
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        // Crea las credenciales de Google
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Inicia sesión en Firebase con las credenciales
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Verifica el inicio de sesión actual
        return _isCurrentSignIn(userCredential.user);
      } else {
        log("$tag: GoogleAuth es nulo.");
        return null;
      }
    } catch (e) {
      log("$tag: Error en signInwithGoogle: $e");
      return null;
    }
  }

  /// Verifica si el usuario está actualmente autenticado
  Future<User?> _isCurrentSignIn(User? user) async {
    if (user != null) {
      final User? currentUser = _auth.currentUser;
      if (user.uid == currentUser?.uid) {
        log('$tag: signInWithGoogle succeeded: ${user.displayName}');
        return user;
      } else {
        log('$tag: El usuario actual no coincide.');
        return null;
      }
    } else {
      log('$tag: El usuario proporcionado es nulo.');
      return null;
    }
  }

  /// Método para cerrar sesión
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      log('$tag: User signed out from Google.');
    } catch (e) {
      log('$tag: Error al cerrar sesión: $e');
    }
  }
}
