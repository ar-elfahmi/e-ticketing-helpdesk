import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/supabase_config.dart';
import '../models/notification_model.dart';
import 'notification_repository.dart';

class SupabaseNotificationRepository implements NotificationRepository {
  late final SupabaseClient _supabase;
  RealtimeChannel? _channel;

  SupabaseNotificationRepository() {
    _supabase = SupabaseConfig.client;
  }

  @override
  Future<List<NotificationModel>> getNotifications({String? userId}) async {
    var q = _supabase.from('notifications').select('*');

    if (userId != null && userId.isNotEmpty) {
      q = q.eq('user_id', userId);
    }

    final response = await q.order('created_at', ascending: false);
    return (response as List)
        .map((e) => NotificationModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  @override
  Future<void> createNotification(NotificationModel notification) async {
    await _supabase.from('notifications').insert(notification.toInsertMap());
  }

  @override
  void subscribeToRealtime(
    String userId,
    void Function(NotificationModel) onNotification,
  ) {
    cancelRealtime();

    _channel = _supabase.channel('notifications-$userId');
    _channel!.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'notifications',
      filter: PostgresChangeFilter(
        column: 'user_id',
        type: PostgresChangeFilterType.eq,
        value: userId,
      ),
      callback: (payload) {
        final data = NotificationModel.fromMap(
          Map<String, dynamic>.from(payload.newRecord),
        );
        onNotification(data);
      },
    );
    _channel!.subscribe();
  }

  @override
  void cancelRealtime() {
    _channel?.unsubscribe();
    _channel = null;
  }

  @override
  Future<List<Map<String, dynamic>>> getAdminUserIds() async {
    final response = await _supabase
        .from('profiles')
        .select('id')
        .eq('role', 'admin');
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getHelpdeskUserIds() async {
    final response = await _supabase
        .from('profiles')
        .select('id')
        .eq('role', 'helpdesk');
    return List<Map<String, dynamic>>.from(response);
  }
}
