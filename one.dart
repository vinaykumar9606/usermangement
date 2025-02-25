import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

// Model
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  User copyWith({String? name, String? email}) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

// Repository
class UserRepository {
  final List<User> _users = [];
  final _uuid = Uuid();

  List<User> getAllUsers() => List.unmodifiable(_users);

  User? getUser(String id) => _users.firstWhere((user) => user.id == id, orElse: () => User(id: '', name: '', email: ''));

  void createUser(String name, String email) {
    _users.add(User(id: _uuid.v4(), name: name, email: email));
  }

  void updateUser(String id, String name, String email) {
    int index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users[index] = _users[index].copyWith(name: name, email: email);
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((user) => user.id == id);
  }
}

// Riverpod Provider
final userRepositoryProvider = Provider((ref) => UserRepository());
final usersProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserNotifier(repository);
});

class UserNotifier extends StateNotifier<List<User>> {
  final UserRepository repository;
  UserNotifier(this.repository) : super(repository.getAllUsers());

  void addUser(String name, String email) {
    repository.createUser(name, email);
    state = repository.getAllUsers();
  }

  void updateUser(String id, String name, String email) {
    repository.updateUser(id, name, email);
    state = repository.getAllUsers();
  }

  void deleteUser(String id) {
    repository.deleteUser(id);
    state = repository.getAllUsers();
  }
}

// UI
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserScreen(),
    );
  }
}

class UserListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: Text("User Management")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final nameController = TextEditingController(text: user.name);
                    final emailController = TextEditingController(text: user.email);

                    return AlertDialog(
                      title: Text("Update User"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
                          TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("Update"),
                          onPressed: () {
                            ref.read(userProvider.notifier).updateUser(
                              user.id,
                              nameController.text,
                              emailController.text,
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
