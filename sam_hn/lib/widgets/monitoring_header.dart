import 'package:flutter/material.dart';

class MonitoringHeader extends StatelessWidget {
  const MonitoringHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2A2A2A), width: 1),
        ),
      ),
      child: const Text(
        'SAM HN',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}