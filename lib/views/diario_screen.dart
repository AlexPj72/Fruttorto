import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/repositories/diario_repository.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/views/widgets/empty_state.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});
  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  final _repo = DiarioRepository();
  int? _anno; int _mese = 0;
  static const _nomi = ['Tutto','Gen','Feb','Mar','Apr','Mag','Giu','Lug','Ago','Set','Ott','Nov','Dic'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diario di Campo 📖')),
      body: StreamBuilder<List<dynamic>>(
        stream: _repo.stream(),
        builder: (ctx, snap) {
          final tutti = snap.data ?? [];
          final anni = tutti.map((e) => e.data.year).toSet().toList()..sort();
          _anno ??= DateTime.now().year;
          final voci = tutti.where((e) =>
              (_anno == null || e.data.year == _anno) && (_mese == 0 || e.data.month == _mese)).toList();

          return Column(children: [
            Padding(padding: const EdgeInsets.all(12), child: Row(children: [
              Expanded(child: DropdownButtonFormField<int>(
                initialValue: _anno, decoration: const InputDecoration(labelText: 'Anno'),
                items: [for (final a in anni) DropdownMenuItem(value: a, child: Text('$a'))],
                onChanged: (v) => setState(() => _anno = v))),
              const SizedBox(width: 12),
              Expanded(child: DropdownButtonFormField<int>(
                initialValue: _mese, decoration: const InputDecoration(labelText: 'Mese'),
                items: [for (int i = 0; i <= 12; i++) DropdownMenuItem(value: i, child: Text(_nomi[i]))],
                onChanged: (v) => setState(() => _mese = v!))),
            ])),
            Expanded(child: voci.isEmpty
                ? const EmptyState(emoji: '📝',
                    testoTecnico: 'Nessuna voce nel periodo.',
                    testoNarrativo: 'Le pagine bianche sono semi che aspettano.')
                : ListView.separated(
                    padding: const EdgeInsets.all(16), itemCount: voci.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final e = voci[i];
                      return Card(child: e.tipo == 'foto'
                          ? Column(children: [
                              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                  child: Image.network(e.fotoUrl!, height: 180, width: double.infinity, fit: BoxFit.cover)),
                              Padding(padding: const EdgeInsets.all(12),
                                  child: Row(children: [
                                    Expanded(child: Text(e.testo)),
                                    Text('${e.data.day}/${e.data.month}', style: const TextStyle(color: AppTheme.terra)),
                                  ])),
                            ])
                          : ListTile(
                              leading: const Icon(Icons.edit_note, color: AppTheme.verde),
                              title: Text(e.testo),
                              subtitle: Text('${e.data.day}/${e.data.month}/${e.data.year}'),
                              trailing: IconButton(icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _repo.elimina(e.id))));
                  })),
          ]);
        }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.verdeScuro, foregroundColor: Colors.white,
        onPressed: () => _menuAggiunta(), child: const Icon(Icons.add)),
    );
  }

  void _menuAggiunta() => showModalBottomSheet(context: context, builder: (ctx) => SafeArea(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(leading: const Icon(Icons.edit_note), title: const Text('Scrivi una nota'),
          onTap: () { Navigator.pop(ctx); _nuovaNota(); }),
      ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Diario visivo: scatta una foto'),
          onTap: () { Navigator.pop(ctx); _nuovaFoto(); }),
    ])));

  void _nuovaNota() {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Nuova nota'),
      content: TextField(controller: ctrl, maxLines: 3,
          decoration: const InputDecoration(hintText: 'Osservazioni, eventi, intuizioni…')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
        ElevatedButton(onPressed: () async {
          if (ctrl.text.trim().isNotEmpty) await _repo.aggiungiNota(ctrl.text.trim());
          if (ctx.mounted) Navigator.pop(ctx);
        }, child: const Text('Salva')),
      ]));
  }

  Future<void> _nuovaFoto() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
    if (img == null) return;
    final Uint8List bytes = await img.readAsBytes();
    await _repo.aggiungiFoto(bytes, 'Foto del ${DateTime.now().day}/${DateTime.now().month}');
  }
}
