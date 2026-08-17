import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/models/appezzamento.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;

class AppezzamentoRepository extends ChangeNotifier {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'appezzamenti',
  );
  final AuthService _authService = AuthService();
  List<Appezzamento> _appezzamenti = [];
  Appezzamento? _appezzamentoAttivo;

  List<Appezzamento> get tuttiGliAppezzamenti => _appezzamenti;

  Appezzamento get appezzamentoAttivo =>
      _appezzamentoAttivo ??
      (tuttiGliAppezzamenti.isNotEmpty
          ? tuttiGliAppezzamenti.first
          : Appezzamento(
              id: 'placeholder',
              nome: 'Nessun appezzamento',
              larghezza: null,
              lunghezza: null,
              regione: '',
              provincia: '',
              comune: '',
              userId: '',
            ));

  AppezzamentoRepository() {
    _authService.addListener(_onAuthStateChanged);
    _onAuthStateChanged();
  }

  void _onAuthStateChanged() {
    if (_authService.user != null) {
      _caricaAppezzamenti(_authService.user!.uid);
    } else {
      _appezzamenti = [];
      _appezzamentoAttivo = null;
      notifyListeners();
    }
  }

  void _caricaAppezzamenti(String userId) {
    _collection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
          (snapshot) {
            _appezzamenti = snapshot.docs
                .map((doc) => Appezzamento.fromFirestore(doc))
                .toList();
            if (_appezzamenti.isNotEmpty) {
              final attivoEsiste = _appezzamenti.any(
                (a) => a.id == _appezzamentoAttivo?.id,
              );
              if (!attivoEsiste) {
                _appezzamentoAttivo = _appezzamenti.first;
              }
            } else {
              _appezzamentoAttivo = null;
            }
            notifyListeners();
          },
          onError: (error) {
            debugPrint('⚠️ Errore caricamento appezzamenti: $error');
            _appezzamenti = [];
            _appezzamentoAttivo = null;
            notifyListeners();
          },
        );
  }

  Future<void> aggiungiAppezzamento(Appezzamento appezzamento) async {
    await _collection.add(appezzamento.toFirestore());
  }

  Future<void> rimuoviAppezzamento(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> aggiornaPacciamatura(String id, double cm) async {
    await _collection.doc(id).update({
      'pacciamaturaCm': cm,
      'pacciamaturaData': Timestamp.now(),
    });
  }

  void impostaAppezzamentoAttivo(Appezzamento appezzamento) {
    _appezzamentoAttivo = appezzamento;
    notifyListeners();
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}
