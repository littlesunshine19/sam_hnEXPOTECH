import 'package:flutter/material.dart';
import '../enums/river_status.dart';

class StatusTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color glowColor;
  final Color chartLineColor;
  final Color chartFillColor;
  final IconData icon;

  const StatusTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.glowColor,
    required this.chartLineColor,
    required this.chartFillColor,
    required this.icon,
  });

  static StatusTheme fromStatus(RiverStatus status) {
    switch (status) {
      case RiverStatus.critical:
        return const StatusTheme(
          primaryColor: Color(0xFFFF1744),
          secondaryColor: Color(0xFFB71C1C),
          backgroundColor: Color(0xFF0A0000),
          glowColor: Color(0xFFFF1744),
          chartLineColor: Color(0xFFFF1744),
          chartFillColor: Color(0xFFFF1744),
          icon: Icons.warning_amber_rounded,
        );
      case RiverStatus.mild:
        return const StatusTheme(
          primaryColor: Color(0xFFFFC107),
          secondaryColor: Color(0xFFFF8F00),
          backgroundColor: Color(0xFF0F0D00),
          glowColor: Color(0xFFFFC107),
          chartLineColor: Color(0xFFFFC107),
          chartFillColor: Color(0xFFFFC107),
          icon: Icons.warning_rounded,
        );
      case RiverStatus.stable:
        return const StatusTheme(
          primaryColor: Color(0xFF00E676),
          secondaryColor: Color(0xFF00C853),
          backgroundColor: Color(0xFF001108),
          glowColor: Color(0xFF00E676),
          chartLineColor: Color(0xFF00E676),
          chartFillColor: Color(0xFF00E676),
          icon: Icons.check_circle_outline,
        );
    }
  }
}