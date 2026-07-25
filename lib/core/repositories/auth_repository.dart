import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // login
  Future<AuthResponse?> login(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // register
  Future<AuthResponse?> register(
    String nickname,
    String email,
    String password,
  ) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': nickname},
    );

    return response;
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      return await _client.from('profiles').select().eq('id', uid).single();
    } catch (e) {
      return null;
    }
  }

  // get current user
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  // get current session
  Session? getCurrentSession() {
    return _client.auth.currentSession;
  }

  // logout
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // update profile
  Future<UserResponse> updateProfile(
    String name,
    String email,
    String phone,
  ) async {
    return await _client.auth.updateUser(
      UserAttributes(email: email, data: {'display_name': name}),
    );
  }

  // update password
  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  // reset password
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // auth state changes stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
