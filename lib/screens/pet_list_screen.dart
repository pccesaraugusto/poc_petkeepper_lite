import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pet_provider.dart';

class PetListScreen extends ConsumerWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const familyCode = 'BORGES01'; // TODO: pegar do onboarding/logged user

    final petsAsyncValue = ref.watch(petListProvider(familyCode));

    return Scaffold(
      appBar: AppBar(title: const Text('Pets da Família')),
      body: petsAsyncValue.when(
        data: (pets) {
          if (pets.isEmpty) {
            return const Center(child: Text('Nenhum pet cadastrado.'));
          }
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return ListTile(
                leading: pet.photoUrl != null
                    ? Image.network(pet.photoUrl!)
                    : const Icon(Icons.pets),
                title: Text(pet.name),
                subtitle: Text('${pet.species} - ${pet.weightKg} kg'),
                onTap: () {
                  Navigator.pushNamed(context, '/pet_detail', arguments: pet);
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
          Navigator.pushNamed(context, '/add_pet');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
