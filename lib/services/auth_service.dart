import 'package:flutter/material.dart';

// Creiamo una finta classe User per non rompere i tipi di dato nel resto dell'app
class MockUser {
  final String uid;
  final String? email;
  MockUser({required this.uid, this.email});
}

class AuthService with ChangeNotifier {
  // Simuliamo l'utente locale (se è null l'utente è disconnesso, altrimenti è loggato)
  dynamic _user;

  AuthService() {
    // Simuliamo un utente già loggato di default per farti entrare direttamente nell'app
    _user = MockUser(uid: 'mock_123', email: 'test@fruttorto.com');
  }

  dynamic get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    try {
      // Simuliamo un caricamento di rete di mezzo secondo
      await Future.delayed(const Duration(milliseconds: 500));
      _user = MockUser(uid: 'mock_123', email: email);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _user = null;
    notifyListeners();
  }
}
