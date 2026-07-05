import 'dart:convert';

class CommentModel {
  const CommentModel({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String ticketId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  CommentModel copyWith({
    String? id,
    String? ticketId,
    String? userId,
    String? userName,
    String? content,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketId': ticketId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      ticketId: (map['ticket_id'] ?? map['ticketId']) as String,
      userId: (map['user_id'] ?? map['userId']) as String,
      userName: (map['user_name'] ?? map['userName']) as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(
        (map['created_at'] ?? map['createdAt']) as String,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
