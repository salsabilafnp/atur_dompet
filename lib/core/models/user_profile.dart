class UserProfile {
  final String id;
  final String email;
  final String nickname;
  final String role; // 'user' atau 'super_admin'

  UserProfile({
    required this.id,
    required this.email,
    required this.nickname,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nickname': nickname};
  }
}
