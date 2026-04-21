import 'package:e_ticketing_helpdesk/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserModel map serialization roundtrip', () {
    const model = UserModel(
      id: 'u1',
      name: 'Ari',
      email: 'ari@example.com',
      username: 'ari',
      role: UserRole.user,
      avatarUrl: null,
    );

    final map = model.toMap();
    final restored = UserModel.fromMap(map);

    expect(restored.id, model.id);
    expect(restored.email, model.email);
    expect(restored.role, model.role);
  });
}
