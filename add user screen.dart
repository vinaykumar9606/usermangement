import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';

class AddUserScreen extends ConsumerWidget {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final uuid = Uuid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Add User")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Add User"),
              onPressed: () {
                final newUser = User(id: uuid.v4(), name: _nameController.text, email: _emailController.text);
                ref.read(userProvider.notifier).addUser(newUser);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
