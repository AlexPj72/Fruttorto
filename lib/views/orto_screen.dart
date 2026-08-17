import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/scheda_coltura.dart';
import 'package:myapp/providers/garden_provider.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';
import 'package:myapp/repositories/schede_colture_repository.dart';
import 'package:myapp/services/logica_agronomica.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/views/widgets/add_appezzamento_dialog.dart';
import 'package:myapp/views/widgets/empty_state.dart';

class OrtoScreen extends StatelessWidget {
  const OrtoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<AppezzamentoRepository>();
    final garden = context.watch<GardenProvider>();
    final a = repo.appezzamentoAttivo;
    final piante = garden.plants.where((p) => p.appezzamentoId == a.id).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Il Mio Orto 🌿')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Wrap(spacing: 6, children: [
          for (final ap in repo.tuttiGliAppezzamenti)
            ChoiceChip(
              label: Text(ap.nome), selected: ap.id == a.id,
              onSelected: (_) => repo.impostaAppezzamentoAttivo(ap)),
          ActionChip(avatar: const Icon(Icons.add, size: 16), label: const Text('Nuovo'),
              onPressed: () => showDialog(context: context,
                  builder: (_) => const AddAppezzamentoDialog())),
        ]),
        const SizedBox(height: 12),
        TextButton(onPressed: () => context.push('/orto/appezzamento/${a.id}'),
            child: Text('${a.comune} · ${a.provincia} · zona ${a.zona ?? "—"} → dettaglio')),
        const SizedBox(height: 8),
        if (piante.isEmpty)
          const EmptyState(emoji: '🌾',
            testoTecnico: 'Nessuna coltura in questo appezzamento.',
            testoNarrativo: 'La terra aspetta, paziente. Il primo seme è una promessa.'),
        for (final p in piante)
          Card(child: ListTile(
            leading: Text(p.emoji, style: const TextStyle(fontSize: 30)),
            title: Text(p.nome),
            subtitle: Text('${p.cultivationMethod} · ${p.fase.toUpperCase()} · raccolto tra ${LogicaAgronomica.giorniRimasti(p, a.zona)} gg'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: Icon(p.isWatered ? Icons.water_drop : Icons.water_drop_outlined,
                  color: p.isWatered ? Colors.blue : Colors.grey),
                  onPressed: () => garden.waterPlant(p.id, p.isWatered)),
              _faseButton(p, garden),
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => garden.removePlant(p.id)),
            ]),
          )),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.verdeScuro, foregroundColor: Colors.white,
        onPressed: () => _aggiungiColtura(context, a.id),
        child: const Icon(Icons.add)),
    );
  }

  Widget _faseButton(dynamic p, GardenProvider g) {
    final prossima = p.fase == 'semenzaio' ? 'campo' : (p.fase == 'campo' ? 'raccolta' : null);
    if (prossima == null) return const Icon(Icons.check_circle, color: AppTheme.verde);
    return TextButton(
      onPressed: () => g.setFase(p.id, prossima),
      child: Text(prossima == 'campo' ? '→ Campo' : '→ Raccolta'));
  }

  void _aggiungiColtura(BuildContext context, String appezzamentoId) {
    ColturaBase? coltura; Varieta? varieta;
    String metodo = 'Semina'; DateTime data = DateTime.now();
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, set) =>
      AlertDialog(title: const Text('Nuova coltura'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<ColturaBase>(
            initialValue: coltura, decoration: const InputDecoration(labelText: 'Coltura base'),
            items: [for (final c in SchedeColtureRepository.getColture())
              DropdownMenuItem(value: c, child: Text('${c.emoji} ${c.nome}'))],
            onChanged: (v) => set(() { coltura = v; varieta = null; })),
          if (coltura != null)
            DropdownButtonFormField<Varieta>(
              initialValue: varieta, decoration: const InputDecoration(labelText: 'Varietà'),
              items: [for (final v in SchedeColtureRepository.getVarietaPerColtura(coltura!.id))
                DropdownMenuItem(value: v, child: Text(v.nome))],
              onChanged: (v) => set(() => varieta = v)),
          SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'Semina', label: Text('Semina')),
                            ButtonSegment(value: 'Trapianto', label: Text('Trapianto'))],
            selected: {metodo},
            onSelectionChanged: (s) => set(() => metodo = s.first)),
          ListTile(dense: true,
            title: Text('${data.day}/${data.month}/${data.year}'),
            trailing: const Icon(Icons.calendar_month),
            onTap: () async {
              final d = await showDatePicker(context: ctx, initialDate: data,
                  firstDate: DateTime(2024), lastDate: DateTime.now());
              if (d != null) set(() => data = d);
            }),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
          ElevatedButton(onPressed: varieta == null ? null : () async {
            await context.read<GardenProvider>().addNewPlant(
              appezzamentoId: appezzamentoId, varietaId: varieta!.id,
              chosenDate: data, method: metodo);
            if (ctx.mounted) Navigator.pop(ctx);
          }, child: const Text('Pianta')),
        ])));
  }
}
