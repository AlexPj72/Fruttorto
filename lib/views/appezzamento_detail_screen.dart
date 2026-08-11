import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/appezzamento.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';

class AppezzamentoDetailScreen extends StatelessWidget {
  final String appezzamentoId;
  const AppezzamentoDetailScreen({super.key, required this.appezzamentoId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppezzamentoRepository>(
      builder: (context, repo, child) {
        // Dati non ancora arrivati da Firestore (es. refresh pagina appena fatto)
        if (repo.tuttiGliAppezzamenti.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        Appezzamento? appezzamento;
        for (final a in repo.tuttiGliAppezzamenti) {
          if (a.id == appezzamentoId) {
            appezzamento = a;
            break;
          }
        }

        if (appezzamento == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Non trovato')),
            body: const Center(
              child: Text('Appezzamento non trovato o non più disponibile.'),
            ),
          );
        }

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
                Text(
                  'Nome: ${appezzamento.nome}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Larghezza: ${appezzamento.larghezza != null ? '${appezzamento.larghezza} m' : 'non specificata'}'),
const SizedBox(height: 10),
Text('Lunghezza: ${appezzamento.lunghezza != null ? '${appezzamento.lunghezza} m' : 'non specificata'}'),
const SizedBox(height: 10),
                Text('Regione: ${appezzamento.regione}'),
                const SizedBox(height: 10),
                Text('Provincia: ${appezzamento.provincia}'),
                const SizedBox(height: 10),
                Text('Comune: ${appezzamento.comune}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
