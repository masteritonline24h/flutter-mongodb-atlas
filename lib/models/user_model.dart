class UserModel {
  final String id;
  final String email;

  UserModel({
    required this.id,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}

class AuthResult {
  final bool success;
  final String message;
  final UserModel? user;
  final String? token;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });
}