import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pet_task_model.dart';
import '../services/pet_task_service.dart';

// Providers definidos fora do widget para evitar recriação
final petTaskServiceProvider = Provider<PetTaskService>((ref) {
  return PetTaskService();
});

final petTaskListProvider = StreamProvider.family<List<PetTask>, String>(
  (ref, petId) {
    final service = ref.watch(petTaskServiceProvider);
    return service.streamTasksForPet(petId);
  },
);

final petTaskCRUDProvider = Provider<PetTaskService>((ref) {
  return PetTaskService();
});

class PetTaskListWidget extends ConsumerWidget {
  final String petId;

  const PetTaskListWidget({super.key, required this.petId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(petTaskListProvider(petId));

    return tasksAsyncValue.when(
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
                'Tipo: ${task.type}, Vence: ${task.dueDate.toLocal().toString().split(' ')[0]}',
              ),
              trailing: Checkbox(
                value: task.done,
                onChanged: (newValue) {
                  final petTaskService = ref.read(petTaskCRUDProvider);
                  petTaskService
                      .updateTask(task.id, {'done': newValue ?? false});
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erro: $error')),
    );
  }
}
