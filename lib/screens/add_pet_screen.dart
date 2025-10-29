import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poc_petkeepper_lite/providers/storage_service_provider.dart';

import '../models/pet_model.dart';
import '../providers/pet_provider.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _weightController = TextEditingController();
  DateTime? _birthDate;
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final familyCode =
          'BORGES01'; // TODO: Substituir por usuário autenticado real

      String? photoUrl;
      if (_pickedImage != null) {
        final storageService = ref.read(storageServiceProvider);
        photoUrl = await storageService.uploadFile(
          'pets/${DateTime.now().millisecondsSinceEpoch}.jpg',
          File(_pickedImage!.path),
        );
      }

      final newPet = Pet(
        id: '',
        familyCode: familyCode,
        name: _nameController.text.trim(),
        species: _speciesController.text.trim(),
        birthDate: _birthDate!,
        weightKg: double.parse(_weightController.text.trim()),
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
      );

      final petService = ref.read(petServiceProvider);
      await petService.addPet(newPet);

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar pet: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
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
      appBar: AppBar(title: const Text('Adicionar Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _speciesController,
                decoration: const InputDecoration(labelText: 'Espécie'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Campo obrigatório';
                  if (double.tryParse(value) == null)
                    return 'Digite um número válido';
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _birthDate == null
                          ? 'Data de nascimento não selecionada'
                          : 'Nascimento: ${_birthDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() => _birthDate = date);
                      }
                    },
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              if (_pickedImage != null)
                Image.file(File(_pickedImage!.path), height: 150),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Selecionar Foto'),
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
