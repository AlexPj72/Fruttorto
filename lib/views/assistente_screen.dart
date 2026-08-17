import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/garden_provider.dart';
import 'package:myapp/providers/meteo_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';
import 'package:myapp/services/assistente_service.dart';
import 'package:myapp/theme/app_theme.dart';

class AssistenteScreen extends StatefulWidget {
  const AssistenteScreen({super.key});
  @override
  State<AssistenteScreen> createState() => _AssistenteScreenState();
}

class _AssistenteScreenState extends State<AssistenteScreen> {
  final List<Map<String, String>> _chat = [
    {'ruolo': 'ai', 'testo': 'Ciao! Sono l\'assistente di Fruttorto 🌿 Chiedimi di acqua, semine o malattie delle tue piante.'},
  ];
  final _ctrl = TextEditingController();
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<AppezzamentoRepository>();
    final a = repo.appezzamentoAttivo;
    final haLuogo = a.lat != null || context.watch<SettingsProvider>().cittaManualeLat != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Assistente 🤖'), actions: [
        IconButton(icon: const Icon(Icons.psychology_alt), tooltip: 'Come ragiona l\'IA?',
            onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
              title: const Text('Come ragiona l\'IA?'),
              content: const Text('Le risposte nascono dal TUO contesto reale: comune, zona climatica, '
                  'meteo Open-Meteo e colture presenti. Con Firebase AI Logic attivo, queste informazioni '
                  'vengono passate a Gemini come prompt contestuale.'),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ho capito'))],
            ))),
      ]),
      body: Column(children: [
        if (!haLuogo)
          Container(color: AppTheme.ambra.withValues(alpha: 0.2), padding: const EdgeInsets.all(10),
            child: const Text('⚠️ Nessuna località impostata: i consigli saranno meno accurati.',
                style: TextStyle(fontSize: 12, color: AppTheme.terra))),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _chat.length,
          itemBuilder: (ctx, i) {
            final m = _chat[i]; final mia = m['ruolo'] == 'utente';
            return Align(alignment: mia ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: mia ? AppTheme.verdeScuro : AppTheme.carta,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.sabbia)),
                child: Text(m['testo']!,
                    style: TextStyle(color: mia ? Colors.white : AppTheme.verdeScuro))));
          })),
        Padding(padding: const EdgeInsets.all(12), child: Row(children: [
          Expanded(child: TextField(controller: _ctrl,
              decoration: const InputDecoration(
                hintText: 'Chiedi al tuo orto…', border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28)))))),
          const SizedBox(width: 8),
          IconButton.filled(onPressed: _busy ? null : _invia,
              style: IconButton.styleFrom(backgroundColor: AppTheme.verdeScuro,
                  foregroundColor: Colors.white, shape: const CircleBorder()),
              icon: const Icon(Icons.send)),
        ])),
      ]),
    );
  }

  Future<void> _invia() async {
    final domanda = _ctrl.text.trim();
    if (domanda.isEmpty) return;
    _ctrl.clear();
    setState(() { _chat.add({'ruolo': 'utente', 'testo': domanda}); _busy = true; });
    final repo = context.read<AppezzamentoRepository>();
    final a = repo.appezzamentoAttivo;
    final meteo = context.read<MeteoProvider>().meteo;
    final garden = context.read<GardenProvider>();
    final risposta = await AssistenteService.rispondi(domanda: domanda, contesto: {
      'comune': a.comune, 'zona': a.zona,
      'meteo': meteo == null ? null : '${meteo.temperaturaAria}°C, suolo ${meteo.temperaturaSuolo}°C, pioggia ${meteo.pioggiaOggi}mm',
      'consiglioIrrigazione': meteo?.consiglioIrrigazione,
      'colture': garden.plants.map((p) => p.nome).join(', '),
    });
    setState(() { _chat.add({'ruolo': 'ai', 'testo': risposta}); _busy = false; });
  }
}
