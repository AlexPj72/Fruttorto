import 'package:cloud_firestore/cloud_firestore.dart';

class PlantModel {
  final String id;
  final String name;
  final String type; // es. "Ortaggio", "Frutteto"
  final DateTime plantedDate; // Sarà impostabile a piacimento
  final int daysToHarvest;
  final bool isWatered;
  final String cultivationMethod; // NUOVO: "Semina" o "Trapianto"

  PlantModel({
    required this.id,
    required this.name,
    required this.type,
    required this.plantedDate,
    required this.daysToHarvest,
    this.isWatered = false,
    required this.cultivationMethod, // Obbligatorio
  });

  factory PlantModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PlantModel(
      id: documentId,
      name: map['name'] ?? '',
      type: map['type'] ?? 'Ortaggio',
      plantedDate: (map['plantedDate'] as Timestamp).toDate(),
      daysToHarvest: map['daysToHarvest'] ?? 0,
      isWatered: map['isWatered'] ?? false,
      cultivationMethod:
          map['cultivationMethod'] ?? 'Semina', // Default di sicurezza
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'plantedDate': Timestamp.fromDate(plantedDate),
      'daysToHarvest': daysToHarvest,
      'isWatered': isWatered,
      'cultivationMethod': cultivationMethod,
    };
  }

  // Calcola i giorni rimanenti calcolando la differenza dalla plantedDate reale
  int get daysRemaining {
    final harvestDate = plantedDate.add(Duration(days: daysToHarvest));
    final difference = harvestDate.difference(DateTime.now()).inDays;
    return difference < 0 ? 0 : difference;
  }
}
