import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/pet_task_model.dart';
import '../services/pet_task_service.dart';

class AddPetTaskScreen extends StatefulWidget {
  final Pet pet;
  const AddPetTaskScreen({super.key, required this.pet});

  @override
  State<AddPetTaskScreen> createState() => _AddPetTaskScreenState();
}

class _AddPetTaskScreenState extends State<AddPetTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  String _type = 'vaccine';
  DateTime? _dueDate;
  bool _isSubmitting = false;

  void _submit() async {
    if (!_formKey.currentState!.validate() || _dueDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }
    setState(() => _isSubmitting = true);

    final task = PetTask(
      id: '',
      petId: widget.pet.id,
      type: _type,
      title: _titleController.text.trim(),
      dueDate: _dueDate!,
      notes: _notesController.text.trim(),
      createdBy: 'userId', // TODO pegar do auth
      createdAt: DateTime.now(),
      done: false,
    );

    try {
      await PetTaskService().addTask(task);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao adicionar tarefa: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Vacina/Tarefa para ${widget.pet.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(value: 'vaccine', child: Text('Vacina')),
                  DropdownMenuItem(
                    value: 'grooming',
                    child: Text('Banho/Tosa'),
                  ),
                  DropdownMenuItem(value: 'other', child: Text('Outro')),
                ],
                onChanged: (val) {
                  if (val != null)
                    setState(() {
                      _type = val;
                    });
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notas'),
                maxLines: 3,
              ),
              Row(
                children: [
                  Text(
                    _dueDate == null
                        ? 'Data de vencimento não selecionada'
                        : 'Vence em: ${_dueDate!.toLocal().toString().split(' ')[0]}',
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null)
                        setState(() {
                          _dueDate = date;
                        });
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
