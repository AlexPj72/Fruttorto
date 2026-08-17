import 'package:flutter/foundation.dart';
import '../services/meteo_service.dart';

class MeteoProvider extends ChangeNotifier {
  MeteoData? _meteo;
  bool _loading = false;
  String? _errore;

  MeteoData? get meteo => _meteo;
  bool get loading => _loading;
  String? get errore => _errore;

  Future<void> carica(double lat, double lon) async {
    _loading = true; _errore = null; notifyListeners();
    try {
      _meteo = await MeteoService.getMeteo(lat, lon);
    } catch (e) {
      _errore = 'Meteo non disponibile';
    }
    _loading = false; notifyListeners();
  }
}
