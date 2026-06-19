import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> login(String username, String password);

  Future<void> logout();

  Future<UserModel?> register({
    required String name,
    required String email,
    required String username,
    required String password,
  });

  Future<UserModel?> getCurrentUser();

  Future<bool> resetPassword(String emailOrUsername);
}
