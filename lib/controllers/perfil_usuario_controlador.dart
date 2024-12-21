import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronosalud/models/modelo_usuario.dart';

class PerfilController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener datos del usuario desde Firestore
  Future<Users?> fetchUserData(String? email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Users.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      throw Exception("Error al obtener los datos del usuario: $e");
    }
  }

// Actualizar los datos del usuario
  Future<void> updateUserData(Users user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      throw Exception("Error al actualizar los datos del usuario: $e");
    }
  }
}
