import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/plant_model.dart';

class PlantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Ottiene il percorso della collezione di piante dell'utente corrente
  CollectionReference? get _plantsCollection {
    final user = _auth.currentUser;
    if (user == null) return null;
    // Salva le piante dentro la sotto-collezione dell'utente
    return _firestore.collection('users').doc(user.uid).collection('plants');
  }

  // STREAM: Ottiene l'elenco delle piante in tempo reale
  Stream<List<PlantModel>> streamPlants() {
    final collection = _plantsCollection;
    if (collection == null) return Stream.value([]);

    return collection
        .orderBy('plantedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PlantModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Aggiunge una nuova pianta
  Future<void> addPlant(PlantModel plant) async {
    final collection = _plantsCollection;
    if (collection != null) {
      await collection.add(plant.toMap());
    }
  }

  // Cambia lo stato di irrigazione (Acceso/Spento)
  Future<void> toggleWatered(String plantId, bool currentStatus) async {
    final collection = _plantsCollection;
    if (collection != null) {
      await collection.doc(plantId).update({'isWatered': !currentStatus});
    }
  }

  // Elimina una pianta
  Future<void> deletePlant(String plantId) async {
    final collection = _plantsCollection;
    if (collection != null) {
      await collection.doc(plantId).delete();
    }
  }
}