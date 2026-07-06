import '../models/user_model.dart';
import 'auth_repository.dart';

class DummyAuthRepository implements AuthRepository {
  DummyAuthRepository() {
    _users.addAll([
      const UserModel(
        id: 'u1',
        name: 'Ari Pratama',
        email: 'ari.user@example.com',
        username: 'user',
        role: UserRole.user,
        avatarUrl: null,
      ),
      const UserModel(
        id: 'h1',
        name: 'Nadia Helpdesk',
        email: 'nadia.helpdesk@example.com',
        username: 'helpdesk',
        role: UserRole.helpdesk,
        avatarUrl: null,
      ),
      const UserModel(
        id: 'a1',
        name: 'Raka Admin',
        email: 'raka.admin@example.com',
        username: 'admin',
        role: UserRole.admin,
        avatarUrl: null,
      ),
    ]);

    _passwords.addAll({
      'user': 'password123',
      'helpdesk': 'password123',
      'admin': 'password123',
    });
  }

  final List<UserModel> _users = [];
  final Map<String, String> _passwords = {};
  UserModel? _currentUser;

  @override
  Future<UserModel?> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final user = _users.where((item) => item.username == username).firstOrNull;
    if (user == null) {
      return null;
    }

    final expectedPassword = _passwords[username];
    if (expectedPassword != password) {
      return null;
    }

    _currentUser = user;
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<UserModel?> register({
    required String name,
    required String email,
    required String username,
    required String password,
    String role = 'user',
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final usernameExists = _users.any(
      (item) => item.username.toLowerCase() == username.toLowerCase(),
    );
    if (usernameExists) {
      return null;
    }

    final emailExists = _users.any(
      (item) => item.email.toLowerCase() == email.toLowerCase(),
    );
    if (emailExists) {
      return null;
    }

    final user = UserModel(
      id: 'u${_users.length + 1}',
      name: name,
      email: email,
      username: username,
      role: UserRoleX.fromString(role),
      avatarUrl: null,
    );

    _users.add(user);
    _passwords[username] = password;

    return user;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<bool> resetPassword(String emailOrUsername) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final exists = _users.any(
      (item) =>
          item.email.toLowerCase() == emailOrUsername.toLowerCase() ||
          item.username.toLowerCase() == emailOrUsername.toLowerCase(),
    );

    return exists;
  }

  UserModel? findUserById(String userId) {
    return _users.where((item) => item.id == userId).firstOrNull;
  }

  void upsertUser(UserModel user) {
    final index = _users.indexWhere((item) => item.id == user.id);
    if (index < 0) {
      _users.add(user);
      _passwords.putIfAbsent(user.username, () => 'password123');
      return;
    }

    _users[index] = user;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }
    return first;
  }
}
