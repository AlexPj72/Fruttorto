import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _nonFare = false;
  String? _cittaManualeNome;
  double? _cittaManualeLat, _cittaManualeLon;

  bool get nonFare => _nonFare;
  String? get cittaManualeNome => _cittaManualeNome;
  double? get cittaManualeLat => _cittaManualeLat;
  double? get cittaManualeLon => _cittaManualeLon;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _nonFare = p.getBool('nonFare') ?? false;
    _cittaManualeNome = p.getString('cittaNome');
    _cittaManualeLat = p.getDouble('cittaLat');
    _cittaManualeLon = p.getDouble('cittaLon');
    notifyListeners();
  }

  Future<void> setNonFare(bool v) async {
    _nonFare = v;
    (await SharedPreferences.getInstance()).setBool('nonFare', v);
    notifyListeners();
  }

  Future<void> setCittaManuale(String nome, double lat, double lon) async {
    _cittaManualeNome = nome; _cittaManualeLat = lat; _cittaManualeLon = lon;
    final p = await SharedPreferences.getInstance();
    await p.setString('cittaNome', nome);
    await p.setDouble('cittaLat', lat);
    await p.setDouble('cittaLon', lon);
    notifyListeners();
  }

  Future<void> clearCittaManuale() async {
    _cittaManualeNome = null; _cittaManualeLat = null; _cittaManualeLon = null;
    final p = await SharedPreferences.getInstance();
    await p.remove('cittaNome'); await p.remove('cittaLat'); await p.remove('cittaLon');
    notifyListeners();
  }
}
