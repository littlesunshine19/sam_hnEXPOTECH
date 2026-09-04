import 'package:flutter/material.dart';
import 'enums/river_status.dart';
import 'models/river_monitoring_data.dart';
import 'screens/monitoring_screen.dart';

void main() {
  runApp(const SAMHNApp());
}

class SAMHNApp extends StatelessWidget {
  const SAMHNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAM HN - Monitor de Ríos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF1744),
          brightness: Brightness.dark,
        ),
      ),
      home: MonitoringScreen(initialData: _buildCriticalExample()),
    );
  }

  /// Genera datos de ejemplo para el gráfico (48h histórico + proyección)
  List<RiverLevelPoint> _buildHistory() {
    final now = DateTime.now();
    final points = <RiverLevelPoint>[];

    // 48 horas de histórico, cada 2 horas
    final levels = [
      0.7, 0.9, 0.85, 1.0, 1.15, 1.18, 1.0, 0.85, 0.75, 0.7,
      0.5, 0.45, 0.35, 0.4, 0.5, 0.65, 0.8, 0.95, 1.05, 1.15,
      1.18, 1.1, 0.95, 0.85
    ];

    for (int i = 0; i < levels.length; i++) {
      points.add(RiverLevelPoint(
        timestamp: now.subtract(Duration(hours: 48 - (i * 2))),
        levelMeters: levels[i],
        isProjection: false,
      ));
    }
    return points;
  }

  List<RiverLevelPoint> _buildProjection() {
    final now = DateTime.now();
    return [
      RiverLevelPoint(timestamp: now, levelMeters: 0.85, isProjection: false),
      RiverLevelPoint(
        timestamp: now.add(const Duration(hours: 2)),
        levelMeters: 0.5,
        isProjection: true,
      ),
      RiverLevelPoint(
        timestamp: now.add(const Duration(hours: 4)),
        levelMeters: 0.3,
        isProjection: true,
      ),
    ];
  }

  RiverMonitoringData _buildCriticalExample() {
    return RiverMonitoringData(
      riverName: 'Río Choluteca',
      personName: 'Milagros Bohorquez',
      distanceMeters: 125,
      waterLevelMeters: 1.18,
      status: RiverStatus.critical,
      evacuationTime: const Duration(minutes: 15),
      riverLevelHistory: _buildHistory(),
      riverLevelProjection: _buildProjection(),
      maxLevelMeters: 1.5,
      minLevelMeters: 0.2,
    );
  }
}