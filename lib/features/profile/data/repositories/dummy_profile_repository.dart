import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/repositories/dummy_auth_repository.dart';
import 'profile_repository.dart';

class DummyProfileRepository implements ProfileRepository {
  DummyProfileRepository({required DummyAuthRepository authRepository})
    : _authRepository = authRepository;

  final DummyAuthRepository _authRepository;

  @override
  Future<UserModel?> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _authRepository.findUserById(userId);
  }

  @override
  Future<UserModel?> updateProfile(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _authRepository.upsertUser(user);
    return user;
  }
}
