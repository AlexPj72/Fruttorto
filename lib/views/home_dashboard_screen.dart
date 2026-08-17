import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/appezzamento.dart';
import 'package:myapp/providers/garden_provider.dart';
import 'package:myapp/providers/meteo_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';
import 'package:myapp/services/calendario_naturale_service.dart';
import 'package:myapp/services/logica_agronomica.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/views/widgets/empty_state.dart';
import 'package:myapp/views/widgets/guest_banner.dart';
import 'package:myapp/views/widgets/section_card.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});
  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _caricaMeteo();
  }

  void _caricaMeteo() {
    final settings = context.read<SettingsProvider>();
    final repo = context.read<AppezzamentoRepository>();
    final a = repo.appezzamentoAttivo;
    final lat = settings.cittaManualeLat ?? a.lat;
    final lon = settings.cittaManualeLon ?? a.lon;
    if (lat != null && lon != null) context.read<MeteoProvider>().carica(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    final garden = context.watch<GardenProvider>();
    final repo = context.watch<AppezzamentoRepository>();
    final settings = context.watch<SettingsProvider>();
    final meteo = context.watch<MeteoProvider>();
    final a = repo.appezzamentoAttivo;
    final piante = garden.plants;
    final ora = DateTime.now();
    final card = CalendarioNaturaleService.cardPer(
        mese: ora.month, settimana: CalendarioNaturaleService.settimanaCorrente(ora),
        zona: a.zona, meteo: meteo.meteo);

    return Scaffold(
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        _hero(a, settings),
        const GuestBanner(),
        if (kIsWeb) _pwaBanner(),
        const SizedBox(height: 12),
        _contatori(garden),
        const SizedBox(height: 12),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            _meteoCard(meteo, settings),
            const SizedBox(height: 12),
            SectionCard(titolo: 'Calendario Naturale', onTap: () => context.push('/calendario-naturale'),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${card.titoloMese} - ${card.sottotitoloMese}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.verde)),
                const SizedBox(height: 4),
                Text('Azione: ${card.azione}'),
                if (settings.nonFare && card.divieto != null)
                  Text('Divieto: ${card.divieto}', style: const TextStyle(color: AppTheme.terra)),
              ])),
            const SizedBox(height: 12),
            _situazioneCampo(piante, a),
            const SizedBox(height: 12),
            SectionCard(titolo: 'Pacciamatura', child: _pacciamatura(a, repo)),
            const SizedBox(height: 12),
            SectionCard(titolo: 'Filosofia · La Saggezza dei Maestri',
                onTap: () => context.push('/filosofia'),
                child: const Text('Fukuoka · Stout · Cappello - i principi del "Non Fare" spiegati per tag.')),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Modulo "Non Fare"'),
              subtitle: const Text('Affianca l\'alternativa filosofica ai consigli standard'),
              value: settings.nonFare, activeThumbColor: AppTheme.verde,
              onChanged: (v) => settings.setNonFare(v),
            ),
          ])),
      ]),
    );
  }

  Widget _hero(Appezzamento a, SettingsProvider s) => Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [AppTheme.verdeScuro, AppTheme.verde],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
    ),
    padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Il tuo orto oggi 🌿',
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(s.cittaManualeNome != null
              ? 'Meteo su: ${s.cittaManualeNome}'
              : (a.comune.isNotEmpty ? '${a.comune} · zona ${a.zona ?? '-'}' : 'Aggiungi un appezzamento per iniziare'),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
      ])),
      const Text('🧑🌾', style: TextStyle(fontSize: 52)),
    ]),
  );

  Widget _pwaBanner() => Container(
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppTheme.verdeChiaro.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14)),
    child: const Row(children: [
      Text('📲', style: TextStyle(fontSize: 24)),
      SizedBox(width: 8),
      Expanded(child: Text('Installa Fruttorto come app: menu del browser → "Aggiungi a schermata Home".',
          style: TextStyle(fontSize: 13))),
    ]),
  );

  Widget _contatori(GardenProvider g) {
    final voci = [
      ['🌱', 'Semenzaio', g.contaFase('semenzaio')],
      ['🌿', 'In Campo', g.contaFase('campo')],
      ['🧺', 'Raccolta', g.contaFase('raccolta')],
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        for (final v in voci)
          Expanded(child: Card(child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Text(v[0] as String, style: const TextStyle(fontSize: 28)),
              Text('${v[2]}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.verdeScuro)),
              Text(v[1] as String, style: const TextStyle(fontSize: 12, color: AppTheme.terra)),
            ]),
          ))),
      ]),
    );
  }

  Widget _meteoCard(MeteoProvider m, SettingsProvider s) => SectionCard(
    titolo: 'Meteo',
    child: m.loading
        ? const Center(child: CircularProgressIndicator())
        : m.meteo == null
            ? const Text('Imposta un appezzamento o una città manuale per il meteo.')
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🌡️ ${m.meteo!.temperaturaAria.toStringAsFixed(0)}°C aria · ${m.meteo!.temperaturaSuolo.toStringAsFixed(0)}°C suolo'),
                Text('💧 Umidità suolo: ${m.meteo!.umiditaSuolo.toStringAsFixed(0)}% · 🌧️ ${m.meteo!.pioggiaOggi} mm'),
                const SizedBox(height: 6),
                Text(m.meteo!.consiglioIrrigazione,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.verde)),
              ]),
  );

  Widget _situazioneCampo(List<dynamic> piante, Appezzamento a) {
    final attive = piante.where((p) => p.fase != 'raccolta').toList();
    if (attive.isEmpty) {
      return const SectionCard(titolo: 'Situazione Campo',
          child: EmptyState(emoji: '🍃', testoTecnico: 'Nessuna coltura attiva.',
              testoNarrativo: 'Il campo riposa. Ogni cosa a suo tempo.'));
    }
    final specie = attive.map((p) => p.coltura?.id).toSet().length;
    final perMese = <int, int>{};
    final perCat = <String, int>{};
    for (final p in attive) {
      final m = LogicaAgronomica.dataRaccoltaPrevista(p, a.zona).month;
      perMese[m] = (perMese[m] ?? 0) + 1;
      perCat[p.categoria] = (perCat[p.categoria] ?? 0) + 1;
    }
    final meseOro = perMese.entries.toList()..sort((x, y) => y.value.compareTo(x.value));
    const nomi = ['Gen','Feb','Mar','Apr','Mag','Giu','Lug','Ago','Set','Ott','Nov','Dic'];
    return SectionCard(titolo: 'Situazione Campo', child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('🐝 Biodiversità: $specie specie in coltura'),
        if (meseOro.isNotEmpty)
          Text('🏆 Mese d\'oro: ${nomi[meseOro.first.key - 1]} (${meseOro.first.value} raccolti)'),
        Text('📈 Prossimi raccolti: ${perMese.entries
            .map((e) => '${nomi[e.key - 1]}: ${e.value}').join(' · ')}'),
        const SizedBox(height: 6),
        Wrap(spacing: 6, children: [
          for (final c in perCat.entries) Chip(label: Text('${c.key} · ${c.value}')),
        ]),
      ]));
  }

  Widget _pacciamatura(Appezzamento a, AppezzamentoRepository repo) {
    if (a.pacciamaturaCm == null) {
      return Column(children: [
        const EmptyState(emoji: '🌾', testoTecnico: 'Non hai ancora misurato lo strato.',
            testoNarrativo: 'Una coperta di paglia è il primo gesto d\'amore per il suolo.'),
        ElevatedButton(onPressed: () => _misuraPacciamatura(a, repo), child: const Text('Inizia ora')),
      ]);
    }
    final giorni = DateTime.now().difference(a.pacciamaturaData!).inDays;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Spessore: ${a.pacciamaturaCm!.toStringAsFixed(0)} cm · misurato $giorni giorni fa'),
      if (giorni > 45) const Text('⏳ Decomposizione stimata: è ora di rabboccare.',
          style: TextStyle(color: AppTheme.terra, fontWeight: FontWeight.bold)),
      TextButton(onPressed: () => _misuraPacciamatura(a, repo), child: const Text('Aggiorna misura')),
    ]);
  }

  void _misuraPacciamatura(Appezzamento a, AppezzamentoRepository repo) {
    double cm = a.pacciamaturaCm ?? 10;
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, set) =>
      AlertDialog(title: const Text('Spessore pacciamatura'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('${cm.toStringAsFixed(0)} cm', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Slider(value: cm, min: 0, max: 40, divisions: 8,
              onChanged: (v) => set(() => cm = v)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
          ElevatedButton(onPressed: () async {
            await repo.aggiornaPacciamatura(a.id, cm);
            if (ctx.mounted) Navigator.pop(ctx);
          }, child: const Text('Salva')),
        ])));
  }
}
