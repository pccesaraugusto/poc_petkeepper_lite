import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pet_task_provider.dart';
import '../models/pet_model.dart';

class PetTaskListScreen extends ConsumerWidget {
  final Pet pet;
  const PetTaskListScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(petTaskListProvider(pet.id));

    return Scaffold(
      appBar: AppBar(title: Text('Tarefas de ${pet.name}')),
      body: tasksAsyncValue.when(
        data: (tasks) {
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
                  'Tipo: ${task.type}, Vence: '
                  '${task.dueDate.toLocal().toString().split(' ')[0]}',
                ),
                trailing: Checkbox(
                  value: task.done,
                  onChanged: (value) {
                    ref.read(petTaskServiceProvider).updateTask(task.id, {
                      'done': value ?? false,
                    });
                  },
                ),
                onLongPress: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Excluir tarefa'),
                      content: Text('Deseja excluir a tarefa "${task.title}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Confirmar'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    try {
                      await ref
                          .read(petTaskServiceProvider)
                          .deleteTask(task.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tarefa removida')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
                    }
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
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
