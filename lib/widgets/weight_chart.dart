import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Lightweight custom-painted line + area chart matching the Progress
/// screen: solid green trend line with gradient fill under it, a
/// dashed goal-weight reference line, and a marker dot on the latest
/// point. No chart dependency needed.
class WeightChart extends StatelessWidget {
  final List<double> values;
  final double? goalValue;
  const WeightChart({super.key, required this.values, this.goalValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: double.infinity,
      child: CustomPaint(painter: _ChartPainter(values: values, goalValue: goalValue)),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> values;
  final double? goalValue;
  _ChartPainter({required this.values, this.goalValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final allValues = [...values, if (goalValue != null) goalValue!];
    final minV = allValues.reduce((a, b) => a < b ? a : b);
    final maxV = allValues.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 0.001 ? 1 : (maxV - minV);

    double yFor(double v) {
      final normalized = (v - minV) / range;
      return size.height - (normalized * size.height * 0.85) - size.height * 0.075;
    }

    final points = <Offset>[
      for (int i = 0; i < values.length; i++)
        Offset(size.width * (i / (values.length - 1)), yFor(values[i])),
    ];

    // Goal dashed line
    if (goalValue != null) {
      final goalY = yFor(goalValue!);
      final dashPaint = Paint()
        ..color = AppColors.carbs
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      const dashWidth = 5.0, dashGap = 4.0;
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(Offset(x, goalY), Offset(x + dashWidth, goalY), dashPaint);
        x += dashWidth + dashGap;
      }
    }

    // Gradient fill under the line
    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryGreen.withOpacity(0.28), AppColors.primaryGreen.withOpacity(0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Trend line
    final linePaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(linePath, linePaint);

    // End marker
    canvas.drawCircle(points.last, 5, Paint()..color = AppColors.primaryGreen);
    canvas.drawCircle(points.last, 5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.goalValue != goalValue;
}
