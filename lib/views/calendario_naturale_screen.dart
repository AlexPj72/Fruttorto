import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/meteo_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';
import 'package:myapp/services/calendario_naturale_service.dart';
import 'package:myapp/theme/app_theme.dart';

class CalendarioNaturaleScreen extends StatefulWidget {
  const CalendarioNaturaleScreen({super.key});
  @override
  State<CalendarioNaturaleScreen> createState() => _CalendarioNaturaleScreenState();
}

class _CalendarioNaturaleScreenState extends State<CalendarioNaturaleScreen> {
  late int _mese = DateTime.now().month;
  late int _sett = CalendarioNaturaleService.settimanaCorrente(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final a = context.watch<AppezzamentoRepository>().appezzamentoAttivo;
    final meteo = context.watch<MeteoProvider>().meteo;
    final nonFare = context.watch<SettingsProvider>().nonFare;
    final card = CalendarioNaturaleService.cardPer(
        mese: _mese, settimana: _sett, zona: a.zona, meteo: meteo);
    const nomi = ['Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno',
                  'Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'];

    return Scaffold(
      appBar: AppBar(title: const Text('Calendario Naturale 🌙'), actions: [
        TextButton(onPressed: () => setState(() {
          _mese = DateTime.now().month;
          _sett = CalendarioNaturaleService.settimanaCorrente(DateTime.now());
        }), child: const Text('Torna a Oggi')),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: Column(children: [
          Text(nomi[_mese - 1], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppTheme.verdeScuro)),
          Text('— ${card.sottotitoloMese} —',
              style: const TextStyle(fontStyle: FontStyle.italic, color: AppTheme.terra)),
        ])),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _mese, decoration: const InputDecoration(labelText: 'Mese'),
          items: [for (int i = 1; i <= 12; i++) DropdownMenuItem(value: i, child: Text(nomi[i - 1]))],
          onChanged: (v) => setState(() { _mese = v!; _sett = 1; })),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          segments: [for (int i = 1; i <= 4; i++) ButtonSegment(value: i, label: Text('Sett. $i'))],
          selected: {_sett},
          onSelectionChanged: (s) => setState(() => _sett = s.first)),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(card.titoloSettimana, style: AppTheme.titoloSezione),
            const SizedBox(height: 10),
            _riga('🌦️', 'Clima & Suolo', card.climaSuolo),
            _riga('✅', 'Azione', card.azione),
            if (nonFare && card.divieto != null) _riga('🚫', 'Divieto', card.divieto!),
            _riga('👀', 'Osservazione', card.osservazione),
            if (card.massima != null) ...[
              const Divider(),
              Center(child: Text(card.massima!,
                  style: const TextStyle(fontStyle: FontStyle.italic, color: AppTheme.terra))),
            ],
          ]))),
      ]),
    );
  }

  Widget _riga(String emoji, String titolo, String testo) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$emoji $titolo', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.verdeScuro)),
      Text(testo),
    ]));
}
