import '../models/dashboard_stats_model.dart';
import '../../../ticket/data/models/ticket_model.dart';
import '../../../ticket/data/repositories/ticket_repository.dart';
import 'dashboard_repository.dart';

class DummyDashboardRepository implements DashboardRepository {
  DummyDashboardRepository({required TicketRepository ticketRepository})
    : _ticketRepository = ticketRepository;

  final TicketRepository _ticketRepository;

  @override
  Future<DashboardStatsModel> getStats({String? reporterId}) async {
    final tickets = await _ticketRepository.getTickets(
      page: 1,
      limit: 1000,
      reporterId: reporterId,
    );

    final openCount = tickets
        .where((item) => item.status == TicketStatus.open)
        .length;
    final inProgressCount = tickets
        .where((item) => item.status == TicketStatus.inProgress)
        .length;
    final closedCount = tickets
        .where((item) => item.status == TicketStatus.closed)
        .length;

    return DashboardStatsModel(
      totalTickets: tickets.length,
      openCount: openCount,
      inProgressCount: inProgressCount,
      closedCount: closedCount,
    );
  }

  @override
  Future<List<TicketModel>> getRecentTickets({
    String? reporterId,
    int limit = 5,
  }) async {
    final tickets = await _ticketRepository.getTickets(
      page: 1,
      limit: 1000,
      reporterId: reporterId,
    );

    final sorted = [...tickets]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    if (sorted.length <= limit) {
      return sorted;
    }
    return sorted.sublist(0, limit);
  }
}
