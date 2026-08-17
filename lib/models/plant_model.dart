import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/schede_colture_repository.dart';
import '../models/scheda_coltura.dart';

class PlantModel {
  final String id, appezzamentoId, varietaId, cultivationMethod;
  final String fase; // 'semenzaio' | 'campo' | 'raccolta'
  final DateTime plantedDate;
  final bool isWatered;

  PlantModel({required this.id, required this.appezzamentoId, required this.varietaId,
    required this.plantedDate, this.isWatered = false,
    this.cultivationMethod = 'Semina', this.fase = 'semenzaio'});

  Varieta? get varieta => SchedeColtureRepository.getVarietaById(varietaId);
  ColturaBase? get coltura => SchedeColtureRepository.getColturaPerVarieta(varietaId);
  String get nome => '${varieta?.nome ?? ''} · ${coltura?.nome ?? ''}';
  String get emoji => coltura?.emoji ?? '🌱';
  String get categoria => coltura?.categoria ?? 'Altro';

  factory PlantModel.fromMap(Map<String, dynamic> m, String id) => PlantModel(
    id: id,
    appezzamentoId: m['appezzamentoId'] ?? '',
    varietaId: m['varietaId'] ?? '',
    plantedDate: (m['plantedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    isWatered: m['isWatered'] ?? false,
    cultivationMethod: m['cultivationMethod'] ?? 'Semina',
    fase: m['fase'] ?? 'semenzaio',
  );

  Map<String, dynamic> toMap() => {
    'appezzamentoId': appezzamentoId, 'varietaId': varietaId,
    'plantedDate': Timestamp.fromDate(plantedDate), 'isWatered': isWatered,
    'cultivationMethod': cultivationMethod, 'fase': fase,
  };
}
