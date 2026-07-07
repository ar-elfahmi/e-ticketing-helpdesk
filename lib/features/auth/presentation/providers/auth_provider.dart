import 'package:flutter/foundation.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  UserModel? _currentUser;
  List<UserModel> _users = [];
  List<UserModel> _deletedUsers = [];
  bool _isLoading = false;
  bool _isLoadingUsers = false;
  bool _isLoadingDeletedUsers = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  List<UserModel> get users => _users;
  List<UserModel> get deletedUsers => _deletedUsers;
  bool get isLoading => _isLoading;
  bool get isLoadingUsers => _isLoadingUsers;
  bool get isLoadingDeletedUsers => _isLoadingDeletedUsers;
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
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerHelpdesk({
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
        role: 'helpdesk',
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

  Future<bool> deleteUser(String userId) async {
    final currentUser = _currentUser;
    if (currentUser == null) {
      _errorMessage = 'Sesi admin tidak ditemukan.';
      notifyListeners();
      return false;
    }

    if (currentUser.id == userId) {
      _errorMessage = 'Tidak bisa menghapus akun sendiri.';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final ok = await _authRepository.deleteUser(
        userId: userId,
        deletedBy: currentUser.id,
      );

      if (!ok) {
        _errorMessage = 'Gagal menghapus user.';
        return false;
      }

      await Future.wait([fetchUsers(), fetchDeletedUsers()]);
      return true;
    } catch (_) {
      _errorMessage = 'Gagal menghapus user.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> restoreUser(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final ok = await _authRepository.restoreUser(userId);

      if (!ok) {
        _errorMessage = 'Gagal memulihkan user.';
        return false;
      }

      await Future.wait([fetchUsers(), fetchDeletedUsers()]);
      return true;
    } catch (_) {
      _errorMessage = 'Gagal memulihkan user.';
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
    String role = 'user',
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authRepository.register(
        name: name,
        email: email,
        username: username,
        password: password,
        role: role,
      );

      if (user == null) {
        _errorMessage =
            'Registrasi gagal. Cek kembali data atau coba email lain.';
        return false;
      }

      return true;
    } catch (e) {
      _errorMessage = '$e';
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

  Future<void> fetchUsers() async {
    if (_isLoadingUsers) {
      return;
    }

    _isLoadingUsers = true;
    notifyListeners();

    try {
      _users = await _authRepository.getUsers();
    } catch (_) {
      _errorMessage = 'Gagal memuat daftar user.';
    } finally {
      _isLoadingUsers = false;
      notifyListeners();
    }
  }

  Future<void> fetchDeletedUsers() async {
    if (_isLoadingDeletedUsers) {
      return;
    }

    _isLoadingDeletedUsers = true;
    notifyListeners();

    try {
      _deletedUsers = await _authRepository.getDeletedUsers();
    } catch (_) {
      _errorMessage = 'Gagal memuat user terhapus.';
    } finally {
      _isLoadingDeletedUsers = false;
      notifyListeners();
    }
  }
}
