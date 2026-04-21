import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  final String status;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final statusLower = status.toLowerCase();

    Color color;
    if (statusLower == 'open') {
      color = AppColors.statusOpen;
    } else if (statusLower == 'in progress' || statusLower == 'inprogress') {
      color = AppColors.statusInProgress;
    } else {
      color = AppColors.statusClosed;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
