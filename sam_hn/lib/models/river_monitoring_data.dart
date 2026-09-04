import '../enums/river_status.dart';

/// Punto de datos para el gráfico de nivel del río
class RiverLevelPoint {
  final DateTime timestamp;
  final double levelMeters;
  final bool isProjection;

  const RiverLevelPoint({
    required this.timestamp,
    required this.levelMeters,
    this.isProjection = false,
  });
}

class RiverMonitoringData {
  final String riverName;
  final String personName;
  final double distanceMeters;
  final double waterLevelMeters;
  final RiverStatus status;

  /// Tiempo restante para evacuar (cuenta regresiva)
  final Duration evacuationTime;

  /// Datos históricos y de proyección del nivel del río
  final List<RiverLevelPoint> riverLevelHistory;
  final List<RiverLevelPoint> riverLevelProjection;

  /// Nivel máximo de referencia (para el eje Y del gráfico)
  final double maxLevelMeters;

  /// Nivel mínimo de referencia (para el eje Y del gráfico)
  final double minLevelMeters;

  const RiverMonitoringData({
    required this.riverName,
    required this.personName,
    required this.distanceMeters,
    required this.waterLevelMeters,
    required this.status,
    required this.evacuationTime,
    required this.riverLevelHistory,
    required this.riverLevelProjection,
    this.maxLevelMeters = 1.5,
    this.minLevelMeters = 0.2,
  });

  RiverMonitoringData copyWith({
    RiverStatus? status,
    Duration? evacuationTime,
    List<RiverLevelPoint>? riverLevelHistory,
    List<RiverLevelPoint>? riverLevelProjection,
    double? waterLevelMeters,
  }) {
    return RiverMonitoringData(
      riverName: riverName,
      personName: personName,
      distanceMeters: distanceMeters,
      waterLevelMeters: waterLevelMeters ?? this.waterLevelMeters,
      status: status ?? this.status,
      evacuationTime: evacuationTime ?? this.evacuationTime,
      riverLevelHistory: riverLevelHistory ?? this.riverLevelHistory,
      riverLevelProjection: riverLevelProjection ?? this.riverLevelProjection,
      maxLevelMeters: maxLevelMeters,
      minLevelMeters: minLevelMeters,
    );
  }
}