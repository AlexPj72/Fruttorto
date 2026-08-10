import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/appezzamento.dart';
import 'dart:async';

class HomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'appezzamenti';
  StreamSubscription? _subscription;

  List<Appezzamento> _appezzamenti = [];
  List<Appezzamento> get appezzamenti => _appezzamenti;

  Appezzamento? _appezzamentoAttivo;
  Appezzamento? get appezzamentoAttivo => _appezzamentoAttivo;

  HomeViewModel() {
    _subscription = _firestore.collection(_collectionPath).snapshots().listen((snapshot) {
      _appezzamenti = snapshot.docs.map((doc) => Appezzamento.fromFirestore(doc)).toList();
      if (_appezzamenti.isNotEmpty && (_appezzamentoAttivo == null || !_appezzamenti.contains(_appezzamentoAttivo))) {
        _appezzamentoAttivo = _appezzamenti.first;
      }
      notifyListeners();
    });
  }

  void cambiaAppezzamentoAttivo(Appezzamento? nuovo) {
    if (nuovo != null && _appezzamenti.contains(nuovo)) {
      _appezzamentoAttivo = nuovo;
      notifyListeners();
    }
  }

  Future<void> addAppezzamento(String nome, double larghezza, double lunghezza, String comune, String provincia) async {
    try {
      await _firestore.collection(_collectionPath).add({
        'nome': nome,
        'larghezza': larghezza,
        'lunghezza': lunghezza,
        'comune': comune,
        'provincia': provincia,
        'coltivazioni': [],
      });
    } catch (e) {
      print("Errore durante l'aggiunta dell'appezzamento: $e");
    }
  }

  Future<void> eliminaAppezzamento(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      print("Errore durante l'eliminazione dell'appezzamento: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
