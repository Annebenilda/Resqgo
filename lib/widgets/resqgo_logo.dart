import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class ResQGoLogo extends StatelessWidget {
  final double size;
  final bool showTagline;
  final bool isDark;

  const ResQGoLogo({
    super.key,
    this.size = 48,
    this.showTagline = true,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Shield & Beacon Icon
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryRed, AppColors.redDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(size * 0.28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRed.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.car_crash_rounded,
                    color: Colors.white,
                    size: size * 0.55,
                  ),
                  Positioned(
                    top: size * 0.15,
                    right: size * 0.15,
                    child: Container(
                      width: size * 0.25,
                      height: size * 0.25,
                      decoration: const BoxDecoration(
                        color: AppColors.evGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.evGreen,
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.bolt_rounded,
                        color: Colors.white,
                        size: size * 0.18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Text Logo
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'ResQ',
                    style: GoogleFonts.outfit(
                      fontSize: size * 0.65,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryRed,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Go',
                    style: GoogleFonts.outfit(
                      fontSize: size * 0.65,
                      fontWeight: FontWeight.w900,
                      color: AppColors.evGreen,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 6),
          Text(
            '24/7 ROADSIDE & EV ASSISTANCE',
            style: GoogleFonts.outfit(
              fontSize: size * 0.22,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: isDark ? AppColors.textLightSecondary : AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
