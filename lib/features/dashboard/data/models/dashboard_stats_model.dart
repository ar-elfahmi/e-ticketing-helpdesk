class DashboardStatsModel {
  const DashboardStatsModel({
    required this.totalTickets,
    required this.openCount,
    required this.inProgressCount,
    required this.closedCount,
  });

  final int totalTickets;
  final int openCount;
  final int inProgressCount;
  final int closedCount;

  factory DashboardStatsModel.empty() {
    return const DashboardStatsModel(
      totalTickets: 0,
      openCount: 0,
      inProgressCount: 0,
      closedCount: 0,
    );
  }
}
