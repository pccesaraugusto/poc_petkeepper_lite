import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pet_model.dart';
import '../services/pet_service.dart';

// Providers extraídos para fora do widget, preferencialmente em arquivo separado
final petServiceProvider = Provider<PetService>((ref) {
  return PetService();
});

final petListProvider =
    StreamProvider.family<List<Pet>, String>((ref, familyCode) {
  final service = ref.watch(petServiceProvider);
  return service.streamPets(familyCode);
});

class PetListWidget extends ConsumerWidget {
  final String familyCode;

  const PetListWidget({super.key, required this.familyCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsyncValue = ref.watch(petListProvider(familyCode));

    return petsAsyncValue.when(
      data: (pets) {
        if (pets.isEmpty) {
          return const Center(child: Text('Nenhum pet cadastrado.'));
        }
        return ListView.builder(
          itemCount: pets.length,
          itemBuilder: (context, index) {
            final pet = pets[index];
            return ListTile(
              title: Text(pet.name),
              subtitle: Text('${pet.species} - Peso: ${pet.weightKg}kg'),
              onTap: () {
                Navigator.pushNamed(context, '/pet_detail', arguments: pet);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erro: $error')),
    );
  }
}
