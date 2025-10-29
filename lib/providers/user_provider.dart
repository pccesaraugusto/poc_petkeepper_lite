import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/user_model.dart';
import 'package:uuid/uuid.dart';

final userListProvider =
    StateNotifierProvider<UserListNotifier, List<UserModel>>((ref) {
  return UserListNotifier();
});

class UserListNotifier extends StateNotifier<List<UserModel>> {
  UserListNotifier() : super([]);

  void addUser(String name, String email) {
    var newUser = UserModel(id: const Uuid().v4(), name: name, email: email);
    state = [...state, newUser];
  }

  void updateUser(String id, String name, String email) {
    state = [
      for (final user in state)
        if (user.id == id) user.copyWith(name: name, email: email) else user,
    ];
  }

  void deleteUser(String id) {
    state = state.where((user) => user.id != id).toList();
  }
}
