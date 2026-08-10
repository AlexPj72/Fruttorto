import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class GeografiaService {
  // Dati caricati dal JSON
  late List<String> _regioni;
  late Map<String, List<String>> _province;

  // Singleton per un'unica istanza del servizio
  static final GeografiaService _instance = GeografiaService._internal();
  factory GeografiaService() => _instance;
  GeografiaService._internal();

  // Carica i dati dal file JSON e li memorizza
  Future<void> caricaDati() async {
    final String jsonString = await rootBundle.loadString('assets/geografia.json');
    final data = json.decode(jsonString);

    _regioni = List<String>.from(data['regioni']);

    // Le chiavi delle mappe interne potrebbero non essere interpretate come String
    _province = Map<String, List<String>>.from(
      (data['province'] as Map).map((key, value) => MapEntry(key, List<String>.from(value)))
    );
  }

  // Metodi per accedere ai dati
  List<String> getRegioni() => _regioni;

  List<String> getProvince(String regione) {
    return _province[regione] ?? [];
  }

  Future<List<String>> getComuni(String provincia) async {
    if (provincia.isEmpty) return [];
    try {
      // API per ottenere i comuni di una provincia italiana
      final response = await http.get(Uri.parse('https://raw.githubusercontent.com/matteocontrini/comuni-json/master/comuni.json'));

      if (response.statusCode == 200) {
        final List<dynamic> tuttiIComuni = json.decode(utf8.decode(response.bodyBytes));
        final comuniFiltrati = tuttiIComuni
            .where((comune) => comune['provincia']['nome'] == provincia)
            .map<String>((comune) => comune['nome'] as String)
            .toList();
        
        // Ordina i comuni alfabeticamente
        comuniFiltrati.sort();
        
        return comuniFiltrati;
      }
    } catch (e) {
      print('Errore durante il recupero dei comuni: $e');
    }
    return [];
  }
}
