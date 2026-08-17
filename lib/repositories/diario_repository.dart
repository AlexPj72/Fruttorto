import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/diario_entry.dart';

class DiarioRepository {
  CollectionReference? get _col {
    final u = FirebaseAuth.instance.currentUser;
    return u == null ? null : FirebaseFirestore.instance.collection('users').doc(u.uid).collection('diario');
  }

  Stream<List<DiarioEntry>> stream() {
    final c = _col;
    if (c == null) return Stream.value([]);
    return c.orderBy('data', descending: true).snapshots().map(
        (s) => s.docs.map((d) => DiarioEntry.fromMap(d.data() as Map<String, dynamic>, d.id)).toList());
  }

  Future<void> aggiungiNota(String testo) async {
    await _col?.add(DiarioEntry(id: '', tipo: 'nota', testo: testo, data: DateTime.now()).toMap());
  }

  Future<void> aggiungiFoto(Uint8List bytes, String nota) async {
    final u = FirebaseAuth.instance.currentUser!;
    final ref = FirebaseStorage.instance.ref().child('diario/${u.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    final url = await ref.getDownloadURL();
    await _col?.add(DiarioEntry(id: '', tipo: 'foto', testo: nota, data: DateTime.now(), fotoUrl: url).toMap());
  }

  Future<void> elimina(String id) async => await _col?.doc(id).delete();
}
