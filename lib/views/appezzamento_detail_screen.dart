
import 'package:flutter/material.dart';
import 'package:myapp/models/appezzamento.dart';

class AppezzamentoDetailScreen extends StatelessWidget {
  final Appezzamento appezzamento;

  const AppezzamentoDetailScreen({super.key, required this.appezzamento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appezzamento.nome),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${appezzamento.nome}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Comune: ${appezzamento.comune}'),
            const SizedBox(height: 10),
            Text('Provincia: ${appezzamento.provincia}'),
          ],
        ),
      ),
    );
  }
}
