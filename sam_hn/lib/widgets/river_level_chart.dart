import 'package:flutter/material.dart';
import '../models/river_monitoring_data.dart';
import '../utils/status_theme.dart';
import '../enums/river_status.dart';

class RiverLevelChart extends StatelessWidget {
  final List<RiverLevelPoint> history;
  final List<RiverLevelPoint> projection;
  final double currentLevel;
  final double maxLevel;
  final double minLevel;
  final RiverStatus status;

  const RiverLevelChart({
    super.key,
    required this.history,
    required this.projection,
    required this.currentLevel,
    required this.maxLevel,
    required this.minLevel,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = StatusTheme.fromStatus(status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E2A3A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leyenda
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: theme.chartLineColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Histórico',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.chartLineColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  color: theme.chartLineColor.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Proyección',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.chartLineColor.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'm',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Gráfico
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: Size.infinite,
              painter: _RiverLevelChartPainter(
                history: history,
                projection: projection,
                maxLevel: maxLevel,
                minLevel: minLevel,
                currentLevel: currentLevel,
                lineColor: theme.chartLineColor,
                fillColor: theme.chartFillColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Proyección local - lectura actual en metros',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiverLevelChartPainter extends CustomPainter {
  final List<RiverLevelPoint> history;
  final List<RiverLevelPoint> projection;
  final double maxLevel;
  final double minLevel;
  final double currentLevel;
  final Color lineColor;
  final Color fillColor;

  _RiverLevelChartPainter({
    required this.history,
    required this.projection,
    required this.maxLevel,
    required this.minLevel,
    required this.currentLevel,
    required this.lineColor,
    required this.fillColor,
  });

     @override
  void paint(Canvas canvas, Size size) {
    final allPoints = [...history, ...projection];
    
    // 1. Validar que existan datos para evitar errores
    if (allPoints.isEmpty) {
      _drawNoDataMessage(canvas, size);
      return;
    }

    final range = maxLevel - minLevel;
    
    // 2. Evitar división por cero (NaN) si el rango es inválido
    if (range <= 0) {
      _drawNoDataMessage(canvas, size, message: 'Rango de datos inválido');
      return;
    }

    final leftPadding = 40.0;
    final rightPadding = 10.0;
    final topPadding = 10.0;
    final bottomPadding = 25.0;
    
    // 3. Proteger contra dimensiones negativas si el widget se comprime demasiado
    final chartWidth = (size.width - leftPadding - rightPadding).clamp(0.0, double.infinity);
    final chartHeight = (size.height - topPadding - bottomPadding).clamp(0.0, double.infinity);

    if (chartWidth <= 0 || chartHeight <= 0) return;

    // 4. Usar un Set para evitar líneas de referencia duplicadas y ordenarlas
    final referenceLevels = {minLevel, 0.5, 0.8, 1.2, maxLevel}.toList()..sort();
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    for (final level in referenceLevels) {
      if (level < minLevel || level > maxLevel) continue;
      
      final y = topPadding + chartHeight - ((level - minLevel) / range) * chartHeight;

      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );

      textPainter.text = TextSpan(
        // 5. Formato consistente de 1 decimal para el eje Y
        text: '${level.toStringAsFixed(1)} m', 
        style: const TextStyle(
          color: Colors.white54, // Más limpio y performante que withOpacity(0.6)
          fontSize: 11,
        ),
      );
      textPainter.layout();
      // 6. Centrada verticalmente con la línea, sin números mágicos como 'y - 7'
      textPainter.paint(canvas, Offset(0, y - (textPainter.height / 2)));
    }

    // Etiquetas del eje X
    textPainter.text = const TextSpan(
      text: '48h',
      style: TextStyle(color: Colors.white54, fontSize: 11),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(leftPadding, size.height - bottomPadding + 5));

    textPainter.text = const TextSpan(
      text: 'Ahora',
      style: TextStyle(color: Colors.white54, fontSize: 11),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - rightPadding - 40, size.height - bottomPadding + 5));

    // 7. Función segura: evita división por cero si total == 1
    Offset pointToOffset(RiverLevelPoint point, int index, int total) {
      final xRatio = total > 1 ? (index / (total - 1)) : 0.0;
      final x = leftPadding + xRatio * chartWidth;
      final y = topPadding + chartHeight - ((point.levelMeters - minLevel) / range) * chartHeight;
      return Offset(x, y);
    }

    // Dibujar área de relleno bajo la línea histórica
    if (history.length > 1) {
      final fillPath = Path();
      final firstOffset = pointToOffset(history.first, 0, allPoints.length);
      fillPath.moveTo(firstOffset.dx, topPadding + chartHeight);
      fillPath.lineTo(firstOffset.dx, firstOffset.dy);

      for (int i = 0; i < history.length; i++) {
        final offset = pointToOffset(history[i], i, allPoints.length);
        fillPath.lineTo(offset.dx, offset.dy);
      }

      final lastHistoryOffset = pointToOffset(history.last, history.length - 1, allPoints.length);
      fillPath.lineTo(lastHistoryOffset.dx, topPadding + chartHeight);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            fillColor.withOpacity(0.3),
            fillColor.withOpacity(0.02),
          ],
        ).createShader(
          Rect.fromLTWH(leftPadding, topPadding, chartWidth, chartHeight),
        );

      canvas.drawPath(fillPath, fillPaint);
    }

    // Dibujar línea histórica
    if (history.length > 1) {
      final linePaint = Paint()
        ..color = lineColor
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      final firstOffset = pointToOffset(history.first, 0, allPoints.length);
      path.moveTo(firstOffset.dx, firstOffset.dy);

      for (int i = 1; i < history.length; i++) {
        final offset = pointToOffset(history[i], i, allPoints.length);
        path.lineTo(offset.dx, offset.dy);
      }

      canvas.drawPath(path, linePaint);
    }

    // Dibujar línea de proyección (punteada)
    if (projection.length > 1) {
      final dashPaint = Paint()
        ..color = lineColor.withOpacity(0.6)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // 8. Manejo seguro si history está vacío (fallback a 0)
      final startIndex = history.isEmpty ? 0 : history.length - 1;
      final path = Path();
      final firstOffset = pointToOffset(projection.first, startIndex, allPoints.length);
      path.moveTo(firstOffset.dx, firstOffset.dy);

      for (int i = 1; i < projection.length; i++) {
        final offset = pointToOffset(projection[i], startIndex + i, allPoints.length);
        path.lineTo(offset.dx, offset.dy);
      }

      // Dibujar con efecto punteado
      const dashLength = 6.0; // 9. Uso de 'const' para micro-optimización
      const gapLength = 4.0;
      final metrics = path.computeMetrics();
      for (final metric in metrics) {
        double distance = 0;
        while (distance < metric.length) {
          final end = (distance + dashLength).clamp(0.0, metric.length);
          final segment = metric.extractPath(distance, end);
          canvas.drawPath(segment, dashPaint);
          distance += dashLength + gapLength;
        }
      }
    }

    // Marcar nivel actual con un punto
    if (history.isNotEmpty) {
      final currentOffset = pointToOffset(history.last, history.length - 1, allPoints.length);
      final dotPaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(currentOffset, 5, dotPaint);

      // Halo alrededor del punto
      final haloPaint = Paint()
        ..color = lineColor.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentOffset, 10, haloPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RiverLevelChartPainter oldDelegate) {
    // 10. Verificación completa: antes faltaban maxLevel, minLevel y colores
    return oldDelegate.currentLevel != currentLevel ||
        oldDelegate.history != history ||
        oldDelegate.projection != projection ||
        oldDelegate.maxLevel != maxLevel ||
        oldDelegate.minLevel != minLevel ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }

  // Método auxiliar para mantener el código limpio
  void _drawNoDataMessage(Canvas canvas, Size size, {String message = 'Sin datos disponibles'}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: message,
        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );
  }
