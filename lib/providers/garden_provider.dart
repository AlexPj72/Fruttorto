import 'dart:async';
import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../repositories/plant_repository.dart';

class GardenProvider with ChangeNotifier {
  final PlantRepository _plantRepository = PlantRepository();
  List<PlantModel> _plants = [];
  StreamSubscription<List<PlantModel>>? _plantsSubscription;

  List<PlantModel> get plants => _plants;

  GardenProvider() {
    initGarden();
  }

  void initGarden() {
    _plantsSubscription?.cancel();
    _plantsSubscription = _plantRepository.streamPlants().listen((
      updatedPlants,
    ) {
      _plants = updatedPlants;
      notifyListeners();
    });
  }

  // Riceve la data personalizzata e il metodo scelti dall'utente
  Future<void> addNewPlant({
    required String appezzamentoId,
    required String varietaId,
    required DateTime chosenDate,
    String method = 'Semina',
  }) async {
    final newPlant = PlantModel(
      id: '',
      appezzamentoId: appezzamentoId,
      varietaId: varietaId,
      plantedDate: chosenDate,
      cultivationMethod: method,
    );
    await _plantRepository.addPlant(newPlant);
  }

  Future<void> waterPlant(String plantId, bool currentStatus) async {
    await _plantRepository.toggleWatered(plantId, currentStatus);
  }

  Future<void> removePlant(String plantId) async {
    await _plantRepository.deletePlant(plantId);
  }

  Future<void> setFase(String plantId, String fase) =>
      _plantRepository.setFase(plantId, fase);

  List<PlantModel> piantePerAppezzamento(String id) =>
      _plants.where((p) => p.appezzamentoId == id).toList();

  int contaFase(String fase) => _plants.where((p) => p.fase == fase).length;

  @override
  void dispose() {
    _plantsSubscription?.cancel();
    super.dispose();
  }
}
