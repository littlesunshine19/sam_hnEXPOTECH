import 'package:flutter/material.dart';
import '../utils/status_theme.dart';
import '../enums/river_status.dart';

class EvacuationTimer extends StatelessWidget {
  final Duration remainingTime;
  final RiverStatus status;

  const EvacuationTimer({
    super.key,
    required this.remainingTime,
    required this.status,
  });

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return '00:00:00';
    }
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = StatusTheme.fromStatus(status);

    return Column(
      children: [
        Text(
          'TIEMPO PARA EVACUAR',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.primaryColor.withOpacity(0.8),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.primaryColor.withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.glowColor.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            _formatDuration(remainingTime),
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'monospace',
              letterSpacing: 6,
              shadows: [
                Shadow(
                  color: theme.glowColor.withOpacity(0.8),
                  blurRadius: 20,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
