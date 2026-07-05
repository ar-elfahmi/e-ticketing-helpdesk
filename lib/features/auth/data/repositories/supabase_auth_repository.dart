import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import 'auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository() {
    _supabase = Supabase.instance.client;
  }

  late final SupabaseClient _supabase;

  @override
  Future<UserModel?> login(String username, String password) async {
    final isEmail = username.contains('@');

    String email;
    if (isEmail) {
      email = username;
    } else {
      final result = await _supabase.rpc('get_email_by_username', params: {
        'lookup_username': username,
      });
      if (result == null || result == '') return null;
      email = result as String;
    }

    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) return null;

    return _getProfile(user.id);
  }

  @override
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (_) {}
  }

  @override
  Future<UserModel?> register({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'username': username,
          'role': 'user',
        },
      );

      final user = response.user;
      if (user == null) return null;

      return _getProfile(user.id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final session = _supabase.auth.currentSession;
      final authUser = session?.user;
      if (authUser == null) return null;

      return _getProfile(authUser.id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> resetPassword(String emailOrUsername) async {
    try {
      final isEmail = emailOrUsername.contains('@');

      String email;
      if (isEmail) {
        email = emailOrUsername;
      } else {
        final result = await _supabase.rpc('get_email_by_username', params: {
          'lookup_username': emailOrUsername,
        });
        if (result == null || result == '') return false;
        email = result as String;
      }

      await _supabase.auth.resetPasswordForEmail(email);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<UserModel?> _getProfile(String userId) async {
    final profile = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (profile == null) return null;

    return UserModel.fromMap(profile);
  }
}
