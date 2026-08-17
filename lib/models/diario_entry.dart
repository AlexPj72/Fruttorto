import 'package:cloud_firestore/cloud_firestore.dart';

class DiarioEntry {
  final String id, tipo, testo;
  final DateTime data;
  final String? fotoUrl;

  DiarioEntry({required this.id, required this.tipo, required this.testo,
    required this.data, this.fotoUrl});

  factory DiarioEntry.fromMap(Map<String, dynamic> m, String id) => DiarioEntry(
    id: id, tipo: m['tipo'] ?? 'nota', testo: m['testo'] ?? '',
    data: (m['data'] as Timestamp?)?.toDate() ?? DateTime.now(),
    fotoUrl: m['fotoUrl'],
  );

  Map<String, dynamic> toMap() =>
      {'tipo': tipo, 'testo': testo, 'data': Timestamp.fromDate(data), 'fotoUrl': fotoUrl};
}
