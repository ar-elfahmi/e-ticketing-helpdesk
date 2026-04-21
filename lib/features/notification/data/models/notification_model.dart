import 'dart:convert';

enum NotificationType { ticket, comment, general }

extension NotificationTypeX on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.ticket:
        return 'ticket';
      case NotificationType.comment:
        return 'comment';
      case NotificationType.general:
        return 'general';
    }
  }

  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'ticket':
        return NotificationType.ticket;
      case 'comment':
        return NotificationType.comment;
      default:
        return NotificationType.general;
    }
  }
}

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.ticketId,
    this.userId,
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String? ticketId;
  final String? userId;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    String? ticketId,
    String? userId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      ticketId: ticketId ?? this.ticketId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.value,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'ticketId': ticketId,
      'userId': userId,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      type: NotificationTypeX.fromString(map['type'] as String),
      isRead: map['isRead'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      ticketId: map['ticketId'] as String?,
      userId: map['userId'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
