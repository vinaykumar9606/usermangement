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
