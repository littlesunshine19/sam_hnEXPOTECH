import '../enums/river_status.dart';
import '../models/river_monitoring_data.dart';

class MockDataGenerator {
  /// Genera un ejemplo de datos en estado CRÍTICO para pruebas
  static RiverMonitoringData get criticalExample {
    final now = DateTime.now();
    
    // Generamos 24 puntos de datos (cada 2 horas = 48 horas de histórico)
    final levels = [
      0.7, 0.9, 0.85, 1.0, 1.15, 1.18, 1.0, 0.85, 0.75, 0.7,
      0.5, 0.45, 0.35, 0.4, 0.5, 0.65, 0.8, 0.95, 1.05, 1.15,
      1.18, 1.1, 0.95, 0.85
    ];

    final history = List.generate(levels.length, (i) {
      return RiverLevelPoint(
        timestamp: now.subtract(Duration(hours: 48 - (i * 2))),
        levelMeters: levels[i],
        isProjection: false,
      );
    });

    return RiverMonitoringData(
      riverName: 'Río Choluteca',
      personName: 'Milagros Bohorquez',
      distanceMeters: 125,
      waterLevelMeters: 1.18,
      status: RiverStatus.critical,
      evacuationTime: const Duration(minutes: 15),
      riverLevelHistory: history,
      riverLevelProjection: [
        RiverLevelPoint(timestamp: now, levelMeters: 0.85, isProjection: false),
        RiverLevelPoint(timestamp: now.add(const Duration(hours: 2)), levelMeters: 0.5, isProjection: true),
        RiverLevelPoint(timestamp: now.add(const Duration(hours: 4)), levelMeters: 0.3, isProjection: true),
      ],
      maxLevelMeters: 1.5,
      minLevelMeters: 0.2,
    );
  }

  /// Genera un ejemplo de datos en estado ESTABLE para pruebas
  static RiverMonitoringData get stableExample {
    final now = DateTime.now();
    
    return RiverMonitoringData(
      riverName: 'Río Choluteca',
      personName: 'Milagros Bohorquez',
      distanceMeters: 1250,
      waterLevelMeters: 0.45,
      status: RiverStatus.stable,
      evacuationTime: Duration.zero,
      riverLevelHistory: [
        RiverLevelPoint(timestamp: now.subtract(const Duration(hours: 2)), levelMeters: 0.48, isProjection: false),
        RiverLevelPoint(timestamp: now, levelMeters: 0.45, isProjection: false),
      ],
      riverLevelProjection: [
        RiverLevelPoint(timestamp: now.add(const Duration(hours: 2)), levelMeters: 0.42, isProjection: true),
      ],
      maxLevelMeters: 1.5,
      minLevelMeters: 0.2,
    );
  }
}
