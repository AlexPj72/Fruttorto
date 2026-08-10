import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/viewmodels/home_viewmodel.dart';

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
  String _comune = '';
  String _provincia = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuovo Appezzamento'),
      content: Form(
        key: _formKey,
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
              decoration: const InputDecoration(labelText: 'Comune'),
              onSaved: (value) => _comune = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Provincia'),
              onSaved: (value) => _provincia = value!,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annulla'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Salva'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Provider.of<HomeViewModel>(context, listen: false).addAppezzamento(_nome, _larghezza, _lunghezza, _comune, _provincia);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
