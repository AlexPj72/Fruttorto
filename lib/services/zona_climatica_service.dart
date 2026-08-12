/// Determina la macro-zona geografica italiana (Nord / Centro / Sud)
/// a partire dalla latitudine del comune.
///
/// Le soglie sono scelte sulla latitudine (non sui confini amministrativi
/// delle regioni) perché il clima italiano non segue le linee di confine:
/// due comuni della stessa regione a latitudini molto diverse possono avere
/// climi differenti (es. Toscana nord vs Toscana sud).
class ZonaClimaticaService {
  // Soglie approssimative basate sui parallelo di confine tra:
  // - Nord/Centro: circa il confine Emilia-Romagna/Toscana-Marche
  // - Centro/Sud: circa il confine Lazio-Campania / Abruzzo-Molise
  static const double _sogliaNordCentro = 44.0;
  static const double _sogliaCentroSud = 41.5;

  static String daLatitudine(double latitudine) {
    if (latitudine >= _sogliaNordCentro) return 'Nord';
    if (latitudine >= _sogliaCentroSud) return 'Centro';
    return 'Sud';
  }
}
