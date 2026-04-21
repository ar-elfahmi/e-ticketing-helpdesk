import 'package:flutter/foundation.dart';

import '../../../ticket/data/models/ticket_model.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/repositories/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider({required DashboardRepository dashboardRepository})
    : _dashboardRepository = dashboardRepository;

  final DashboardRepository _dashboardRepository;

  DashboardStatsModel _stats = DashboardStatsModel.empty();
  List<TicketModel> _recentTickets = [];
  bool _isLoading = false;

  DashboardStatsModel get stats => _stats;
  List<TicketModel> get recentTickets => _recentTickets;
  bool get isLoading => _isLoading;

  Future<void> fetchDashboard({String? reporterId}) async {
    _isLoading = true;
    notifyListeners();

    _stats = await _dashboardRepository.getStats(reporterId: reporterId);
    _recentTickets = await _dashboardRepository.getRecentTickets(
      reporterId: reporterId,
      limit: 5,
    );

    _isLoading = false;
    notifyListeners();
  }
}
