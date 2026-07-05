import 'dart:typed_data';

import '../models/comment_model.dart';
import '../models/ticket_model.dart';

abstract class TicketRepository {
  Future<List<TicketModel>> getTickets({
    TicketStatus? status,
    String query = '',
    int page = 1,
    int limit = 10,
    String? reporterId,
  });

  Future<TicketModel?> getTicketById(String ticketId);

  Future<TicketModel> createTicket({
    required String title,
    required String description,
    required String category,
    required TicketPriority priority,
    required String reporterId,
    List<String> attachments,
  });

  Future<TicketModel?> updateStatus({
    required String ticketId,
    required TicketStatus status,
    required String updatedBy,
    String? note,
  });

  Future<TicketModel?> assignTicket({
    required String ticketId,
    required String assigneeId,
    required String updatedBy,
  });

  Future<CommentModel> addComment({
    required String ticketId,
    required String userId,
    required String userName,
    required String content,
  });

  Future<List<CommentModel>> getComments(String ticketId);

  Future<String> uploadAttachment(Uint8List bytes, String fileName);
}
