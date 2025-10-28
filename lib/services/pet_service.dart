import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

class PetService {
  final CollectionReference petsCollection = FirebaseFirestore.instance
      .collection('pets');

  Stream<List<Pet>> streamPets(String familyCode) {
    return petsCollection
        .where('familyCode', isEqualTo: familyCode)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Pet.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addPet(Pet pet) async {
    try {
      await petsCollection.add(pet.toMap());
    } catch (e) {
      throw Exception('Erro ao adicionar pet: $e');
    }
  }

  Future<void> updatePet(String petId, Map<String, dynamic> data) async {
    try {
      await petsCollection.doc(petId).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar pet: $e');
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await petsCollection.doc(petId).delete();
    } catch (e) {
      throw Exception('Erro ao excluir pet: $e');
    }
  }
}
