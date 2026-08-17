class CardSettimana {
  final String titoloMese, sottotitoloMese, titoloSettimana;
  final String climaSuolo, azione, osservazione;
  final String? divieto, massima;

  const CardSettimana({required this.titoloMese, required this.sottotitoloMese,
    required this.titoloSettimana, required this.climaSuolo, required this.azione,
    required this.osservazione, this.divieto, this.massima});
}
