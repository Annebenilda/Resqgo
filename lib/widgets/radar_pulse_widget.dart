import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RadarPulseWidget extends StatefulWidget {
  final double size;
  final int count;
  final bool isEvMode;

  const RadarPulseWidget({
    super.key,
    this.size = 140,
    this.count = 3,
    this.isEvMode = false,
  });

  @override
  State<RadarPulseWidget> createState() => _RadarPulseWidgetState();
}

class _RadarPulseWidgetState extends State<RadarPulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isEvMode ? AppColors.evGreen : AppColors.primaryRed;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RadarPainter(
              progress: _controller.value,
              color: baseColor,
              waveCount: widget.count,
            ),
            child: Center(
              child: Container(
                width: widget.size * 0.32,
                height: widget.size * 0.32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [baseColor, baseColor.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withValues(alpha: 0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  widget.isEvMode ? Icons.electric_bolt_rounded : Icons.radar_rounded,
                  color: Colors.white,
                  size: widget.size * 0.16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int waveCount;

  _RadarPainter({
    required this.progress,
    required this.color,
    required this.waveCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < waveCount; i++) {
      final currentProgress = (progress + (i / waveCount)) % 1.0;
      final radius = currentProgress * maxRadius;
      final opacity = (1.0 - currentProgress).clamp(0.0, 0.8);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity * 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final fillPaint = Paint()
        ..color = color.withValues(alpha: opacity * 0.08)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, fillPaint);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
