import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pet_model.dart';
import '../models/pet_task_model.dart';
import '../providers/pet_task_provider.dart';

class AddPetTaskScreen extends ConsumerStatefulWidget {
  final Pet? pet; // Agora opcional
  const AddPetTaskScreen({super.key, this.pet});

  @override
  ConsumerState<AddPetTaskScreen> createState() => _AddPetTaskScreenState();
}

class _AddPetTaskScreenState extends ConsumerState<AddPetTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  String _type = 'vaccine';
  DateTime? _dueDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Você pode inicializar algo aqui se necessário
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() => _isSubmitting = true);

    Pet? petActual =
        widget.pet ?? ModalRoute.of(context)?.settings.arguments as Pet?;
    if (petActual == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pet não selecionado')));
      setState(() => _isSubmitting = false);
      return;
    }

    final task = PetTask(
      id: '',
      petId: petActual.id,
      type: _type,
      title: _titleController.text.trim(),
      dueDate: _dueDate!,
      notes: _notesController.text.trim(),
      createdBy: 'userId', // TODO: pegar do auth real
      createdAt: DateTime.now(),
      done: false,
    );

    try {
      final petTaskService = ref.read(petTaskServiceProvider);
      await petTaskService.addTask(task);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar tarefa: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Pet? petActual =
        widget.pet ?? ModalRoute.of(context)?.settings.arguments as Pet?;
    final petName = petActual?.name ?? 'Novo Pet';

    return Scaffold(
      appBar: AppBar(title: Text('Nova Tarefa para $petName')),
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
                      value: 'grooming', child: Text('Banho/Tosa')),
                  DropdownMenuItem(value: 'other', child: Text('Outro')),
                ],
                onChanged: (val) => setState(() => _type = val!),
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
                    child: Text(_dueDate == null
                        ? 'Data de vencimento não selecionada'
                        : 'Vence em: ${_dueDate!.toLocal().toString().split(' ')[0]}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) setState(() => _dueDate = date);
                    },
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
