import 'package:e_ticketing_helpdesk/features/ticket/data/models/ticket_model.dart';
import 'package:e_ticketing_helpdesk/features/ticket/data/repositories/dummy_ticket_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DummyTicketRepository', () {
    late DummyTicketRepository repository;

    setUp(() {
      repository = DummyTicketRepository();
    });

    test('getTickets supports status filter', () async {
      final openTickets = await repository.getTickets(
        status: TicketStatus.open,
      );

      expect(openTickets, isNotEmpty);
      expect(
        openTickets.every((item) => item.status == TicketStatus.open),
        true,
      );
    });

    test('createTicket adds a new ticket', () async {
      final created = await repository.createTicket(
        title: 'Tiket baru pengujian',
        description: 'Deskripsi testing repository',
        category: 'Software',
        priority: TicketPriority.medium,
        reporterId: 'u1',
      );

      final fetched = await repository.getTicketById(created.id);
      expect(fetched, isNotNull);
      expect(fetched?.title, 'Tiket baru pengujian');
    });

    test('addComment appends comment to ticket', () async {
      final tickets = await repository.getTickets(limit: 1);
      final ticketId = tickets.first.id;

      await repository.addComment(
        ticketId: ticketId,
        userId: 'u1',
        userName: 'Tester',
        content: 'Komentar pengujian',
      );

      final comments = await repository.getComments(ticketId);
      expect(
        comments.any((item) => item.content == 'Komentar pengujian'),
        true,
      );
    });
  });
}
