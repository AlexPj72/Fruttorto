import 'package:cloud_firestore/cloud_firestore.dart';

class Appezzamento {
  final String id;
  final String nome;
  final double? larghezza;
  final double? lunghezza;
  final String regione;
  final String provincia;
  final String comune;
  final double? lat;
  final double? lon;
  final String?
  zona; // Nord / Centro / Sud, calcolata dalla latitudine del comune
  final String userId;

  Appezzamento({
    required this.id,
    required this.nome,
    this.larghezza,
    this.lunghezza,
    required this.regione,
    required this.provincia,
    required this.comune,
    this.lat,
    this.lon,
    this.zona,
    required this.userId,
  });

  factory Appezzamento.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Appezzamento(
      id: doc.id,
      nome: data['nome'] ?? '',
      larghezza: data['larghezza'] != null
          ? (data['larghezza'] as num).toDouble()
          : null,
      lunghezza: data['lunghezza'] != null
          ? (data['lunghezza'] as num).toDouble()
          : null,
      regione: data['regione'] ?? '',
      provincia: data['provincia'] ?? '',
      comune: data['comune'] ?? '',
      lat: data['lat'] != null ? (data['lat'] as num).toDouble() : null,
      lon: data['lon'] != null ? (data['lon'] as num).toDouble() : null,
      zona: data['zona'],
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'larghezza': larghezza,
      'lunghezza': lunghezza,
      'regione': regione,
      'provincia': provincia,
      'comune': comune,
      'lat': lat,
      'lon': lon,
      'zona': zona,
      'userId': userId,
    };
  }
}
