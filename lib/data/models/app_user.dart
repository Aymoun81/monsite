/// Rôles génériques v1 — à remplacer par les rôles réels
/// du cahier des charges (ex: admin, gestionnaire, client, livreur...).
enum AppRole { admin, member }

AppRole roleFromString(String value) {
  return AppRole.values.firstWhere(
    (r) => r.name == value,
    orElse: () => AppRole.member,
  );
}

class AppUser {
  final String id;
  final String email;
  final String? fullName;
  final AppRole role;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
    this.fullName,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['full_name'] as String?,
      role: roleFromString(map['role'] as String? ?? 'member'),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role.name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
