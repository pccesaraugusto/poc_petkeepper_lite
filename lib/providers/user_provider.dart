import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/user_repository.dart';
import '../models/user_model.dart';
import 'package:riverpod/legacy.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userListStreamProvider = StreamProvider<List<UserModel>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getUsersStream();
});

final userListNotifierProvider =
    StateNotifierProvider<UserListNotifier, List<UserModel>>((ref) {
  return UserListNotifier(ref);
});

class UserListNotifier extends StateNotifier<List<UserModel>> {
  final Ref ref;

  UserListNotifier(this.ref) : super([]) {
    _init();
  }

  void _init() {
    // Escuta o StreamProvider e atualiza o estado ao receber os dados
    ref.listen<AsyncValue<List<UserModel>>>(userListStreamProvider,
        (previous, next) {
      next.whenData((users) {
        state = users;
      });
    });
  }

  Future<void> addUser(
      String id, String displayName, String email, String familyCode) async {
    final user = UserModel(
      id: id,
      displayName: displayName,
      email: email,
      familyCode: familyCode,
      fcmTokens: [],
    );
    await ref.read(userRepositoryProvider).addUser(user);
  }
}
