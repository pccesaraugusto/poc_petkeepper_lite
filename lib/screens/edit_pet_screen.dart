import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pet_model.dart';
import '../providers/pet_provider.dart';

class EditPetScreen extends ConsumerStatefulWidget {
  final Pet pet;
  const EditPetScreen({super.key, required this.pet});

  @override
  ConsumerState<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends ConsumerState<EditPetScreen> {
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _weightController;
  late DateTime _birthDate;
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _speciesController = TextEditingController(text: widget.pet.species);
    _weightController = TextEditingController(
      text: widget.pet.weightKg.toString(),
    );
    _birthDate = widget.pet.birthDate;
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _pickedImage = picked);
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _speciesController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final petService = ref.read(petServiceProvider);
      final data = {
        'name': _nameController.text.trim(),
        'species': _speciesController.text.trim(),
        'weightKg': double.parse(_weightController.text.trim()),
        'birthDate': _birthDate,
        // 'photoUrl': manipular upload da foto no service se necessário
      };

      // Atualizar pet no Firestore
      await petService.updatePet(widget.pet.id, data);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar pet: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _speciesController,
              decoration: const InputDecoration(labelText: 'Espécie'),
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Nascimento: ${_birthDate.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _birthDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _birthDate = date);
                  },
                  child: const Text('Alterar Data'),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Alterar Foto'),
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
    );
  }
}
