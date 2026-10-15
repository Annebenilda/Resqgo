import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/service_request_model.dart';

class MapSimulationWidget extends StatefulWidget {
  final ServiceRequest? request;
  final bool isProviderMoving;
  final double height;
  final VoidCallback? onRecenter;

  const MapSimulationWidget({
    super.key,
    this.request,
    this.isProviderMoving = true,
    this.height = 300,
    this.onRecenter,
  });

  @override
  State<MapSimulationWidget> createState() => _MapSimulationWidgetState();
}

class _MapSimulationWidgetState extends State<MapSimulationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    if (widget.isProviderMoving) {
      _animController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant MapSimulationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isProviderMoving && !_animController.isAnimating) {
      _animController.repeat();
    } else if (!widget.isProviderMoving && _animController.isAnimating) {
      _animController.stop();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final isEv = req?.isEv ?? false;
    final brandColor = isEv ? AppColors.evGreen : AppColors.primaryRed;

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF131B2A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Map Canvas Background
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(double.infinity, widget.height),
                painter: _MapCanvasPainter(
                  progress: _animController.value,
                  brandColor: brandColor,
                  isEv: isEv,
                ),
              );
            },
          ),

          // Map Control Overlays (Zoom & Compass)
          Positioned(
            top: 14,
            right: 14,
            child: Column(
              children: [
                _buildMapToolBtn(Icons.navigation_rounded, () {}),
                const SizedBox(height: 8),
                _buildMapToolBtn(Icons.add_rounded, () {}),
                const SizedBox(height: 4),
                _buildMapToolBtn(Icons.remove_rounded, () {}),
                const SizedBox(height: 8),
                _buildMapToolBtn(Icons.my_location_rounded, widget.onRecenter ?? () {}),
              ],
            ),
          ),

          // Top Info Status Bar (Live GPS & ETA)
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgDark.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: brandColor.withValues(alpha: 0.6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.evGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.evGreen.withValues(alpha: 0.8),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LIVE GPS TRACKING',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                  if (req != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${req.distanceKm} km (${req.etaMinutes} mins)',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: brandColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Quick Location Card
          if (req != null)
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardDark.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: brandColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.location_on_rounded, color: brandColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'User Distress Coordinates',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textLightSecondary,
                            ),
                          ),
                          Text(
                            req.customerAddress,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapToolBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.cardDark.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  final double progress;
  final Color brandColor;
  final bool isEv;

  _MapCanvasPainter({
    required this.progress,
    required this.brandColor,
    required this.isEv,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Background Grid & Blocks
    final blockPaint = Paint()..color = const Color(0xFF1E2838);
    final parkPaint = Paint()..color = const Color(0xFF152A28);
    final roadPaint = Paint()
      ..color = const Color(0xFF2C394F)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final roadCenterPaint = Paint()
      ..color = const Color(0xFF3B4D6B)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw stylized city blocks
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 20, size.width * 0.28, size.height * 0.32),
        const Radius.circular(8),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.65, 30, size.width * 0.28, size.height * 0.28),
        const Radius.circular(8),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.45, size.height * 0.55, size.width * 0.45, size.height * 0.32),
        const Radius.circular(8),
      ),
      blockPaint,
    );

    // Draw main city highways & roads
    final Path mainRoad = Path()
      ..moveTo(0, size.height * 0.45)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.4,
        size.width * 0.5,
        size.height * 0.7,
        size.width,
        size.height * 0.65,
      );

    final Path secondaryRoad = Path()
      ..moveTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.42, size.height);

    canvas.drawPath(mainRoad, roadPaint);
    canvas.drawPath(mainRoad, roadCenterPaint);
    canvas.drawPath(secondaryRoad, roadPaint);
    canvas.drawPath(secondaryRoad, roadCenterPaint);

    // Route Polyline from Service Van to Stranded User
    final startPt = Offset(size.width * 0.15, size.height * 0.75);
    final endPt = Offset(size.width * 0.75, size.height * 0.35);
    final midPt1 = Offset(size.width * 0.35, size.height * 0.7);
    final midPt2 = Offset(size.width * 0.45, size.height * 0.38);

    final Path routePath = Path()
      ..moveTo(startPt.dx, startPt.dy)
      ..lineTo(midPt1.dx, midPt1.dy)
      ..lineTo(midPt2.dx, midPt2.dy)
      ..lineTo(endPt.dx, endPt.dy);

    // Polyline shadow & glow
    final routeGlowPaint = Paint()
      ..color = brandColor.withValues(alpha: 0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routeLinePaint = Paint()
      ..color = brandColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(routePath, routeGlowPaint);
    canvas.drawPath(routePath, routeLinePaint);

    // User distress beacon at endPt
    _drawUserPin(canvas, endPt, brandColor);

    // Moving Provider Vehicle along the path
    final currentPos = _calculatePositionAlongPath(startPt, midPt1, midPt2, endPt, progress);
    _drawProviderMarker(canvas, currentPos, brandColor);
  }

  Offset _calculatePositionAlongPath(
    Offset p0,
    Offset p1,
    Offset p2,
    Offset p3,
    double t,
  ) {
    if (t < 0.33) {
      final subT = t / 0.33;
      return Offset.lerp(p0, p1, subT)!;
    } else if (t < 0.66) {
      final subT = (t - 0.33) / 0.33;
      return Offset.lerp(p1, p2, subT)!;
    } else {
      final subT = (t - 0.66) / 0.34;
      return Offset.lerp(p2, p3, subT)!;
    }
  }

  void _drawUserPin(Canvas canvas, Offset pos, Color color) {
    // Pulsing circle wave
    final pulsePaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, 24, pulsePaint);

    final ringPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(pos, 24, ringPaint);

    // Pin circle
    final pinPaint = Paint()..color = color;
    canvas.drawCircle(pos, 14, pinPaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(pos, 6, innerPaint);
  }

  void _drawProviderMarker(Canvas canvas, Offset pos, Color color) {
    // Van marker background
    final bgPaint = Paint()
      ..color = AppColors.cardDark
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = AppColors.evGreen
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(pos, 14, bgPaint);
    canvas.drawCircle(pos, 14, borderPaint);

    // Inner vehicle dot
    final dotPaint = Paint()..color = AppColors.evGreen;
    canvas.drawCircle(pos, 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) => true;
}
