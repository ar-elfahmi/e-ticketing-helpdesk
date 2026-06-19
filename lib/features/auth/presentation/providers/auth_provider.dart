import 'package:flutter/foundation.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<void> bootstrap() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _currentUser = await _authRepository.getCurrentUser();
    } catch (_) {
      _errorMessage = 'Gagal mengecek sesi login.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authRepository.login(username, password);
      if (user == null) {
        _errorMessage = 'Username atau password salah.';
        return false;
      }

      _currentUser = user;
      return true;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat login.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authRepository.register(
        name: name,
        email: email,
        username: username,
        password: password,
      );

      if (user == null) {
        _errorMessage = 'Username atau email sudah dipakai.';
        return false;
      }

      return true;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat mendaftar.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String emailOrUsername) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      return await _authRepository.resetPassword(emailOrUsername);
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authRepository.logout();
      _currentUser = null;
    } catch (_) {
      _errorMessage = 'Gagal logout.';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
