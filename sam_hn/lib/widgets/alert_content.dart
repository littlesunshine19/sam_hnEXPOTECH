import 'package:flutter/material.dart';
import '../enums/river_status.dart';
import '../utils/status_theme.dart';

class AlertContent extends StatelessWidget {
  final RiverStatus status;

  const AlertContent({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = StatusTheme.fromStatus(status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(theme.icon, color: theme.primaryColor, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              status.description,
              style: TextStyle(
                fontSize: 14,
                color: theme.primaryColor.withOpacity(0.9),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}