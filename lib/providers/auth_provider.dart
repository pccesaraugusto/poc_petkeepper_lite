import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poc_petkeepper_lite/models/pet_model.dart';
import 'package:poc_petkeepper_lite/models/pet_task_model.dart';
import '../services/facebook_auth_service.dart';
import '../services/pet_service.dart';
import '../services/pet_task_service.dart';

// Autenticação usuário Firebase
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Serviço Facebook Auth
final facebookAuthServiceProvider = Provider<FacebookAuthService>((ref) {
  return FacebookAuthService();
});

// Serviço Pet
final petServiceProvider = Provider<PetService>((ref) => PetService());

// Serviço Pet Task
final petTaskServiceProvider = Provider<PetTaskService>(
  (ref) => PetTaskService(),
);

// Pets do usuário/família (exemplo familyCode fixo ou pegar do usuário)
final petListProvider = StreamProvider.family<List<Pet>, String>((
  ref,
  familyCode,
) {
  final petService = ref.watch(petServiceProvider);
  return petService.streamPets(familyCode);
});

// Tarefas do pet
final petTaskListProvider = StreamProvider.family<List<PetTask>, String>((
  ref,
  petId,
) {
  final petTaskService = ref.watch(petTaskServiceProvider);
  return petTaskService.streamTasksForPet(petId);
});
