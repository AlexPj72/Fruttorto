import 'package:cloud_firestore/cloud_firestore.dart';

class Appezzamento {
  final String id;
  final String nome;
  final double larghezza;
  final double lunghezza;
  final String comune;
  final String provincia;

  Appezzamento({
    required this.id,
    required this.nome,
    required this.larghezza,
    required this.lunghezza,
    required this.comune,
    required this.provincia,
  });

  factory Appezzamento.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Appezzamento(
      id: doc.id,
      nome: data['nome'] ?? '',
      larghezza: (data['larghezza'] ?? 0.0).toDouble(),
      lunghezza: (data['lunghezza'] ?? 0.0).toDouble(),
      comune: data['comune'] ?? '',
      provincia: data['provincia'] ?? '',
    );
  }
}
