import '../models/user_model.dart';

abstract class AuthRepository {
  Future<List<UserModel>> getUsers();

  Future<List<UserModel>> getDeletedUsers();

  Future<bool> deleteUser({
    required String userId,
    required String deletedBy,
  });

  Future<bool> restoreUser(String userId);

  Future<UserModel?> login(String username, String password);

  Future<void> logout();

  Future<UserModel?> register({
    required String name,
    required String email,
    required String username,
    required String password,
    String role = 'user',
  });

  Future<UserModel?> getCurrentUser();

  Future<bool> resetPassword(String emailOrUsername);
}
