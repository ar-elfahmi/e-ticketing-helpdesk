import '../models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications({String? userId});

  Future<void> markAsRead(String notificationId);

  Future<void> createNotification(NotificationModel notification);

  void subscribeToRealtime(
    String userId,
    void Function(NotificationModel) onNotification,
  );

  void cancelRealtime();

  Future<List<Map<String, dynamic>>> getAdminUserIds();

  Future<List<Map<String, dynamic>>> getHelpdeskUserIds();
}
