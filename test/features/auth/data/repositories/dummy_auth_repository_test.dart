import 'package:e_ticketing_helpdesk/features/auth/data/repositories/dummy_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DummyAuthRepository', () {
    late DummyAuthRepository repository;

    setUp(() {
      repository = DummyAuthRepository();
    });

    test('login succeeds for valid dummy user', () async {
      final user = await repository.login('user', 'password123');

      expect(user, isNotNull);
      expect(user?.username, 'user');
    });

    test('register creates new user', () async {
      final registered = await repository.register(
        name: 'Test User',
        email: 'test.user@example.com',
        username: 'testuser',
        password: 'secret123',
      );

      expect(registered, isNotNull);

      final login = await repository.login('testuser', 'secret123');
      expect(login, isNotNull);
      expect(login?.name, 'Test User');
    });

    test('logout clears current session', () async {
      await repository.login('admin', 'password123');
      await repository.logout();

      final current = await repository.getCurrentUser();
      expect(current, isNull);
    });
  });
}
