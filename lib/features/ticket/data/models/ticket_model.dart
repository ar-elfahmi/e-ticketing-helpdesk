import 'dart:convert';

enum TicketStatus { open, inProgress, closed }

enum TicketPriority { low, medium, high, critical }

extension TicketStatusX on TicketStatus {
  String get value {
    switch (this) {
      case TicketStatus.open:
        return 'open';
      case TicketStatus.inProgress:
        return 'inProgress';
      case TicketStatus.closed:
        return 'closed';
    }
  }

  String get label {
    switch (this) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  static TicketStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'inprogress':
      case 'in_progress':
      case 'in progress':
        return TicketStatus.inProgress;
      case 'closed':
        return TicketStatus.closed;
      default:
        return TicketStatus.open;
    }
  }
}

extension TicketPriorityX on TicketPriority {
  String get value {
    switch (this) {
      case TicketPriority.low:
        return 'low';
      case TicketPriority.medium:
        return 'medium';
      case TicketPriority.high:
        return 'high';
      case TicketPriority.critical:
        return 'critical';
    }
  }

  String get label {
    switch (this) {
      case TicketPriority.low:
        return 'Low';
      case TicketPriority.medium:
        return 'Medium';
      case TicketPriority.high:
        return 'High';
      case TicketPriority.critical:
        return 'Critical';
    }
  }

  static TicketPriority fromString(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return TicketPriority.low;
      case 'high':
        return TicketPriority.high;
      case 'critical':
        return TicketPriority.critical;
      default:
        return TicketPriority.medium;
    }
  }
}

class StatusHistory {
  const StatusHistory({
    required this.status,
    required this.changedBy,
    required this.changedAt,
    this.note,
  });

  final TicketStatus status;
  final String changedBy;
  final DateTime changedAt;
  final String? note;

  StatusHistory copyWith({
    TicketStatus? status,
    String? changedBy,
    DateTime? changedAt,
    String? note,
  }) {
    return StatusHistory(
      status: status ?? this.status,
      changedBy: changedBy ?? this.changedBy,
      changedAt: changedAt ?? this.changedAt,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.value,
      'changedBy': changedBy,
      'changedAt': changedAt.toIso8601String(),
      'note': note,
    };
  }

  factory StatusHistory.fromMap(Map<String, dynamic> map) {
    return StatusHistory(
      status: TicketStatusX.fromString(map['status'] as String),
      changedBy: map['changedBy'] as String,
      changedAt: DateTime.parse(map['changedAt'] as String),
      note: map['note'] as String?,
    );
  }
}

class TicketModel {
  const TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.reporterId,
    this.assigneeId,
    this.attachments = const [],
    this.history = const [],
  });

  final String id;
  final String ticketNumber;
  final String title;
  final String description;
  final String category;
  final TicketPriority priority;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String reporterId;
  final String? assigneeId;
  final List<String> attachments;
  final List<StatusHistory> history;

  TicketModel copyWith({
    String? id,
    String? ticketNumber,
    String? title,
    String? description,
    String? category,
    TicketPriority? priority,
    TicketStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? reporterId,
    String? assigneeId,
    List<String>? attachments,
    List<StatusHistory>? history,
  }) {
    return TicketModel(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reporterId: reporterId ?? this.reporterId,
      assigneeId: assigneeId ?? this.assigneeId,
      attachments: attachments ?? this.attachments,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority.value,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'reporterId': reporterId,
      'assigneeId': assigneeId,
      'attachments': attachments,
      'history': history.map((item) => item.toMap()).toList(),
    };
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] as String,
      ticketNumber: map['ticketNumber'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      priority: TicketPriorityX.fromString(map['priority'] as String),
      status: TicketStatusX.fromString(map['status'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      reporterId: map['reporterId'] as String,
      assigneeId: map['assigneeId'] as String?,
      attachments: List<String>.from(
        map['attachments'] as List<dynamic>? ?? [],
      ),
      history: (map['history'] as List<dynamic>? ?? [])
          .map((item) => StatusHistory.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketModel.fromJson(String source) =>
      TicketModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
