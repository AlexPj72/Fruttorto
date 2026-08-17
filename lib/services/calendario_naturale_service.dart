import '../models/card_settimana.dart';
import 'meteo_service.dart';

class CalendarioNaturaleService {
  static const _mesi = {
    1: ['Gennaio', 'il riposo che prepara',
        ['Il progetto', 'I semi dell\'anno', 'Il suolo coperto', 'La potatura leggera'],
        'Disegna la mappa dell\'orto e ordina i semi',
        'Non lavorare il suolo bagnato',
        'Sotto la pacciama il suolo resta soffice e profuma di bosco',
        'Chi riposa, prepara.'],
    2: ['Febbraio', 'il risveglio sotto terra',
        ['Il semenzaio', 'I primi trapianti protetti', 'Le aromatiche perenni', 'La pacciama sottile'],
        'Avvia il semenzaio al caldo',
        'Non trapiantare all\'aperto nelle gelate',
        'La terra in superficie si sgrana: è il segnale del risveglio', null],
    3: ['Marzo', 'la prima chiamata',
        ['Semine a pieno campo', 'Trapianti precoci', 'Osserva le erbe spontanee', 'Acqua solo se serve'],
        'Semina le specie robuste',
        'Non vangare: arieggia solo in superficie',
        'Le erbe spontanee dicono che il suolo è vivo',
        'Il suolo non si volta, si copre.'],
    4: ['Aprile', 'il grande via',
        ['Semine e trapianti in scala', 'Pacciamatura fresca', 'Acqua al mattino', 'Osserva gli afidi'],
        'Trapianta la maggior parte delle colture',
        'Non lasciare il suolo nudo',
        'Afidi in piccola quantità sono normali: le coccinelle stanno arrivando', null],
    5: ['Maggio', 'l\'abbondanza che esplode',
        ['Trapianti estivi', 'Rabbocco pacciama', 'Primi raccolti', 'Ombreggi leggeri'],
        'Raccogli spesso per stimolare la pianta',
        'Non concimare a caso: guarda la pianta',
        'Foglia troppo scura = troppo azoto', null],
    6: ['Giugno', 'il sole che chiede acqua',
        ['Acqua profonda e rara', 'Pacciama spessa', 'Semine autunnali precoci', 'Raccolta mattina'],
        'Innaffia la sera, poco e profondo',
        'Non bagnare le foglie',
        'Suolo umido sotto 5 cm di pacciama = irrigazione giusta',
        'L\'acqua si dà al suolo, non alla foglia.'],
    7: ['Luglio', 'il raccolto generoso',
        ['Raccolta quotidiana', 'Semine di fine estate', 'Osserva il suolo', 'Prepara il dopo'],
        'Raccogli al mattino presto',
        'Non lasciare frutti maturi in pianta',
        'Il suolo deve restare coperto anche a luglio', null],
    8: ['Agosto', 'il caldo che insegna la pazienza',
        ['Ombra e pacciama', 'Acqua la sera', 'Semina autunnale', 'Riposo al fresco'],
        'Proteggi le giovani piantine dal sole',
        'Non lavorare nelle ore calde',
        'Se la pacciama è sottile, il suolo si screpola: rabbocca',
        'Il caldo non si combatte, si accompagna.'],
    9: ['Settembre', 'il secondo inizio',
        ['Semine autunnali', 'Trapianti di insalate', 'Raccolta dei semi', 'Ringrazia'],
        'Semina spinaci e insalate',
        'Non scoprire il suolo dopo i raccolti',
        'I semi migliori si scelgono dalle piante migliori', null],
    10: ['Ottobre', 'la coperta sul suolo',
        ['Pacciama d\'inverno', 'Raccolta degli ultimi frutti', 'Foglie come tesoro', 'Proteggi le radici'],
        'Copri tutto con foglie e paglia',
        'Non bruciare i residui: sono cibo',
        'Le foglie secche raccolte oggi sono la pacciama di domani', null],
    11: ['Novembre', 'il ringraziamento',
        ['Riposo attivo', 'Ripara gli attrezzi', 'Osserva gli uccelli', 'Pianifica piano'],
        'Lascia semi e rifugi per la fauna',
        'Non pulire tutto: i residui proteggono',
        'Un orto "in ordine" d\'inverno è un deserto', null],
    12: ['Dicembre', 'il silenzio fertile',
        ['Lettura e progetto', 'Semi al fresco', 'Il calendario dell\'anno', 'Niente fretta'],
        'Rivedi il diario dell\'anno',
        'Non potare con gelo forte',
        'Sotto la neve o la pacciama, la vita continua',
        'Anche il nulla apparente è lavoro.'],
  };

  static String _climaTipico(int mese, String? zona) {
    final inverno = [12, 1, 2].contains(mese);
    final estate = [6, 7, 8].contains(mese);
    if (inverno) {
      return zona == 'Nord'
        ? 'Freddo umido, possibili gelate: suolo protetto dalla pacciama'
        : (zona == 'Sud' ? 'Mite e piovoso: buon tempo per semine precoci' : 'Fresco variabile, suolo lavorabile');
    }
    if (estate) {
      return zona == 'Sud'
        ? 'Caldo intenso: pacciama spessa e acqua serale'
        : (zona == 'Nord' ? 'Caldo afoso con temporali: attenzione ai ristagni' : 'Caldo stabile: irrigazione regolare');
    }
    return 'Temperature miti, suolo in buon equilibrio';
  }

  static CardSettimana cardPer({required int mese, required int settimana,
      String? zona, MeteoData? meteo}) {
    final d = _mesi[mese]!;
    final bool eOggi = meteo != null && DateTime.now().month == mese;
    return CardSettimana(
      titoloMese: d[0] as String,
      sottotitoloMese: d[1] as String,
      titoloSettimana: (d[2] as List)[((settimana - 1) % 4)] as String,
      climaSuolo: eOggi
          ? 'Ora: ${meteo.temperaturaAria.toStringAsFixed(0)}°C aria, ${meteo.temperaturaSuolo.toStringAsFixed(0)}°C suolo, pioggia ${meteo.pioggiaOggi} mm'
          : '${_climaTipico(mese, zona)}${zona != null ? ' - zona $zona' : ''}',
      azione: d[3] as String,
      divieto: d[4] as String,
      osservazione: d[5] as String,
      massima: d[6] as String?,
    );
  }

  static int settimanaCorrente(DateTime d) => ((d.day - 1) ~/ 7) + 1;
}
