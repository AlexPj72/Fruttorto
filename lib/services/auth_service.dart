import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  AuthService() {
    _user = _firebaseAuth.currentUser;
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint('Errore login: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
