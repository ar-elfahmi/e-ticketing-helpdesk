import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_tile_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications();
    });
  }

  Future<void> _fetchNotifications() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    await context.read<NotificationProvider>().fetchNotifications(
      userId: userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        child: Builder(
          builder: (context) {
            if (provider.isLoading && provider.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.notifications.isEmpty) {
              return const EmptyStateWidget(
                title: 'Tidak ada notifikasi',
                message: 'Update tiket akan muncul di sini.',
                icon: Icons.notifications_none,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return NotificationTileWidget(
                  notification: notification,
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    final ticketId = notification.ticketId;

                    await provider.markAsRead(notification.id);

                    if (!mounted || ticketId == null) {
                      return;
                    }

                    navigator.pushNamed(
                      AppRoutes.ticketDetail,
                      arguments: ticketId,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
