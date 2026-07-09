import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/supabase_auth_repository.dart';

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
  String? _successMessage;
  String? get successMessage => _successMessage;
  bool get isAuthenticated => _currentUser != null;

  bool _isRecoveryFlow = false;
  bool get isRecoveryFlow => _isRecoveryFlow;

  void setRecoveryFlow() {
    _isRecoveryFlow = true;
    notifyListeners();
  }

  void clearRecoveryFlow() {
    _isRecoveryFlow = false;
    notifyListeners();
  }

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

  Future<bool> deactivateUser(String userId) async {
    final currentUser = _currentUser;
    if (currentUser == null) {
      _errorMessage = 'Sesi admin tidak ditemukan.';
      notifyListeners();
      return false;
    }

    if (currentUser.id == userId) {
      _errorMessage = 'Tidak bisa menonaktifkan akun sendiri.';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final ok = await _authRepository.deactivateUser(
        userId: userId,
        deletedBy: currentUser.id,
      );

      if (!ok) {
        _errorMessage = 'Gagal menonaktifkan user (tidak ada baris diperbarui).';
        return false;
      }

      await Future.wait([fetchUsers(), fetchDeletedUsers()]);
      return true;
    } catch (e) {
      debugPrint('DEBUG: AuthProvider.deactivateUser error: $e');
      _errorMessage = 'Gagal menonaktifkan user: $e';
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
        _errorMessage = 'Gagal memulihkan user (tidak ada baris diperbarui).';
        return false;
      }

      await Future.wait([fetchUsers(), fetchDeletedUsers()]);
      return true;
    } catch (e) {
      debugPrint('DEBUG: AuthProvider.restoreUser error: $e');
      _errorMessage = 'Gagal memulihkan user: $e';
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
    _successMessage = null;

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

      if (_authRepository is SupabaseAuthRepository &&
          _authRepository.needsEmailVerification) {
        _successMessage =
            'Registrasi berhasil. Link verifikasi telah dikirim ke email Anda. Silakan verifikasi sebelum login.';
      } else {
        _successMessage = 'Registrasi berhasil. Silakan login.';
      }

      return true;
    } on AuthException catch (e) {
      if (e.message.contains('User already registered') ||
          e.message.contains('email already exists') ||
          e.message.contains('Email already in use')) {
        _errorMessage = 'Email sudah terdaftar. Gunakan email lain.';
      } else {
        _errorMessage = e.message;
      }
      return false;
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
    } on AuthException catch (e) {
      if (e.statusCode == '429') {
        _errorMessage = 'Terlalu banyak permintaan. Silakan coba beberapa saat lagi.';
      } else {
        _errorMessage = 'Gagal mengirim email reset: ${e.message}';
      }
      return false;
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
      _isRecoveryFlow = false;
    } catch (_) {
      _errorMessage = 'Gagal logout.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      return await _authRepository.updatePassword(newPassword);
    } catch (_) {
      _errorMessage = 'Gagal memperbarui password.';
      return false;
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
