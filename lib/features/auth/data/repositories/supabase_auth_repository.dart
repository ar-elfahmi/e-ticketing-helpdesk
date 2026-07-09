import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import 'auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository() {
    _supabase = Supabase.instance.client;
  }

  late final SupabaseClient _supabase;
  bool _needsEmailVerification = false;
  bool get needsEmailVerification => _needsEmailVerification;

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _supabase.from('profiles').select('*').order(
      'name',
      ascending: true,
    );

    return (response as List)
        .map((item) => UserModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<UserModel>> getDeletedUsers() async {
    final response = await _supabase
        .from('profiles')
        .select('*')
        .not('deleted_at', 'is', null)
        .order('name', ascending: true);

    return (response as List)
        .map((item) => UserModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> deactivateUser({
    required String userId,
    required String deletedBy,
  }) async {
    try {
      final updated = await _supabase
          .from('profiles')
          .update({
            'deleted_at': DateTime.now().toIso8601String(),
            'deleted_by': deletedBy,
          })
          .eq('id', userId)
          .select('*')
          .maybeSingle();

      return updated != null;
    } catch (e) {
      debugPrint('DEBUG: SupabaseAuthRepository.deactivateUser error: $e');
      return false;
    }
  }

  @override
  Future<bool> restoreUser(String userId) async {
    try {
      final updated = await _supabase
          .from('profiles')
          .update({
            'deleted_at': null,
            'deleted_by': null,
          })
          .eq('id', userId)
          .select('*')
          .maybeSingle();

      return updated != null;
    } catch (e) {
      debugPrint('DEBUG: SupabaseAuthRepository.restoreUser error: $e');
      return false;
    }
  }

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
    String role = 'user',
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'username': username,
        'role': role,
      },
    );

    final user = response.user;
    if (user == null) return null;

    _needsEmailVerification = response.session == null;

    try {
      final profile = await _getProfile(user.id);
      if (profile != null) {
        return profile;
      }
    } catch (_) {
      // Ignored: profile might not be created or accessible yet (e.g. if email confirmation is required)
    }

    return UserModel(
      id: user.id,
      name: name,
      email: email,
      username: username,
      role: UserRoleX.fromString(role),
      avatarUrl: null,
      deletedAt: null,
      deletedBy: null,
    );
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
  Future<bool> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> resetPassword(String emailOrUsername) async {
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
  }

  Future<UserModel?> _getProfile(String userId) async {
    final profile = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (profile == null) return null;

    return UserModel.fromMap(profile);
  }
}
