import '../models/scheda_coltura.dart';

class SchedeColtureRepository {
  static ColturaBase _c(String id, String nome, String tipo, String cat,
          double tMin, double tOpt, String idr, double pmq, String emoji, List<int> mesi) =>
      ColturaBase(id: id, nome: nome, tipo: tipo, categoria: cat, tempMinima: tMin,
          tempOttimale: tOpt, fabbisognoIdrico: idr, piantePerMq: pmq, emoji: emoji, mesiSemina: mesi);

  static Varieta _v(String id, String nome, String base, int gg, String segnali) =>
      Varieta(id: id, nome: nome, idColturaBase: base, giorniCicloStandard: gg, segnaliRaccolta: segnali);

  static final List<ColturaBase> colture = [
    _c('pomodoro', 'Pomodoro', 'Ortaggio', 'Frutto', 10, 24, 'Alto', 3, '🍅', [4, 5]),
    _c('zucchina', 'Zucchina', 'Ortaggio', 'Frutto', 10, 25, 'Alto', 1.5, '🥒', [4, 5, 6]),
    _c('lattuga', 'Lattuga', 'Ortaggio', 'Foglia', 5, 18, 'Medio', 10, '🥬', [3, 4, 8, 9]),
    _c('spinacio', 'Spinacio', 'Ortaggio', 'Foglia', 0, 15, 'Medio', 25, '🌿', [2, 3, 8, 9]),
    _c('cipolla', 'Cipolla', 'Ortaggio', 'Radici & Bulbi', 5, 20, 'Basso', 40, '🧅', [1, 2, 11, 12]),
    _c('carota', 'Carota', 'Ortaggio', 'Radici & Bulbi', 5, 18, 'Medio', 60, '🥕', [3, 4, 5, 6, 7]),
    _c('fagiolo', 'Fagiolo', 'Ortaggio', 'Legumi', 10, 22, 'Basso', 15, '🫘', [4, 5]),
    _c('pisello', 'Pisello', 'Ortaggio', 'Legumi', 0, 16, 'Basso', 30, '🫛', [2, 3, 10]),
    _c('basilico', 'Basilico', 'Ortaggio', 'Aromatiche', 10, 22, 'Medio', 12, '🌱', [4, 5]),
    _c('fragola', 'Fragola', 'Ortaggio', 'Frutto', -5, 20, 'Medio', 8, '🍓', [8, 9]),
    _c('melo', 'Melo', 'Frutteto', 'Frutto', -10, 22, 'Medio', 0.2, '🍎', [1, 2]),
    _c('fico', 'Fico', 'Frutteto', 'Frutto', -5, 25, 'Basso', 0.1, '🌳', [1, 2, 11, 12]),
  ];

  static final List<Varieta> varieta = [
    _v('pom_san_marzano', 'San Marzano', 'pomodoro', 80, 'Frutto rosso e leggermente morbido'),
    _v('pom_cuore_bue', 'Cuore di Bue', 'pomodoro', 85, 'Frutto grosso, spalla chiara'),
    _v('zuc_nerino', 'Nerino', 'zucchina', 55, 'Fiore aperto e frutto lucido'),
    _v('lat_gentilina', 'Gentilina', 'lattuga', 45, 'Cesto pieno e foglie tenere'),
    _v('lat_romana', 'Romana', 'lattuga', 60, 'Cesto compatto'),
    _v('cip_tropea', 'Rossa di Tropea', 'cipolla', 120, 'Parte aerea seccata'),
    _v('cip_dorata', 'Dorata di Parma', 'cipolla', 110, 'Collo morbido e piegato'),
    _v('car_nantes', 'Nantese', 'carota', 75, 'Foglia ingiallita, spalla arancio'),
    _v('fag_borlotto', 'Borlotto Nano', 'fagiolo', 90, 'Baccello secco e screziato'),
    _v('pis_rampicante', 'Mezzo Rampicante', 'pisello', 70, 'Baccello turgido'),
    _v('bas_genovese', 'Genovese', 'basilico', 60, 'Foglie profumate prima della fioritura'),
    _v('melo_annurca', 'Annurca', 'melo', 150, 'Colorazione rossa e caduta naturale'),
    _v('melo_golden', 'Golden Delicious', 'melo', 160, 'Buccia gialla uniforme'),
    _v('fra_rifiorente', 'Rifiorente', 'fragola', 90, 'Frutto rosso uniforme'),
  ];

  static List<ColturaBase> getColture() => colture;
  static List<Varieta> getVarietaPerColtura(String id) =>
      varieta.where((v) => v.idColturaBase == id).toList();
  static Varieta? getVarietaById(String id) {
    try { return varieta.firstWhere((v) => v.id == id); } catch (_) { return null; }
  }
  static ColturaBase? getColturaById(String id) {
    try { return colture.firstWhere((c) => c.id == id); } catch (_) { return null; }
  }
  static ColturaBase? getColturaPerVarieta(String idVarieta) {
    final v = getVarietaById(idVarieta);
    return v == null ? null : getColturaById(v.idColturaBase);
  }
}
