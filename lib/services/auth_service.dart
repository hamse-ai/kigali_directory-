import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream to listen to auth state changes (Login/Logout)
  Stream<User?> get user => _auth.authStateChanges();

  // SIGN UP
  Future<String?> signUp(String email, String password) async {
    try {
      // 1. Create User in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // 2. Send Email Verification (Assignment Requirement)
        await user.sendEmailVerification();

        // 3. Create a Profile in Firestore
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'notificationsEnabled': true, // Default setting
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message for the UI
    }
  }

  // LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}