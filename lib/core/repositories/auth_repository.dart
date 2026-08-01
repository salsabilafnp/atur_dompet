import 'package:atur_dompet/core/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // login (AUTH-02)
  Future<AuthResponse?> login(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // register (AUTH-01)
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

  // see profile (AUTH-05)
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', uid)
          .single();
      return UserProfile.fromJson(data);
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

  // logout (AUTH-02)
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // update profile
  Future<void> updateProfile(String? name, String? email) async {
    final uid = _client.auth.currentUser!.id;

    await _client.auth.updateUser(
      UserAttributes(email: email ?? '', data: {'display_name': name ?? ''}),
    );

    await _client
        .from('profiles')
        .update({
          'nickname': name ?? '',
          'email': email ?? '',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', uid);
  }

  // update password (AUTH-04)
  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  // reset password (AUTH-03)
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // delete account
  Future<void> deleteAccount() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      return;
    }

    // Delete user from auth
    await _client.rpc('handle_delete_account', params: {'user_id': user.id});

    await logout();
  }

  // auth state changes stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
