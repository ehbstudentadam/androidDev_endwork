import 'package:drop_application/data/repository/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  final FirestoreRepository firestoreRepository = FirestoreRepository();

  Future<void> signUp({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await firestoreRepository.createDBUser(
          authUserID: _firebaseAuth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getCurrentAuthenticatedUserId() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        return _firebaseAuth.currentUser!.uid;
      }
      else {
        throw Exception("Authenticated user has returned Null as authenticated user ID");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
