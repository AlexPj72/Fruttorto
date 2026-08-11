import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/appezzamento.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';
import 'package:myapp/services/geo_service.dart';

class AddAppezzamentoDialog extends StatefulWidget {
  const AddAppezzamentoDialog({super.key});
  @override
  _AddAppezzamentoDialogState createState() => _AddAppezzamentoDialogState();
}

class _AddAppezzamentoDialogState extends State<AddAppezzamentoDialog> {
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  double? _larghezza;
  double? _lunghezza;

  String? _regioneSelezionata;
  String? _provinciaSelezionata;
  String? _comuneSelezionato;

  List<String> _regioni = [];
  List<String> _province = [];
  List<String> _comuni = [];

  bool _caricamentoIniziale = true;
  bool _salvataggioInCorso = false;

  @override
  void initState() {
    super.initState();
    _caricaRegioni();
  }

  Future<void> _caricaRegioni() async {
    final regioni = await GeoService.getRegioni();
    setState(() {
      _regioni = regioni;
      _caricamentoIniziale = false;
    });
  }

  Future<void> _onRegioneCambiata(String? regione) async {
    if (regione == null) return;
    final province = await GeoService.getProvince(regione);
    setState(() {
      _regioneSelezionata = regione;
      _province = province;
      _provinciaSelezionata = null;
      _comuni = [];
      _comuneSelezionato = null;
    });
  }

  Future<void> _onProvinciaCambiata(String? provincia) async {
    if (provincia == null) return;
    final comuni = await GeoService.getComuni(provincia);
    setState(() {
      _provinciaSelezionata = provincia;
      _comuni = comuni;
      _comuneSelezionato = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_caricamentoIniziale) {
      return const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return AlertDialog(
      title: const Text('Nuovo Appezzamento'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Inserisci un nome' : null,
                onSaved: (value) => _nome = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Larghezza (metri) - facoltativo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  return double.tryParse(value) == null ? 'Inserisci un numero valido' : null;
                },
                onSaved: (value) => _larghezza = (value == null || value.isEmpty) ? null : double.parse(value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Lunghezza (metri) - facoltativo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  return double.tryParse(value) == null ? 'Inserisci un numero valido' : null;
                },
                onSaved: (value) => _lunghezza = (value == null || value.isEmpty) ? null : double.parse(value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _regioneSelezionata,
                decoration: const InputDecoration(labelText: 'Regione'),
                items: _regioni.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: _onRegioneCambiata,
                validator: (value) => value == null ? 'Seleziona una regione' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _provinciaSelezionata,
                decoration: const InputDecoration(labelText: 'Provincia'),
                items: _province.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: _province.isEmpty ? null : _onProvinciaCambiata,
                validator: (value) => value == null ? 'Seleziona una provincia' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _comuneSelezionato,
                decoration: const InputDecoration(labelText: 'Comune'),
                items: _comuni.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: _comuni.isEmpty ? null : (value) => setState(() => _comuneSelezionato = value),
                validator: (value) => value == null ? 'Seleziona un comune' : null,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annulla'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Salva'),
          onPressed: _salvataggioInCorso ? null : () => _salva(context),
        ),
      ],
    );
  }

  Future<void> _salva(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utente non autenticato. Riprova.')),
      );
      return;
    }

    setState(() => _salvataggioInCorso = true);

    final nuovoAppezzamento = Appezzamento(
      id: '',
      nome: _nome,
      larghezza: _larghezza,
      lunghezza: _lunghezza,
      regione: _regioneSelezionata!,
      provincia: _provinciaSelezionata!,
      comune: _comuneSelezionato!,
      userId: user.uid,
    );

    await Provider.of<AppezzamentoRepository>(context, listen: false)
        .aggiungiAppezzamento(nuovoAppezzamento);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
