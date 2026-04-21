import 'package:e_ticketing_helpdesk/features/notification/data/repositories/dummy_notification_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DummyNotificationRepository', () {
    test('markAsRead updates notification state', () async {
      final repository = DummyNotificationRepository();

      final notifications = await repository.getNotifications();
      final unread = notifications.firstWhere((item) => !item.isRead);

      await repository.markAsRead(unread.id);
      final updated = await repository.getNotifications();

      final sameNotification = updated.firstWhere(
        (item) => item.id == unread.id,
      );
      expect(sameNotification.isRead, isTrue);
    });
  });
}
