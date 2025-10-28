import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/pet_service.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String familyCode = 'BORGES01'; // TODO pegar do auth

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets da Família'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_pet');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Pet>>(
        stream: PetService().streamPets(familyCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum pet cadastrado.'));
          }

          final pets = snapshot.data!;
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return ListTile(
                leading: pet.photoUrl != null
                    ? Image.network(pet.photoUrl!)
                    : const Icon(Icons.pets),
                title: Text(pet.name),
                subtitle: Text('${pet.species} - Peso: ${pet.weightKg}kg'),
                onTap: () {
                  Navigator.pushNamed(context, '/pet_detail', arguments: pet);
                },
                onLongPress: () async {
                  final confirm = await showConfirmDialog(
                    context,
                    'Excluir Pet',
                    'Deseja realmente excluir ${pet.name}?',
                  );
                  if (confirm == true) {
                    try {
                      await PetService().deletePet(pet.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pet excluído com sucesso'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao excluir pet: $e')),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

Future<bool?> showConfirmDialog(
  BuildContext context,
  String title,
  String content,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}
