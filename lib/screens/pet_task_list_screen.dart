import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/pet_task_model.dart';
import '../services/pet_task_service.dart';

class PetTaskListScreen extends StatelessWidget {
  final Pet pet;
  const PetTaskListScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final petTaskService = PetTaskService();

    return Scaffold(
      appBar: AppBar(title: Text('Tarefas de ${pet.name}')),
      body: StreamBuilder<List<PetTask>>(
        stream: petTaskService.streamTasksForPet(pet.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa cadastrada.'));
          }
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
                onLongPress: () async {
                  final confirm = await showConfirmDialog(
                    context,
                    'Excluir tarefa',
                    'Deseja realmente excluir a tarefa "${task.title}"?',
                  );
                  if (confirm == true) {
                    try {
                      await petTaskService.deleteTask(task.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tarefa removida')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao remover: $e')),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_pet_task', arguments: pet);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
