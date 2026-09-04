import 'dart:async';
import 'package:flutter/material.dart';
import '../enums/river_status.dart';
import '../models/river_monitoring_data.dart';
import '../utils/status_theme.dart';
import '../widgets/monitoring_header.dart';
import '../widgets/status_indicator.dart';
import '../widgets/evacuation_timer.dart';
import '../widgets/river_level_chart.dart';
import '../widgets/river_info_card.dart';
import '../widgets/alert_content.dart';

class MonitoringScreen extends StatefulWidget {
  final RiverMonitoringData initialData;

  const MonitoringScreen({super.key, required this.initialData});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  late RiverMonitoringData _data;
  Timer? _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData;
    _remainingTime = _data.evacuationTime;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void updateStatus(RiverStatus newStatus) {
    setState(() {
      _data = _data.copyWith(status: newStatus);

      // Reiniciar cuenta regresiva según el estado
      switch (newStatus) {
        case RiverStatus.critical:
          _remainingTime = const Duration(minutes: 15);
          break;
        case RiverStatus.mild:
          _remainingTime = const Duration(hours: 2);
          break;
        case RiverStatus.stable:
          _remainingTime = Duration.zero;
          break;
      }

      if (newStatus == RiverStatus.critical || newStatus == RiverStatus.mild) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = StatusTheme.fromStatus(_data.status);
    final showCountdown = _data.status == RiverStatus.critical ||
        _data.status == RiverStatus.mild;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const MonitoringHeader(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: [
                      theme.glowColor.withOpacity(0.08),
                      theme.backgroundColor,
                    ],
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 40 : 20,
                        vertical: 24,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: Column(
                            children: [
                              // Nombre del río
                              Text(
                                _data.riverName,
                                style: TextStyle(
                                  fontSize: isWide ? 32 : 24,
                                  fontWeight: FontWeight.w700,
                                  color: theme.primaryColor,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const StatusIndicator(status: RiverStatus.critical),
                              const SizedBox(height: 28),

                              // Cuenta regresiva o mensaje estable
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: showCountdown
                                    ? EvacuationTimer(
                                        key: ValueKey('timer_${_data.status}'),
                                        remainingTime: _remainingTime,
                                        status: _data.status,
                                      )
                                    : _StableMessage(key: const ValueKey('stable')),
                              ),
                              const SizedBox(height: 28),

                              // Alerta contextual
                              AlertContent(status: _data.status),
                              const SizedBox(height: 28),

                              // Gráfico de nivel del río
                              RiverLevelChart(
                                history: _data.riverLevelHistory,
                                projection: _data.riverLevelProjection,
                                currentLevel: _data.waterLevelMeters,
                                maxLevel: _data.maxLevelMeters,
                                minLevel: _data.minLevelMeters,
                                status: _data.status,
                              ),
                              const SizedBox(height: 20),

                              // Nivel actual del río
                              RiverInfoCard(
                                label: 'Nivel actual del río',
                                value: _data.waterLevelMeters.toStringAsFixed(1),
                                unit: 'm',
                                icon: Icons.water,
                                color: theme.primaryColor,
                                subtitle: 'Lectura en tiempo real',
                              ),
                              const SizedBox(height: 16),

                              // Distancia de la persona al río
                              RiverInfoCard(
                                label: 'Distancia de la persona al río',
                                value: _data.distanceMeters.toStringAsFixed(0),
                                unit: 'm',
                                icon: Icons.person_pin_circle,
                                color: theme.primaryColor,
                                subtitle: _data.personName,
                              ),
                              const SizedBox(height: 32),

                              // Botones para cambiar estado (pruebas)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _statusButton(RiverStatus.critical, 'CRÍTICO'),
                                  const SizedBox(width: 10),
                                  _statusButton(RiverStatus.mild, 'LEVE'),
                                  const SizedBox(width: 10),
                                  _statusButton(RiverStatus.stable, 'ESTABLE'),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusButton(RiverStatus status, String label) {
    final theme = StatusTheme.fromStatus(status);
    final isActive = _data.status == status;

    return GestureDetector(
      onTap: () => updateStatus(status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? theme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.primaryColor, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.black : theme.primaryColor,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _StableMessage extends StatelessWidget {
  const _StableMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00E676).withOpacity(0.3), width: 1),
      ),
      child: const Column(
        children: [
          Icon(Icons.check_circle_outline, color: Color(0xFF00E676), size: 64),
          SizedBox(height: 16),
          Text(
            'SIN RIESGO INMEDIATO',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00E676),
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}