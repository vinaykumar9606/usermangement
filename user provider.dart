import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());

final userProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserNotifier(repository);
});

class UserNotifier extends StateNotifier<List<User>> {
  final UserRepository repository;

  UserNotifier(this.repository) : super(repository.getAllUsers());

  void addUser(User user) {
    repository.addUser(user);
    state = [...repository.getAllUsers()];
  }

  void updateUser(String id, String newName, String newEmail) {
    repository.updateUser(id, newName, newEmail);
    state = [...repository.getAllUsers()];
  }

  void deleteUser(String id) {
    repository.deleteUser(id);
    state = [...repository.getAllUsers()];
  }
}
