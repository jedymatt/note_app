import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart' as usr;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<usr.User?> get user {
    return _auth.authStateChanges().map(
          (user) => (user != null)
              ? usr.User(
                  uid: user.uid,
                  displayName: user.displayName,
                  photoUrl: user.photoURL,
                )
              : null,
        );
  }

  Future<String> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.code;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.code;
    } catch (e) {
      rethrow;
    }
  }
}
