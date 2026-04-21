import 'package:flutter/foundation.dart';

import '../../../auth/data/models/user_model.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  final ProfileRepository _profileRepository;

  UserModel? _userProfile;
  bool _isLoading = false;

  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    _userProfile = await _profileRepository.getUserProfile(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    final updated = await _profileRepository.updateProfile(user);

    _isLoading = false;
    if (updated == null) {
      notifyListeners();
      return false;
    }

    _userProfile = updated;
    notifyListeners();
    return true;
  }
}
