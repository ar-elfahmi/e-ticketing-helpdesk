import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/notification_model.dart';

class NotificationTileWidget extends StatelessWidget {
  const NotificationTileWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = switch (notification.type) {
      NotificationType.ticket => Icons.confirmation_number_outlined,
      NotificationType.comment => Icons.chat_bubble_outline,
      NotificationType.general => Icons.notifications_none,
    };

    return ListTile(
      onTap: onTap,
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(child: Icon(icon)),
          if (!notification.isRead)
            const Positioned(
              right: -1,
              top: -1,
              child: CircleAvatar(radius: 5, backgroundColor: Colors.red),
            ),
        ],
      ),
      title: Text(notification.title),
      subtitle: Text(
        notification.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        DateFormat('dd/MM HH:mm').format(notification.createdAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
