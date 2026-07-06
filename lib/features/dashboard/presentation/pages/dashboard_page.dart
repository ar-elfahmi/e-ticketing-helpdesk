import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notification/presentation/providers/notification_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/recent_ticket_widget.dart';
import '../widgets/stats_card_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final authUser = context.read<AuthProvider>().currentUser;
    final isUser = authUser?.role == UserRole.user;

    await Future.wait([
      context.read<DashboardProvider>().fetchDashboard(
        reporterId: isUser ? authUser?.id : null,
      ),
      context.read<NotificationProvider>().fetchNotifications(
        userId: authUser?.id,
      ),
    ]);

    if (authUser?.id != null) {
      context.read<NotificationProvider>().subscribeToRealtime(authUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthProvider>().currentUser;
    final dashboardProvider = context.watch<DashboardProvider>();
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notification);
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none),
                if (notificationProvider.unreadCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        notificationProvider.unreadCount > 9
                            ? '9+'
                            : '${notificationProvider.unreadCount}',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              child: Text(authUser?.name.substring(0, 1).toUpperCase() ?? '?'),
            ),
          ),
        ],
      ),
      floatingActionButton: authUser?.role == UserRole.user
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.of(context).pushNamed(AppRoutes.createTicket);
                if (mounted) {
                  _fetchData();
                }
              },
              label: const Text('Buat Tiket Baru'),
              icon: const Icon(Icons.add),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      child: Icon(Icons.handshake_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, ${authUser?.name ?? 'Pengguna'}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(authUser?.role.displayName ?? '-'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (dashboardProvider.isLoading &&
                dashboardProvider.recentTickets.isEmpty)
              const LoadingWidget(height: 112, itemCount: 4)
            else
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  StatsCardWidget(
                    label: 'Total Tiket',
                    value: dashboardProvider.stats.totalTickets,
                    icon: Icons.dataset_outlined,
                    color: AppColors.primary,
                  ),
                  StatsCardWidget(
                    label: 'Open',
                    value: dashboardProvider.stats.openCount,
                    icon: Icons.mark_email_unread_outlined,
                    color: AppColors.statusOpen,
                  ),
                  StatsCardWidget(
                    label: 'In Progress',
                    value: dashboardProvider.stats.inProgressCount,
                    icon: Icons.hourglass_top_outlined,
                    color: AppColors.statusInProgress,
                  ),
                  StatsCardWidget(
                    label: 'Closed',
                    value: dashboardProvider.stats.closedCount,
                    icon: Icons.verified_outlined,
                    color: AppColors.statusClosed,
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Text(
              'Tiket Terbaru',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (!dashboardProvider.isLoading &&
                dashboardProvider.recentTickets.isEmpty)
              const EmptyStateWidget(
                title: 'Belum ada tiket',
                message: 'Tiket terbaru akan muncul di sini.',
              )
            else
              ...dashboardProvider.recentTickets.map(
                (ticket) => RecentTicketWidget(
                  ticket: ticket,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.ticketDetail, arguments: ticket.id);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
