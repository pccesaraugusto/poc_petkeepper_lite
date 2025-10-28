import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pet_model.dart';
import '../services/pet_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
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
    if (picked != null) setState(() => _pickedImage = picked);
  }

  Future<String?> _uploadPhoto(String petId, XFile file) async {
    final ref = FirebaseStorage.instance.ref().child('pet_photos/$petId.jpg');
    await ref.putFile(File(file.path));
    return await ref.getDownloadURL();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _birthDate == null) return;

    setState(() => _isSubmitting = true);
    try {
      final familyCode = "BORGES01"; // TODO obter do auth
      final pet = Pet(
        id: '',
        familyCode: familyCode,
        name: _nameController.text.trim(),
        species: _speciesController.text.trim(),
        birthDate: _birthDate!,
        weightKg: double.parse(_weightController.text.trim()),
        photoUrl: null,
        createdAt: DateTime.now(),
      );

      final docRef = await PetService().petsCollection.add(pet.toMap());
      if (_pickedImage != null) {
        final photoUrl = await _uploadPhoto(docRef.id, _pickedImage!);
        await docRef.update({'photoUrl': photoUrl});
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _speciesController,
                decoration: const InputDecoration(labelText: 'Espécie'),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Obrigatório';
                  if (double.tryParse(v) == null) return 'Número inválido';
                  return null;
                },
              ),
              Row(
                children: [
                  Text(
                    _birthDate == null
                        ? 'Data de nascimento'
                        : _birthDate!.toLocal().toString().split(' ')[0],
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _birthDate = date);
                    },
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              if (_pickedImage != null)
                Image.file(File(_pickedImage!.path), height: 100),
              TextButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('Selecionar Foto'),
                onPressed: _pickImage,
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
