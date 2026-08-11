import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/appezzamento.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';

class AddAppezzamentoDialog extends StatefulWidget {
  const AddAppezzamentoDialog({super.key});
  @override
  _AddAppezzamentoDialogState createState() => _AddAppezzamentoDialogState();
}

class _AddAppezzamentoDialogState extends State<AddAppezzamentoDialog> {
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  double _larghezza = 0.0;
  double _lunghezza = 0.0;
  String _regione = '';
  String _provincia = '';
  String _comune = '';
  bool _salvataggioInCorso = false;

  @override
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(labelText: 'Larghezza (metri)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || double.tryParse(value) == null ? 'Inserisci un numero valido' : null,
                onSaved: (value) => _larghezza = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Lunghezza (metri)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || double.tryParse(value) == null ? 'Inserisci un numero valido' : null,
                onSaved: (value) => _lunghezza = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Regione'),
                validator: (value) => value == null || value.isEmpty ? 'Inserisci una regione' : null,
                onSaved: (value) => _regione = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Provincia'),
                validator: (value) => value == null || value.isEmpty ? 'Inserisci una provincia' : null,
                onSaved: (value) => _provincia = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Comune'),
                validator: (value) => value == null || value.isEmpty ? 'Inserisci un comune' : null,
                onSaved: (value) => _comune = value!,
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
      id: '', // ignorato da Firestore in fase di add, verrà generato automaticamente
      nome: _nome,
      larghezza: _larghezza,
      lunghezza: _lunghezza,
      regione: _regione,
      provincia: _provincia,
      comune: _comune,
      userId: user.uid,
    );

    await Provider.of<AppezzamentoRepository>(context, listen: false)
        .aggiungiAppezzamento(nuovoAppezzamento);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
