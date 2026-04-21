import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/ticket_model.dart';

class TicketStatusTimeline extends StatelessWidget {
  const TicketStatusTimeline({super.key, required this.history});

  final List<StatusHistory> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: List.generate(history.length, (index) {
        final item = history[index];
        final isLast = index == history.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 46,
                    color: Theme.of(context).dividerColor,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.status.label,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.changedBy} - ${DateFormat('dd MMM yyyy, HH:mm').format(item.changedAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (item.note != null && item.note!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(item.note!),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
