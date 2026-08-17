import 'dart:convert';
import 'package:http/http.dart' as http;

class MeteoData {
  final double temperaturaAria;
  final double umiditaAria;
  final double temperaturaSuolo;
  final double umiditaSuolo;
  final double pioggiaOggi;

  MeteoData({
    required this.temperaturaAria, required this.umiditaAria,
    required this.temperaturaSuolo, required this.umiditaSuolo,
    required this.pioggiaOggi,
  });

  String get consiglioIrrigazione {
    if (pioggiaOggi > 5) return "💧 Non innaffiare: ha già piovuto a sufficienza.";
    if (umiditaSuolo > 60) return "🌱 Il suolo è ancora umido, rimanda l'irrigazione.";
    if (temperaturaAria > 28) return "☀️ Fa molto caldo: innaffia la sera con abbondanza.";
    return "✅ Clima regolare: innaffia secondo il fabbisogno della coltura.";
  }
}

class MeteoService {
  static Future<MeteoData> getMeteo(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon'
      '&current=temperature_2m,relative_humidity_2m,soil_temperature_0_to_7cm,soil_moisture_0_to_7cm,precipitation'
      '&timezone=auto'
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];
        double umiditaSuoloPct = ((current['soil_moisture_0_to_7cm'] ?? 0).toDouble() * 100).clamp(0, 100);

        return MeteoData(
          temperaturaAria: (current['temperature_2m'] ?? 0).toDouble(),
          umiditaAria: (current['relative_humidity_2m'] ?? 0).toDouble(),
          temperaturaSuolo: (current['soil_temperature_0_to_7cm'] ?? 0).toDouble(),
          umiditaSuolo: umiditaSuoloPct,
          pioggiaOggi: (current['precipitation'] ?? 0).toDouble(),
        );
      } else {
        throw Exception('Errore API Meteo');
      }
    } catch (e) {
      throw Exception('Errore connessione: $e');
    }
  }
}
