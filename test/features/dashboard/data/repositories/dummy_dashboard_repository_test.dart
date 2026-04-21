import 'package:e_ticketing_helpdesk/features/dashboard/data/repositories/dummy_dashboard_repository.dart';
import 'package:e_ticketing_helpdesk/features/ticket/data/repositories/dummy_ticket_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DummyDashboardRepository', () {
    test('stats are calculated from ticket repository', () async {
      final ticketRepository = DummyTicketRepository();
      final repository = DummyDashboardRepository(
        ticketRepository: ticketRepository,
      );

      final stats = await repository.getStats();

      expect(stats.totalTickets, greaterThan(0));
      expect(
        stats.totalTickets,
        stats.openCount + stats.inProgressCount + stats.closedCount,
      );
    });
  });
}
