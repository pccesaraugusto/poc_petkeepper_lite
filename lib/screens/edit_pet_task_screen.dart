import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pet_task_model.dart';
import '../providers/pet_task_provider.dart';

class EditPetTaskScreen extends ConsumerStatefulWidget {
  final PetTask task;
  const EditPetTaskScreen({super.key, required this.task});

  @override
  ConsumerState<EditPetTaskScreen> createState() => _EditPetTaskScreenState();
}

class _EditPetTaskScreenState extends ConsumerState<EditPetTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late String _type;
  late DateTime _dueDate;
  bool _done = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _notesController = TextEditingController(text: widget.task.notes);
    _type = widget.task.type;
    _dueDate = widget.task.dueDate;
    _done = widget.task.done;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha corretamente os campos')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final petTaskService = ref.read(petTaskServiceProvider);
      final data = {
        'type': _type,
        'title': _titleController.text.trim(),
        'notes': _notesController.text.trim(),
        'dueDate': _dueDate,
        'done': _done,
      };
      await petTaskService.updateTask(widget.task.id, data);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar tarefa: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Vacina/Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'vaccine', child: Text('Vacina')),
                  DropdownMenuItem(
                    value: 'grooming',
                    child: Text('Banho/Tosa'),
                  ),
                  DropdownMenuItem(value: 'other', child: Text('Outro')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _type = val);
                },
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notas'),
                maxLines: 3,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vence em: ${_dueDate.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) setState(() => _dueDate = date);
                    },
                    child: const Text('Alterar Data'),
                  ),
                ],
              ),
              CheckboxListTile(
                title: const Text('Concluído'),
                value: _done,
                onChanged: (bool? value) {
                  setState(() {
                    _done = value ?? false;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
