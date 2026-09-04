import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/status_theme.dart';
import '../enums/river_status.dart';

class EvacuationTimer extends StatefulWidget {
  final Duration initialTime;
  final RiverStatus status;

  const EvacuationTimer({
    super.key,
    required this.initialTime,
    required this.status,
  });

  @override
  State<EvacuationTimer> createState() => _EvacuationTimerState();
}

class _EvacuationTimerState extends State<EvacuationTimer> {
  late Duration _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialTime;
    _startTimer();
  }

  @override
  void didUpdateWidget(EvacuationTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el estado o el tiempo inicial cambian desde el padre (ej. al tocar un botón de prueba),
    // reiniciamos el temporizador automáticamente.
    if (oldWidget.initialTime != widget.initialTime || oldWidget.status != widget.status) {
      setState(() {
        _remainingTime = widget.initialTime;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    
    // No iniciar el timer si el estado es estable
    if (widget.status == RiverStatus.stable) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime -= const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 1. Crucial: evita memory leaks al destruir el widget
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative || duration.inSeconds == 0) {
      return '00:00:00';
    }
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = StatusTheme.fromStatus(widget.status);

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
            _formatDuration(_remainingTime), // 2. Usa el estado local, no el del padre
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'monospace',
              letterSpacing: 6,
              height: 1.0, // 3. Mejora la alineación vertical del texto monoespaciado
            ).copyWith(
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
