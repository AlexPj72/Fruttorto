import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/services/zona_climatica_service.dart';

/// Rappresenta un comune con le sue coordinate e la zona climatica derivata.
class ComuneInfo {
  final String nome;
  final double lat;
  final double lon;
  final String zona; // Nord / Centro / Sud, calcolata dalla latitudine

  ComuneInfo({required this.nome, required this.lat, required this.lon})
      : zona = ZonaClimaticaService.daLatitudine(lat);
}

/// Risultato della ricerca del comune più vicino a una coppia di coordinate GPS.
class RisultatoLocalizzazione {
  final String regione;
  final String provincia;
  final ComuneInfo comune;
  final double distanzaKm;

  RisultatoLocalizzazione({
    required this.regione,
    required this.provincia,
    required this.comune,
    required this.distanzaKm,
  });
}

class GeoService {
  static Map<String, dynamic>? _data;

  static Future<void> _ensureLoaded() async {
    if (_data != null) return;
    final jsonString = await rootBundle.loadString('assets/italia_geo.json');
    _data = json.decode(jsonString) as Map<String, dynamic>;
  }

  static Future<List<String>> getRegioni() async {
    await _ensureLoaded();
    return List<String>.from(_data!['regioni']);
  }

  static Future<List<String>> getProvince(String regione) async {
    await _ensureLoaded();
    final province = _data!['province'] as Map<String, dynamic>;
    return List<String>.from(province[regione] ?? []);
  }

  /// Restituisce i comuni di una provincia con coordinate e zona climatica.
  static Future<List<ComuneInfo>> getComuni(String provincia) async {
    await _ensureLoaded();
    final comuni = _data!['comuni'] as Map<String, dynamic>;
    final lista = comuni[provincia] as List<dynamic>? ?? [];
    return lista
        .map((c) => ComuneInfo(
              nome: c['nome'] as String,
              lat: (c['lat'] as num).toDouble(),
              lon: (c['lon'] as num).toDouble(),
            ))
        .toList();
  }

  /// Trova il comune più vicino alle coordinate GPS fornite, scorrendo
  /// tutti i comuni d'Italia. Restituisce anche regione e provincia
  /// di appartenenza, pronte per precompilare il form.
  static Future<RisultatoLocalizzazione> trovaComunePiuVicino(
    double lat,
    double lon,
  ) async {
    await _ensureLoaded();

    final province = _data!['province'] as Map<String, dynamic>;
    // Mappa provincia -> regione, costruita una sola volta al volo.
    final regionePerProvincia = <String, String>{};
    province.forEach((regione, listaProvince) {
      for (final p in List<String>.from(listaProvince)) {
        regionePerProvincia[p] = regione;
      }
    });

    final comuni = _data!['comuni'] as Map<String, dynamic>;

    String? provinciaMigliore;
    Map<String, dynamic>? comuneMigliore;
    double distanzaMinima = double.infinity;

    comuni.forEach((provincia, listaComuni) {
      for (final c in listaComuni as List<dynamic>) {
        final cLat = (c['lat'] as num).toDouble();
        final cLon = (c['lon'] as num).toDouble();
        final d = _distanzaKm(lat, lon, cLat, cLon);
        if (d < distanzaMinima) {
          distanzaMinima = d;
          provinciaMigliore = provincia;
          comuneMigliore = c as Map<String, dynamic>;
        }
      }
    });

    if (provinciaMigliore == null || comuneMigliore == null) {
      throw Exception('Impossibile determinare il comune dalla posizione GPS.');
    }

    return RisultatoLocalizzazione(
      regione: regionePerProvincia[provinciaMigliore!] ?? '',
      provincia: provinciaMigliore!,
      comune: ComuneInfo(
        nome: comuneMigliore!['nome'] as String,
        lat: (comuneMigliore!['lat'] as num).toDouble(),
        lon: (comuneMigliore!['lon'] as num).toDouble(),
      ),
      distanzaKm: distanzaMinima,
    );
  }

  /// Formula di Haversine: distanza in km tra due coppie di coordinate.
  static double _distanzaKm(double lat1, double lon1, double lat2, double lon2) {
    const raggioTerraKm = 6371.0;
    final dLat = _gradiInRadianti(lat2 - lat1);
    final dLon = _gradiInRadianti(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_gradiInRadianti(lat1)) *
            math.cos(_gradiInRadianti(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return raggioTerraKm * c;
  }

  static double _gradiInRadianti(double gradi) => gradi * math.pi / 180;
}
