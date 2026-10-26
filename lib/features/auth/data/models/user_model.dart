enum UserRole {
  mahasiswa,
  dosen;

  static UserRole fromString(String role) {
    return role.toLowerCase() == 'dosen' ? UserRole.dosen : UserRole.mahasiswa;
  }

  String get displayName => this == UserRole.dosen ? 'Dosen' : 'Mahasiswa';
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final int level;
  final int totalXp;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.level,
    required this.totalXp,
  });

  UserRole get roleType => UserRole.fromString(role);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'mahasiswa',
      level: json['level'] as int? ?? 1,
      totalXp: json['totalXp'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'level': level,
      'totalXp': totalXp,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    int? level,
    int? totalXp,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      level: level ?? this.level,
      totalXp: totalXp ?? this.totalXp,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, level: $level, totalXp: $totalXp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.level == level &&
        other.totalXp == totalXp;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, email, role, level, totalXp);
  }
}
