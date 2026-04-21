import '../models/dashboard_stats_model.dart';
import '../../../ticket/data/models/ticket_model.dart';

abstract class DashboardRepository {
  Future<DashboardStatsModel> getStats({String? reporterId});

  Future<List<TicketModel>> getRecentTickets({
    String? reporterId,
    int limit = 5,
  });
}
