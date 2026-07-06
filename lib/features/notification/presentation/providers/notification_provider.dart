import 'package:flutter/foundation.dart';

import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository;

  final NotificationRepository _notificationRepository;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _currentUserId;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((item) => !item.isRead).length;

  Future<void> fetchNotifications({String? userId}) async {
    _currentUserId = userId;
    _isLoading = true;
    notifyListeners();

    _notifications = await _notificationRepository.getNotifications(
      userId: userId,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationRepository.markAsRead(notificationId);

    _notifications = _notifications
        .map(
          (item) =>
              item.id == notificationId ? item.copyWith(isRead: true) : item,
        )
        .toList();

    notifyListeners();
  }

  Future<void> createNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? ticketId,
    required String userId,
  }) async {
    final notification = NotificationModel(
      id: '',
      title: title,
      body: body,
      type: type,
      isRead: false,
      createdAt: DateTime.now(),
      ticketId: ticketId,
      userId: userId,
    );

    await _notificationRepository.createNotification(notification);

    if (userId == _currentUserId) {
      _notifications.insert(0, notification);
      notifyListeners();
    }
  }

  Future<void> createNotificationForAdmins({
    required String title,
    required String body,
    required NotificationType type,
    String? ticketId,
  }) async {
    final adminIds = await _notificationRepository.getAdminUserIds();
    for (final admin in adminIds) {
      await createNotification(
        title: title,
        body: body,
        type: type,
        ticketId: ticketId,
        userId: admin['id'] as String,
      );
    }
  }

  void subscribeToRealtime(String userId) {
    if (_currentUserId == userId) return;
    _currentUserId = userId;
    _notificationRepository.subscribeToRealtime(userId, (notif) {
      _currentUserId = userId;
      final exists = _notifications.any((n) => n.id == notif.id);
      if (!exists) {
        _notifications.insert(0, notif);
        notifyListeners();
      }
    });
  }

  Future<void> createNewTicketNotification(
      String ticketId, String reporterName) async {
    await createNotificationForAdmins(
      title: 'Tiket Baru',
      body: 'Tiket baru dari $reporterName',
      type: NotificationType.ticket,
      ticketId: ticketId,
    );
  }

  Future<void> createStatusChangeNotification({
    required String ticketNumber,
    required String newStatus,
    required String userId,
    required String ticketId,
  }) async {
    await createNotification(
      title: 'Status Tiket Berubah',
      body: 'Tiket $ticketNumber berubah menjadi $newStatus',
      type: NotificationType.ticket,
      ticketId: ticketId,
      userId: userId,
    );
  }

  Future<void> createNotificationForHelpdesks({
    required String title,
    required String body,
    required NotificationType type,
    String? ticketId,
  }) async {
    final helpdeskIds = await _notificationRepository.getHelpdeskUserIds();
    for (final hd in helpdeskIds) {
      await createNotification(
        title: title,
        body: body,
        type: type,
        ticketId: ticketId,
        userId: hd['id'] as String,
      );
    }
  }

  Future<void> createAssignmentNotification({
    required String ticketNumber,
    required String assigneeId,
    required String ticketId,
  }) async {
    await createNotification(
      title: 'Tiket Diassign',
      body: 'Tiket $ticketNumber diassign ke Anda',
      type: NotificationType.ticket,
      ticketId: ticketId,
      userId: assigneeId,
    );
  }
}
