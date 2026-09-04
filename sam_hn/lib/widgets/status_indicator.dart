import 'package:flutter/material.dart';
import '../enums/river_status.dart';
import '../utils/status_theme.dart';

class StatusIndicator extends StatelessWidget {
  final RiverStatus status;

  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = StatusTheme.fromStatus(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.primaryColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(theme.icon, color: theme.primaryColor, size: 18),
          const SizedBox(width: 8),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}