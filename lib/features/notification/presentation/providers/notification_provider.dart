import 'package:flutter/foundation.dart';

import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository;

  final NotificationRepository _notificationRepository;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((item) => !item.isRead).length;

  Future<void> fetchNotifications({String? userId}) async {
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
}
