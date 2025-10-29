import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/pet_model.dart';
import '../models/pet_task_model.dart';
import '../services/pet_task_service.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;
  const PetDetailScreen({super.key, required this.pet});

  Future<void> _notifyFamily(BuildContext context) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'notifyFamily',
    );
    try {
      final result = await callable.call({
        'petId': pet.id,
        'message': 'Nova vacina ou tarefa para ${pet.name}',
      });
      if ((result.data['success'] as bool) == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Família notificada!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao enviar notificação: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final petTaskService = PetTaskService();

    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: pet.photoUrl != null
                ? Image.network(pet.photoUrl!)
                : const Icon(Icons.pets),
            title: Text(
              pet.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Espécie: ${pet.species}\nPeso: ${pet.weightKg} kg\nNascimento: ${pet.birthDate.toLocal().toIso8601String().substring(0, 10)}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () => _notifyFamily(context),
              child: const Text('Avisar Família'),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Vacinas e Tarefas:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<PetTask>>(
              stream: petTaskService.streamTasksForPet(pet.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                final tasks = snapshot.data ?? [];
                if (tasks.isEmpty)
                  return const Center(
                    child: Text('Nenhuma vacina ou tarefa cadastrada.'),
                  );
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(
                        'Tipo: ${task.type}, Vence: ${task.dueDate.toLocal().toIso8601String().substring(0, 10)}',
                      ),
                      trailing: Checkbox(
                        value: task.done,
                        onChanged: (value) {
                          petTaskService.updateTask(task.id, {
                            'done': value ?? false,
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_pet_task', arguments: pet);
              },
              child: const Text('Adicionar Vacina/Tarefa'),
            ),
          ),
        ],
      ),
    );
  }
}
