import '../../../auth/data/models/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel?> getUserProfile(String userId);

  Future<UserModel?> updateProfile(UserModel user);
}
