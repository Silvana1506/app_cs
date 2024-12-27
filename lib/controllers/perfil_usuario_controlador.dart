import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/modelo_usuario.dart';
import 'dart:developer' as developer;

class PerfilController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Recuperar usuario por email
  Future<Users?> fetchUserDataByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Users.fromFirestore(querySnapshot.docs.first);
      } else {
        developer.log('No se encontró el usuario con el correo: $email');
        return null;
      }
    } catch (e) {
      developer.log('Error al obtener los datos del usuario: $e');
      return null;
    }
  }

  // Recuperar usuario por ID
  Future<Users?> fetchUserDataById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return Users.fromFirestore(doc);
      } else {
        developer.log('No se encontró el usuario con ID: $userId');
        return null;
      }
    } catch (e) {
      developer.log('Error al obtener los datos del usuario: $e');
      return null;
    }
  }

// guardar los datos del usuario
  Future<void> saveUserData(Users user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toFirestore());
      developer.log('Datos del usuario guardados exitosamente.');
    } catch (e) {
      developer.log('Error al guardar los datos del usuario: $e');
    }
  }

  // Método para actualizar los datos del usuario en Firestore
  Future<void> updateUserData(Users updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedUser.id)
          .update(updatedUser.toFirestore());
      developer.log('Usuario actualizado con éxito: ${updatedUser.email}');
    } catch (e) {
      // Manejo de errores
      String mensajeError =
          'Error al actualizar los datos del usuario: ${e.toString()}';
      developer.log(mensajeError);
      throw Exception(mensajeError);
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      developer.log('Usuario eliminado exitosamente.');
    } catch (e) {
      developer.log('Error al eliminar el usuario: $e');
    }
  }
}
