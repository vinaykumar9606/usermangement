import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import '../widgets/user_tile.dart';
import 'add_user_screen.dart';

class UserListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: Text("User Management")),
      body: users.isEmpty
          ? Center(child: Text("No users added yet!"))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserTile(user: users[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddUserScreen()),
        ),
      ),
    );
  }
}
