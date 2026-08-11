import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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

  static Future<List<String>> getComuni(String provincia) async {
    await _ensureLoaded();
    final comuni = _data!['comuni'] as Map<String, dynamic>;
    return List<String>.from(comuni[provincia] ?? []);
  }
}
