import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginGoogleUtils {
  static const String tag = "LoginGoogleUtils";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //google metodo
  //signInwithGoogle
  Future<Future<User?>> signInwithGoogle() async {
    log("$tag, signInwithGoogle() init...");

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    log("$tag, signInwithGoogle() googleUser email -> ${googleSignInAccount?.email}");
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken);

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    User? user = userCredential.user;

    return _isCurrentSignIn(user);
  }

  Future<User?> _isCurrentSignIn(User? user) async {
    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser?.uid);

      log('$tag, signInWithGoogle succeeded: $user');
      return user;
    }
    return null;
  }

//metodo cerrar sesión
  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    log('$tag + , User signed Out, Google.');
  }
}
