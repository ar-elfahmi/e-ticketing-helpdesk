import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/supabase_config.dart';
import '../models/comment_model.dart';
import '../models/ticket_model.dart';
import 'ticket_repository.dart';

class SupabaseTicketRepository implements TicketRepository {
  late final SupabaseClient _supabase;

  SupabaseTicketRepository() {
    _supabase = SupabaseConfig.client;
  }

  @override
  Future<List<TicketModel>> getTickets({
    TicketStatus? status,
    String query = '',
    int page = 1,
    int limit = 10,
    String? reporterId,
  }) async {
    final searchQuery = query;
    var q = _supabase.from('tickets').select('*');

    q = q.isFilter('deleted_at', null);

    if (status != null) {
      q = q.eq('status', status.value);
    }

    if (reporterId != null) {
      q = q.eq('reporter_id', reporterId);
    }

    if (searchQuery.isNotEmpty) {
      q = q.or(
        'ticket_number.ilike.%$searchQuery%,title.ilike.%$searchQuery%,category.ilike.%$searchQuery%',
      );
    }

    final response = await q
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);
    return (response as List)
        .map((e) => TicketModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TicketModel?> getTicketById(String ticketId) async {
    final response = await _supabase
        .from('tickets')
        .select('*')
        .eq('id', ticketId)
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (response == null) return null;
    return TicketModel.fromMap(response);
  }

  @override
  Future<TicketModel> createTicket({
    required String title,
    required String description,
    required String category,
    required TicketPriority priority,
    required String reporterId,
    List<String> attachments = const [],
  }) async {
    final initialHistory = [
      StatusHistory(
        status: TicketStatus.open,
        changedBy: reporterId,
        changedAt: DateTime.now(),
        note: 'Ticket created',
      ),
    ];

    final response = await _supabase
        .from('tickets')
        .insert({
          'title': title,
          'description': description,
          'category': category,
          'priority': priority.value,
          'status': TicketStatus.open.value,
          'reporter_id': reporterId,
          'attachments': attachments,
          'history': initialHistory.map((e) => e.toMap()).toList(),
        })
        .select()
        .single();

    return TicketModel.fromMap(response);
  }

  @override
  Future<TicketModel?> updateStatus({
    required String ticketId,
    required TicketStatus status,
    required String updatedBy,
    String? note,
  }) async {
    final current = await getTicketById(ticketId);
    if (current == null) return null;

    final historyEntry = StatusHistory(
      status: status,
      changedBy: updatedBy,
      changedAt: DateTime.now(),
      note: note,
    );

    final updatedHistory = [...current.history, historyEntry];

    final response = await _supabase
        .from('tickets')
        .update({
          'status': status.value,
          'history': updatedHistory.map((e) => e.toMap()).toList(),
        })
        .eq('id', ticketId)
        .select()
        .single();

    return TicketModel.fromMap(response);
  }

  @override
  Future<TicketModel?> assignTicket({
    required String ticketId,
    required String assigneeId,
    required String updatedBy,
  }) async {
    final current = await getTicketById(ticketId);
    if (current == null) return null;

    final historyEntry = StatusHistory(
      status: current.status,
      changedBy: updatedBy,
      changedAt: DateTime.now(),
      note: 'Assigned to $assigneeId',
    );

    final updatedHistory = [...current.history, historyEntry];

    final response = await _supabase
        .from('tickets')
        .update({
          'assignee_id': assigneeId,
          'history': updatedHistory.map((e) => e.toMap()).toList(),
        })
        .eq('id', ticketId)
        .select()
        .single();

    return TicketModel.fromMap(response);
  }

  @override
  Future<CommentModel> addComment({
    required String ticketId,
    required String userId,
    required String userName,
    required String content,
  }) async {
    final response = await _supabase
        .from('comments')
        .insert({
          'ticket_id': ticketId,
          'user_id': userId,
          'user_name': userName,
          'content': content,
        })
        .select()
        .single();

    return CommentModel.fromMap(response);
  }

  @override
  Future<List<CommentModel>> getComments(String ticketId) async {
    final response = await _supabase
        .from('comments')
        .select('*')
        .eq('ticket_id', ticketId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((e) => CommentModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<String> uploadAttachment(Uint8List bytes, String fileName) async {
    final path = 'tickets/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final dotIndex = fileName.lastIndexOf('.');
    final ext = dotIndex >= 0 ? fileName.substring(dotIndex + 1) : '';

    await _supabase.storage.from('ticket-attachments').uploadBinary(
      path,
      bytes,
      fileOptions: FileOptions(
        contentType: _getContentType(ext),
      ),
    );

    final url = _supabase.storage.from('ticket-attachments').getPublicUrl(path);
    return url;
  }

  String _getContentType(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Future<bool> deleteTicket(String ticketId) async {
    try {
      await _supabase
          .from('tickets')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', ticketId);
      return true;
    } catch (_) {
      return false;
    }
  }

}
