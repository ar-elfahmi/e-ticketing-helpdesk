import '../models/notification_model.dart';
import 'notification_repository.dart';

class DummyNotificationRepository implements NotificationRepository {
  DummyNotificationRepository() {
    final now = DateTime.now();
    _notifications.addAll([
      NotificationModel(
        id: 'n1',
        title: 'Status tiket diperbarui',
        body: 'Tiket TK-002 berubah menjadi In Progress.',
        type: NotificationType.ticket,
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 45)),
        ticketId: 't2',
        userId: 'u1',
      ),
      NotificationModel(
        id: 'n2',
        title: 'Komentar baru',
        body: 'Helpdesk menambahkan komentar pada TK-001.',
        type: NotificationType.comment,
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        ticketId: 't1',
        userId: 'u1',
      ),
      NotificationModel(
        id: 'n3',
        title: 'Tiket ditutup',
        body: 'Tiket TK-004 sudah diselesaikan.',
        type: NotificationType.ticket,
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 5)),
        ticketId: 't4',
        userId: 'u1',
      ),
      NotificationModel(
        id: 'n4',
        title: 'Assignment tiket',
        body: 'Tiket TK-010 diassign ke tim admin.',
        type: NotificationType.general,
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 8)),
        ticketId: 't10',
        userId: 'a1',
      ),
      NotificationModel(
        id: 'n5',
        title: 'Reminder follow-up',
        body: 'Masih ada 3 tiket open yang butuh tindak lanjut.',
        type: NotificationType.general,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
        ticketId: null,
        userId: 'h1',
      ),
      NotificationModel(
        id: 'n6',
        title: 'Komentar baru dari user',
        body: 'Ari menambahkan detail masalah pada TK-003.',
        type: NotificationType.comment,
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
        ticketId: 't3',
        userId: 'h1',
      ),
    ]);
  }

  final List<NotificationModel> _notifications = [];

  @override
  Future<List<NotificationModel>> getNotifications({String? userId}) async {
    await Future.delayed(const Duration(milliseconds: 450));

    var result = _notifications;
    if (userId != null && userId.isNotEmpty) {
      result = result.where((item) => item.userId == userId).toList();
    }

    final sorted = [...result]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _notifications.indexWhere(
      (item) => item.id == notificationId,
    );
    if (index < 0) {
      return;
    }

    _notifications[index] = _notifications[index].copyWith(isRead: true);
  }
}
