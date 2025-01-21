class User {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> projectIds;
  final List<String> zoneIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.projectIds,
    required this.zoneIds,
  });
}
