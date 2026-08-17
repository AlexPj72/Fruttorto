import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/scheda_coltura.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';
import 'package:myapp/repositories/schede_colture_repository.dart';
import 'package:myapp/services/logica_agronomica.dart';
import 'package:myapp/theme/app_theme.dart';

class PianificaScreen extends StatefulWidget {
  const PianificaScreen({super.key});
  @override
  State<PianificaScreen> createState() => _PianificaScreenState();
}

class _PianificaScreenState extends State<PianificaScreen> {
  String? _filtroCategoria;
  ColturaBase? _colturaCalc;
  final _superficieCtrl = TextEditingController();
  static const _nomiMesi = ['Gen','Feb','Mar','Apr','Mag','Giu','Lug','Ago','Set','Ott','Nov','Dic'];

  @override
  Widget build(BuildContext context) {
    final zona = context.watch<AppezzamentoRepository>().appezzamentoAttivo.zona;
    final colture = SchedeColtureRepository.getColture()
        .where((c) => _filtroCategoria == null || c.categoria == _filtroCategoria)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Pianifica 🗺️')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('Catalogo Varietà', style: AppTheme.titoloSezione),
        const SizedBox(height: 8),
        Wrap(spacing: 6, children: [
          FilterChip(label: const Text('Tutte'), selected: _filtroCategoria == null,
              onSelected: (_) => setState(() => _filtroCategoria = null)),
          for (final cat in ['Frutto','Foglia','Radici & Bulbi','Legumi','Aromatiche'])
            FilterChip(label: Text(cat), selected: _filtroCategoria == cat,
                onSelected: (v) => setState(() => _filtroCategoria = v ? cat : null)),
        ]),
        const SizedBox(height: 12),
        for (final c in colture)
          Card(child: ExpansionTile(
            leading: Text(c.emoji, style: const TextStyle(fontSize: 30)),
            title: Text(c.nome),
            subtitle: Text('${c.categoria} · ${c.tipo} · acqua ${c.fabbisognoIdrico}'),
            children: [
              for (final v in SchedeColtureRepository.getVarietaPerColtura(c.id))
                ListTile(dense: true,
                  title: Text(v.nome),
                  subtitle: Text('~${(v.giorniCicloStandard * LogicaAgronomica.fattoreZona(zona)).round()} gg in zona ${zona ?? "—"} · ${v.segnaliRaccolta}')),
            ],
          )),
        const SizedBox(height: 20),
        Text('Calcolatore Fabbisogno', style: AppTheme.titoloSezione),
        const SizedBox(height: 8),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          DropdownButtonFormField<ColturaBase>(
            initialValue: _colturaCalc,
            decoration: const InputDecoration(labelText: 'Coltura'),
            items: [for (final c in SchedeColtureRepository.getColture())
              DropdownMenuItem(value: c, child: Text('${c.emoji} ${c.nome}'))],
            onChanged: (v) => setState(() => _colturaCalc = v)),
          TextField(controller: _superficieCtrl, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Superficie (m²)')),
          const SizedBox(height: 8),
          Builder(builder: (_) {
            final mq = double.tryParse(_superficieCtrl.text) ?? 0;
            if (_colturaCalc == null || mq <= 0) return const SizedBox.shrink();
            final piante = (mq * _colturaCalc!.piantePerMq).round();
            return Text('👉 ~$piante piante · ~${piante * 3} semi di margine · ${_colturaCalc!.piantePerMq}/m²',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.verdeScuro));
          }),
        ]))),
        const SizedBox(height: 20),
        Text('Calendario annuale semine (zona ${zona ?? "—"})', style: AppTheme.titoloSezione),
        const SizedBox(height: 8),
        for (int m = 1; m <= 12; m++) ...[
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_nomiMesi[m - 1], style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.verde)),
              Wrap(spacing: 6, children: [
                for (final c in SchedeColtureRepository.getColture()
                    .where((c) => LogicaAgronomica.mesiSeminaPerZona(c, zona).contains(m)))
                  Chip(avatar: Text(c.emoji), label: Text(c.nome)),
                if (!SchedeColtureRepository.getColture()
                    .any((c) => LogicaAgronomica.mesiSeminaPerZona(c, zona).contains(m)))
                  const Text('— riposo —', style: TextStyle(color: AppTheme.terra)),
              ]),
            ]))),
        ],
      ]),
    );
  }
}
