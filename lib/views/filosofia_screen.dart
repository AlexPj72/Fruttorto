import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class FilosofiaScreen extends StatefulWidget {
  const FilosofiaScreen({super.key});
  @override
  State<FilosofiaScreen> createState() => _FilosofiaScreenState();
}

class _FilosofiaScreenState extends State<FilosofiaScreen> {
  String? _tag;
  static final _schede = [
    {'titolo': 'Masanobu Fukuoka', 'tag': ['Non Fare', 'Natura'],
     'testo': 'Quattro principi: nessuna lavorazione, nessun concime chimico, nessun diserbo, nessun pesticida. L\'orto si accompagna, non si comanda.'},
    {'titolo': 'Ruth Stout', 'tag': ['Pacciamatura', 'Suolo Vivo'],
     'testo': 'La pacciama permanente di fieno e paglia sostituisce vanga e zappa: il suolo resta coperto, umido e vivo tutto l\'anno.'},
    {'titolo': 'Emilio Cappello', 'tag': ['Non Fare', 'Suolo Vivo'],
     'testo': 'La semina su sodo: si apre solo un piccolo solco nel terreno inerbito, il resto lo fanno radici e lombrichi.'},
    {'titolo': 'Pacciamatura: quanto e con cosa', 'tag': ['Pacciamatura'],
     'testo': '10–20 cm di fieno o paglia. Fieno: più nutrienti; paglia: più durata. Rabbocca quando lo strato scende sotto i 5 cm.'},
    {'titolo': 'Erbe spontanee e bio-indicatori', 'tag': ['Natura', 'Suolo Vivo'],
     'testo': 'Lumache e afidi non sono nemici ma segnali: raccontano squilibri di suolo o di eccessi. Osservali prima di trattare.'},
  ];

  @override
  Widget build(BuildContext context) {
    final tags = ['Non Fare', 'Suolo Vivo', 'Pacciamatura', 'Natura'];
    final voci = _schede.where((s) => _tag == null || (s['tag'] as List).contains(_tag)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Filosofia · La Saggezza 🍃')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('I Maestri e i principi, navigabili per argomento.',
            style: TextStyle(fontStyle: FontStyle.italic, color: AppTheme.terra)),
        const SizedBox(height: 12),
        Wrap(spacing: 6, children: [
          for (final t in tags)
            FilterChip(label: Text(t), selected: _tag == t,
                onSelected: (v) => setState(() => _tag = v ? t : null)),
        ]),
        const SizedBox(height: 12),
        for (final s in voci)
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s['titolo'] as String, style: AppTheme.titoloSezione),
              const SizedBox(height: 6),
              Text(s['testo'] as String),
              const SizedBox(height: 8),
              Wrap(spacing: 6, children: [
                for (final t in s['tag'] as List)
                  Chip(label: Text(t, style: const TextStyle(fontSize: 11))),
              ]),
            ]))),
      ]),
    );
  }
}
