import '../models/plant_model.dart';
import '../models/scheda_coltura.dart';

class LogicaAgronomica {
  static double fattoreZona(String? zona) =>
      zona == 'Nord' ? 1.15 : (zona == 'Sud' ? 0.85 : 1.0);

  static int giorniCicloReali(PlantModel p, String? zona) =>
      ((p.varieta?.giorniCicloStandard ?? 60) * fattoreZona(zona)).round();

  static DateTime dataRaccoltaPrevista(PlantModel p, String? zona) =>
      p.plantedDate.add(Duration(days: giorniCicloReali(p, zona)));

  static int giorniRimasti(PlantModel p, String? zona) {
    final d = dataRaccoltaPrevista(p, zona).difference(DateTime.now()).inDays;
    return d < 0 ? 0 : d;
  }

  static List<int> mesiSeminaPerZona(ColturaBase c, String? zona) {
    final shift = zona == 'Nord' ? 1 : (zona == 'Sud' ? -1 : 0);
    return c.mesiSemina.map((m) {
      var s = m + shift;
      if (s < 1) s += 12;
      if (s > 12) s -= 12;
      return s;
    }).toSet().toList()..sort();
  }
}
