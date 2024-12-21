import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/modelo_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistroController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Validar los campos del formulario
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
    if (phone.isEmpty) return 'El teléfono es obligatorio';
    if (sexo.isEmpty) return 'El sexo es obligatorio';
    if (fnacimiento.isEmpty) return 'La fecha de nacimiento es obligatoria';
    if (userType.isEmpty) return 'El tipo de usuario es obligatoria';
    return null;
  }

  // Registrar usuario
  Future<void> registrarUsuario(Users users) async {
    try {
      // Check if the email is already in use
      // ignore: deprecated_member_use
      var result = await _auth.fetchSignInMethodsForEmail(users.email);
      if (result.isNotEmpty) {
        throw Exception('El correo electrónico ya está en uso.');
      }

      // If email is not already in use, create a new user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: users.email,
        password: users.password,
      );
      // Guardar información en Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(users.toJson());
    } on FirebaseAuthException catch (e) {
      // Handle reCAPTCHA failure specifically
      if (e.code == 'network-request-failed') {
        throw Exception('Error de red, intenta nuevamente.');
      } else if (e.code == 'too-many-requests') {
        throw Exception('Demasiados intentos, por favor espera un momento.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('El correo electrónico ya está en uso.');
      } else {
        throw Exception('Error al registrar usuario: ${e.message}');
      }
    }
  }
}
