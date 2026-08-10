import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/garden_provider.dart';

class OrtoScreen extends StatelessWidget {
  const OrtoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gardenProvider = Provider.of<GardenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Il mio Orto / Frutteto 🌿'),
        backgroundColor: const Color(0xFF6B8E23),
        foregroundColor: Colors.white,
      ),
      body: gardenProvider.plants.isEmpty
          ? const Center(
              child: Text(
                'Il tuo orto è vuoto.\nClicca sul "+" per seminare o trapiantare!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              itemCount: gardenProvider.plants.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pianta = gardenProvider.plants[index];

                // Calcolo dei giorni passati dalla data di piantumazione
                final giorniPassati = DateTime.now()
                    .difference(pianta.plantedDate)
                    .inDays;

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: pianta.type == 'Ortaggio'
                          ? const Color(0xFF8FBC8F).withValues(alpha: 0.2)
                          : Colors.orange.withValues(alpha: 0.2),
                      child: Text(pianta.type == 'Ortaggio' ? '🥬' : '🍎'),
                    ),
                    title: Text(
                      pianta.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Metodo: ${pianta.cultivationMethod} ($giorniPassati giorni fa)',
                        ),
                        Text(
                          'Giorni rimasti al raccolto: ${pianta.daysRemaining}',
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            pianta.isWatered
                                ? Icons.water_drop
                                : Icons.water_drop_outlined,
                            color: pianta.isWatered ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            gardenProvider.waterPlant(
                              pianta.id,
                              pianta.isWatered,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            gardenProvider.removePlant(pianta.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6B8E23),
        foregroundColor: Colors.white,
        onPressed: () => _mostraPopUpInserimento(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- FUNZIONE POP-UP AGGIORNATA CON STRUTTURA IBRIDA ---
  void _mostraPopUpInserimento(BuildContext context) {
    final nameController = TextEditingController();
    String tipoSelezionato = 'Ortaggio';
    String metodoColtivazione = 'Semina';
    DateTime dataSelezionata = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.agriculture, color: Color(0xFF6B8E23)),
                  SizedBox(width: 8),
                  Text('Nuova Coltura'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input Nome Pianta
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome della pianta (es. Pomodoro)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Menu a tendina Tipo (DropdownButtonFormField)
                    DropdownButtonFormField<String>(
                      initialValue: tipoSelezionato,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tipo di Coltura',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Ortaggio',
                          child: Text('🥬 Ortaggio'),
                        ),
                        DropdownMenuItem(
                          value: 'Frutteto',
                          child: Text('🍎 Albero da Frutto'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => tipoSelezionato = value);
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Selettore Metodo Coltivazione (SegmentedButton)
                    const Text(
                      'Metodo di coltivazione:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment<String>(
                            value: 'Semina',
                            label: Text('Semina'),
                            icon: Icon(Icons.grass),
                          ),
                          ButtonSegment<String>(
                            value: 'Trapianto',
                            label: Text('Trapianto'),
                            icon: Icon(Icons.yard_outlined),
                          ),
                        ],
                        selected: {metodoColtivazione},
                        onSelectionChanged: (Set<String> newSelection) {
                          setDialogState(() {
                            metodoColtivazione = newSelection.first;
                          });
                        },
                        style: SegmentedButton.styleFrom(
                          selectedBackgroundColor: const Color(0xFF6B8E23),
                          selectedForegroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Selettore Data (ListTile + Calendario)
                    const Text(
                      'Quando lo hai fatto?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: Text(
                        'Data: ${dataSelezionata.day}/${dataSelezionata.month}/${dataSelezionata.year}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: const Icon(
                        Icons.calendar_month,
                        color: Color(0xFF6B8E23),
                      ),
                      tileColor: Colors.black12.withValues(alpha: 0.04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: dataSelezionata,
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != dataSelezionata) {
                          setDialogState(() => dataSelezionata = picked);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Annulla',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B8E23),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (nameController.text.trim().isNotEmpty) {
                      await Provider.of<GardenProvider>(
                        context,
                        listen: false,
                      ).addNewPlant(
                        name: nameController.text.trim(),
                        type: tipoSelezionato,
                        daysToHarvest: tipoSelezionato == 'Ortaggio' ? 60 : 180,
                        chosenDate: dataSelezionata,
                        method: metodoColtivazione,
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Salva nell\'Orto'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
