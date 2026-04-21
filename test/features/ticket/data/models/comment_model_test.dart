import 'package:e_ticketing_helpdesk/features/ticket/data/models/comment_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CommentModel map serialization roundtrip', () {
    final model = CommentModel(
      id: 'c1',
      ticketId: 't1',
      userId: 'u1',
      userName: 'Ari',
      content: 'Komentar test',
      createdAt: DateTime(2026, 4, 19),
    );

    final restored = CommentModel.fromMap(model.toMap());

    expect(restored.id, model.id);
    expect(restored.content, model.content);
    expect(restored.userId, model.userId);
  });
}
