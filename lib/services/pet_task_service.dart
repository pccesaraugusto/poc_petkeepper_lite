import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_task_model.dart';

class PetTaskService {
  final CollectionReference petTasksCollection = FirebaseFirestore.instance
      .collection('pet_tasks');

  Stream<List<PetTask>> streamTasksForPet(String petId) {
    return petTasksCollection
        .where('petId', isEqualTo: petId)
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => PetTask.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addTask(PetTask task) async {
    try {
      await petTasksCollection.add(task.toMap());
    } catch (e) {
      throw Exception('Erro ao adicionar tarefa: $e');
    }
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      await petTasksCollection.doc(taskId).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await petTasksCollection.doc(taskId).delete();
    } catch (e) {
      throw Exception('Erro ao excluir tarefa: $e');
    }
  }
}
