import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/employee_model.dart';
import '../theme/app_colors.dart';

class ServiceBadge extends StatelessWidget {
  final ServiceRoleType roleType;
  final bool isEv;
  final bool isCompact;

  const ServiceBadge({
    super.key,
    required this.roleType,
    this.isEv = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    if (isEv || roleType == ServiceRoleType.evSupport) {
      bg = AppColors.evGreen.withValues(alpha: 0.15);
      fg = AppColors.evGreen;
      icon = Icons.bolt_rounded;
      label = 'EV SUPPORT';
    } else {
      switch (roleType) {
        case ServiceRoleType.mechanic:
          bg = AppColors.primaryRed.withValues(alpha: 0.15);
          fg = AppColors.primaryRed;
          icon = Icons.build_rounded;
          label = 'MECHANIC';
          break;
        case ServiceRoleType.towing:
          bg = AppColors.warningOrange.withValues(alpha: 0.15);
          fg = AppColors.warningOrange;
          icon = Icons.fire_truck_rounded;
          label = 'TOWING';
          break;
        case ServiceRoleType.batteryInstallation:
          bg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
          fg = const Color(0xFFF59E0B);
          icon = Icons.battery_charging_full_rounded;
          label = 'BATTERY';
          break;
        case ServiceRoleType.petrolSupply:
          bg = AppColors.primaryRed.withValues(alpha: 0.15);
          fg = AppColors.primaryRed;
          icon = Icons.local_gas_station_rounded;
          label = 'DIESEL ⛽';
          break;
        default:
          bg = AppColors.primaryRed.withValues(alpha: 0.15);
          fg = AppColors.primaryRed;
          icon = Icons.emergency_rounded;
          label = 'EMERGENCY';
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isCompact ? 12 : 14, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
