import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/appezzamento.dart';
import 'package:myapp/viewmodels/hoimport 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/appezzamento.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';
import 'package:myapp/views/widgets/add_appezzamento_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppezzamentoRepository>(
      builder: (context, repo, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('I Miei Appezzamenti'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _mostraDialogAggiungi(context, repo),
                tooltip: 'Aggiungi appezzamento',
              ),
            ],
          ),
          body: Column(
            children: [
              _buildSelettoreAttivo(context, repo),
              const Divider(height: 1),
              Expanded(child: _buildListaAppezzamenti(context, repo)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _mostraDialogAggiungi(context, repo),
            label: const Text('Nuovo Appezzamento'),
            icon: const Icon(Icons.add),
            backgroundColor: const Color(0xFF6B8E23),
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildSelettoreAttivo(BuildContext context, AppezzamentoRepository repo) {
    final lista = repo.tuttiGliAppezzamenti;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<Appezzamento>(
        initialValue: lista.isEmpty ? null : repo.appezzamentoAttivo,
        decoration: InputDecoration(
          labelText: 'Appezzamento Attivo',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: lista.map((appezzamento) {
          return DropdownMenuItem<Appezzamento>(
            value: appezzamento,
            child: Text(
              appezzamento.nome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
        onChanged: (appezzamento) {
          if (appezzamento != null) {
            repo.impostaAppezzamentoAttivo(appezzamento);
          }
        },
      ),
    );
  }

  Widget _buildListaAppezzamenti(BuildContext context, AppezzamentoRepository repo) {
    final lista = repo.tuttiGliAppezzamenti;
    if (lista.isEmpty) {
      return const Center(child: Text('Nessun appezzamento. Aggiungine uno!'));
    }
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final appezzamento = lista[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withAlpha(25),
              child: const Icon(Icons.grass, color: Color(0xFF6B8E23)),
            ),
            title: Text(appezzamento.nome),
            subtitle: Text('${appezzamento.comune}, ${appezzamento.provincia}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Elimina appezzamento',
                  onPressed: () => _mostraDialogConfermaEliminazione(context, repo, appezzamento),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
            onTap: () => context.go('/details/${appezzamento.id}'),
          ),
        );
      },
    );
  }

  void _mostraDialogAggiungi(BuildContext context, AppezzamentoRepository repo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: repo,
          child: const AddAppezzamentoDialog(),
        );
      },
    );
  }

  void _mostraDialogConfermaEliminazione(
      BuildContext context, AppezzamentoRepository repo, Appezzamento appezzamento) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Conferma Eliminazione'),
          content: Text(
              'Sei sicuro di voler eliminare l\'appezzamento "${appezzamento.nome}"? L\'azione non può essere annullata.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Elimina'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await repo.rimuoviAppezzamento(appezzamento.id);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Appezzamento "${appezzamento.nome}" eliminato.'),
                      backgroundColor: Colors.black87,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}me_viewmodel.dart';
import 'package:myapp/views/widgets/add_appezzamento_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('I Miei Appezzamenti'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _mostraDialogAggiungi(context, viewModel),
                tooltip: 'Aggiungi appezzamento',
              ),
            ],
          ),
          body: Column(
            children: [
              _buildSelettoreAttivo(context, viewModel),
              const Divider(height: 1),
              Expanded(child: _buildListaAppezzamenti(context, viewModel)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _mostraDialogAggiungi(context, viewModel),
            label: const Text('Nuovo Appezzamento'),
            icon: const Icon(Icons.add),
            backgroundColor: const Color(0xFF6B8E23),
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildSelettoreAttivo(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<Appezzamento>(
        initialValue: viewModel.appezzamenti.isEmpty ? null : viewModel.appezzamentoAttivo,
        decoration: InputDecoration(
          labelText: 'Appezzamento Attivo',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: viewModel.appezzamenti.map((appezzamento) {
          return DropdownMenuItem<Appezzamento>(
            value: appezzamento,
            child: Text(
              appezzamento.nome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
        onChanged: (appezzamento) =>
            viewModel.cambiaAppezzamentoAttivo(appezzamento),
      ),
    );
  }

  Widget _buildListaAppezzamenti(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.appezzamenti.isEmpty) {
      return const Center(child: Text('Nessun appezzamento. Aggiungine uno!'));
    }
    return ListView.builder(
      itemCount: viewModel.appezzamenti.length,
      itemBuilder: (context, index) {
        final appezzamento = viewModel.appezzamenti[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withAlpha(25),
              child: const Icon(Icons.grass, color: Color(0xFF6B8E23)),
            ),
            title: Text(appezzamento.nome),
            subtitle: Text('${appezzamento.comune}, ${appezzamento.provincia}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Elimina appezzamento',
                  onPressed: () => _mostraDialogConfermaEliminazione(context, viewModel, appezzamento),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
            onTap: () => context.go('/details', extra: appezzamento),
          ),
        );
      },
    );
  }

  void _mostraDialogAggiungi(BuildContext context, HomeViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          child: const AddAppezzamentoDialog(),
        );
      },
    );
  }

  void _mostraDialogConfermaEliminazione(
      BuildContext context, HomeViewModel viewModel, Appezzamento appezzamento) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Conferma Eliminazione'),
          content: Text(
              'Sei sicuro di voler eliminare l\'appezzamento "${appezzamento.nome}"? L\'azione non può essere annullata.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Elimina'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await viewModel.eliminaAppezzamento(appezzamento.id);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Appezzamento "${appezzamento.nome}" eliminato.'),
                      backgroundColor: Colors.black87,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
