import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/modelo_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class RegistroController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  /// Validar los campos del formulario
  String? validarCampos({
    required String name,
    required String apaterno,
    required String amaterno,
    required String rut,
    required String email,
    required String password,
    required String phone,
    required String sexo,
    required String fnacimiento,
    required String userType,
  }) {
    if (name.isEmpty) return 'El nombre es obligatorio';
    if (apaterno.isEmpty) return 'El apellido paterno es obligatorio';
    if (amaterno.isEmpty) return 'El apellido materno es obligatorio';
    if (rut.isEmpty ||
        !RegExp(r'^\d{1,2}\.\d{3}\.\d{3}-[0-9kK]$').hasMatch(rut)) {
      return 'El RUT no es válido';
    }
    if (email.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      return 'El correo no es válido';
    }
    if (password.isEmpty || password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    if (phone.isEmpty || !RegExp(r'^\d+$').hasMatch(phone)) {
      return 'El teléfono debe contener solo números';
    }
    if (sexo.isEmpty) return 'El sexo es obligatorio';
    if (fnacimiento.isEmpty ||
        !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(fnacimiento)) {
      return 'La fecha de nacimiento debe tener el formato AAAA-MM-DD';
    }
    if (userType.isEmpty) return 'El tipo de usuario es obligatorio';
    return null;
  }

  /// Registrar usuario en Firebase Authentication y Firestore
  Future<void> registrarUsuario(Users users) async {
    try {
      // Intentar registrar al usuario
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: users.email,
        password: users.password,
      );
      // Obtener UID generado por Firebase Auth
      String userId = userCredential.user!.uid;

      // Guardar información adicional del usuario en Firestore
      await _firestore.collection('users').doc(userId).set(users.toFirestore());

      _logger.i('Usuario registrado con éxito: ${users.email}');
    } on FirebaseAuthException catch (e) {
      // Manejo de errores comunes
      String mensajeError;
      switch (e.code) {
        case 'network-request-failed':
          mensajeError = 'Error de red, intenta nuevamente.';
          break;
        case 'too-many-requests':
          mensajeError = 'Demasiados intentos, por favor espera un momento.';
          break;
        case 'email-already-in-use':
          mensajeError = 'El correo electrónico ya está en uso.';
          break;
        default:
          mensajeError = 'Error al registrar usuario: ${e.message}';
      }
      _logger.e(mensajeError);
      throw Exception(mensajeError);
    } catch (e) {
      // Manejo de cualquier otro error
      String mensajeError = 'Error inesperado: ${e.toString()}';
      _logger.e(mensajeError);
      throw Exception(mensajeError);
    }
  }
}
