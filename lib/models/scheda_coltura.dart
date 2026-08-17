class ColturaBase {
  final String id, nome, tipo, categoria, fabbisognoIdrico, emoji;
  final double tempMinima, tempOttimale, piantePerMq;
  final List<int> mesiSemina;

  ColturaBase({
    required this.id, required this.nome, required this.tipo,
    required this.categoria, required this.tempMinima, required this.tempOttimale,
    required this.fabbisognoIdrico, required this.piantePerMq,
    required this.emoji, required this.mesiSemina,
  });
}

class Varieta {
  final String id, nome, idColturaBase, segnaliRaccolta;
  final int giorniCicloStandard;

  Varieta({required this.id, required this.nome, required this.idColturaBase,
    required this.giorniCicloStandard, required this.segnaliRaccolta});
}
