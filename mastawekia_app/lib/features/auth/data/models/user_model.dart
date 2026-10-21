// lib/features/auth/data/models/user_model.dart

enum UserRole { client, seeker, admin }

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? phoneNumber;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phoneNumber,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleStr = (json['role'] as String? ?? 'USER').toUpperCase();
    UserRole parsedRole = UserRole.seeker;
    if (roleStr == 'CLIENT' || roleStr == 'EMPLOYER') {
      parsedRole = UserRole.client;
    } else if (roleStr == 'ADMIN') {
      parsedRole = UserRole.admin;
    }

    return UserModel(
      id: (json['id'] ?? json['userId'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      fullName: (json['fullName'] ?? json['name'] ?? json['email'] ?? '') as String,
      role: parsedRole,
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role.name,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
    };
  }
}