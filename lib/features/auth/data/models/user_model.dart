import 'dart:convert';

enum UserRole { user, helpdesk, admin }

extension UserRoleX on UserRole {
  String get value {
    switch (this) {
      case UserRole.user:
        return 'user';
      case UserRole.helpdesk:
        return 'helpdesk';
      case UserRole.admin:
        return 'admin';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.user:
        return 'User';
      case UserRole.helpdesk:
        return 'Helpdesk';
      case UserRole.admin:
        return 'Admin';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'helpdesk':
        return UserRole.helpdesk;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }
}

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.role,
    this.avatarUrl,
    this.deletedAt,
    this.deletedBy,
  });

  final String id;
  final String name;
  final String email;
  final String username;
  final UserRole role;
  final String? avatarUrl;
  final DateTime? deletedAt;
  final String? deletedBy;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    UserRole? role,
    String? avatarUrl,
    DateTime? deletedAt,
    String? deletedBy,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'role': role.value,
      'avatarUrl': avatarUrl,
      'deleted_at': deletedAt?.toIso8601String(),
      'deleted_by': deletedBy,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      role: UserRoleX.fromString(map['role'] as String),
      avatarUrl: (map['avatar_url'] ?? map['avatarUrl']) as String?,
      deletedAt: map['deleted_at'] != null
          ? DateTime.parse(map['deleted_at'].toString())
          : null,
      deletedBy: map['deleted_by'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
