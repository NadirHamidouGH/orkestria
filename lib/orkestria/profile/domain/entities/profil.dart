class Profile {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool enabled;
  final List<Role> roles;
  final List<Group> groups;

  Profile({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.enabled,
    required this.roles,
    required this.groups,
  });

  // Méthode pour convertir un JSON en objet Profile
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      enabled: json['enabled'],
      roles: (json['roles'] as List<dynamic>)
          .map((role) => Role.fromJson(role))
          .toList(),
      groups: (json['groups'] as List<dynamic>)
          .map((group) => Group.fromJson(group))
          .toList(),
    );
  }

  // Méthode pour convertir un objet Profile en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'enabled': enabled,
      'roles': roles.map((role) => role.toJson()).toList(),
      'groups': groups.map((group) => group.toJson()).toList(),
    };
  }
}

class Role {
  final String id;
  final String name;
  final String description;

  Role({
    required this.id,
    required this.name,
    required this.description,
  });

  // Méthode pour convertir un JSON en objet Role
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
    );
  }

  // Méthode pour convertir un objet Role en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

class Group {
  final String id;
  final String name;
  final String path;

  Group({
    required this.id,
    required this.name,
    required this.path,
  });

  // Méthode pour convertir un JSON en objet Group
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      path: json['path'],
    );
  }

  // Méthode pour convertir un objet Group en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
    };
  }
}
