import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/status_badge.dart';
import '../../../ticket/data/models/ticket_model.dart';

class RecentTicketWidget extends StatelessWidget {
  const RecentTicketWidget({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  final TicketModel ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('dd MMM yyyy').format(ticket.createdAt);

    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(ticket.ticketNumber),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticket.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(dateText),
          ],
        ),
        trailing: StatusBadge(status: ticket.status.label),
      ),
    );
  }
}
