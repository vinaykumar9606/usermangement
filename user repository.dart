import '../models/user.dart';

class UserRepository {
  final List<User> _users = [];

  // Get all users
  List<User> getAllUsers() {
    return _users;
  }

  // Add a user
  void addUser(User user) {
    _users.add(user);
  }

  // Update a user
  void updateUser(String id, String newName, String newEmail) {
    final index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users[index] = _users[index].copyWith(name: newName, email: newEmail);
    }
  }

  // Delete a user
  void deleteUser(String id) {
    _users.removeWhere((user) => user.id == id);
  }
}
