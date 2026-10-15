import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/resqgo_logo.dart';
import 'employee_auth_screen.dart';
import 'user_auth_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const ResQGoLogo(size: 44, showTagline: false),
              const SizedBox(height: 24),
              Text(
                'Welcome to ResQGo',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textLight,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select your account type to proceed to the dedicated portal',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: AppColors.textLightSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Option 1: Employee / Service Provider Card
              _buildRoleCard(
                context: context,
                title: 'Service Provider / Employee',
                subtitle: 'Accept nearby breakdown requests, provide mechanic & EV fast recharge, and earn with instant payouts.',
                badgeText: 'EMPLOYEE PORTAL',
                badgeColor: AppColors.primaryRed,
                borderColor: AppColors.primaryRed.withValues(alpha: 0.6),
                icon: Icons.engineering_rounded,
                features: [
                  'Generate Unique Employee ID',
                  'Select multiple roles (EV, Mechanic, Fuel, Towing)',
                  'Live navigation radar & direct payouts',
                  'Downloadable tax invoices',
                ],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EmployeeAuthScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Option 2: User / Motorist Card
              _buildRoleCard(
                context: context,
                title: 'Motorist / User',
                subtitle: 'Stuck on the road? Request instant mechanic, towing, emergency Diesel, or EV mobile charging.',
                badgeText: 'USER / DRIVER',
                badgeColor: AppColors.evGreen,
                borderColor: AppColors.evGreen.withValues(alpha: 0.6),
                icon: Icons.directions_car_rounded,
                features: [
                  '24/7 SOS & Emergency rescue',
                  'EV Rapid Boost & Diesel delivery',
                  'Live real-time engineer tracking',
                  'Transparent digital pricing',
                ],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserAuthScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              // Quick Help Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.support_agent_rounded, size: 18, color: AppColors.textLightSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Need urgent assistance? Hotline: 1800-RESQ-GO',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLightSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color borderColor,
    required IconData icon,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: badgeColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: badgeColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: badgeColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.textLightSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(color: AppColors.borderDark, height: 1),
            const SizedBox(height: 12),
            ...features.map((feat) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 15, color: badgeColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feat,
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
