// lib/features/auth/data/models/user_model.dart

enum UserRole { client, seeker }

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
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] ?? json['name'] ?? '',
      role: (json['role'] as String).toLowerCase() == 'client'
          ? UserRole.client
          : UserRole.seeker,
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