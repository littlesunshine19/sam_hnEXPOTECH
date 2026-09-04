enum RiverStatus {
  critical,
  mild,
  stable;

  String get displayName {
    switch (this) {
      case RiverStatus.critical:
        return 'CRÍTICO';
      case RiverStatus.mild:
        return 'LEVE';
      case RiverStatus.stable:
        return 'ESTABLE';
    }
  }

  String get description {
    switch (this) {
      case RiverStatus.critical:
        return '¡ALERTA CRÍTICA!\nExiste riesgo por la cercanía al río.';
      case RiverStatus.mild:
        return 'Precaución: el nivel del río requiere monitoreo.\nMantente atento a los cambios en las condiciones.';
      case RiverStatus.stable:
        return 'Condiciones estables.\nNo hay riesgo inmediato.';
    }
  }
}