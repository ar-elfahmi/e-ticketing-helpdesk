import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/status_badge.dart';
import '../../data/models/ticket_model.dart';

class TicketCardWidget extends StatelessWidget {
  const TicketCardWidget({
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
        title: Text('${ticket.ticketNumber} - ${ticket.title}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(ticket.category, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 2),
            Text(dateText, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        trailing: StatusBadge(status: ticket.status.label),
      ),
    );
  }
}
