import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/supabase_config.dart';
import '../../../auth/data/models/user_model.dart';
import 'profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository() {
    _supabase = SupabaseConfig.client;
  }

  late final SupabaseClient _supabase;

  @override
  Future<UserModel?> getUserProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserModel.fromMap(response);
  }

  @override
  Future<UserModel?> updateProfile(UserModel user) async {
    final response = await _supabase
        .from('profiles')
        .update({
          'name': user.name,
          'email': user.email,
          'username': user.username,
          'role': user.role.value,
          'avatar_url': user.avatarUrl,
        })
        .eq('id', user.id)
        .select('*')
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserModel.fromMap(response);
  }
}