import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/employee_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/service_badge.dart';
import '../../state/app_state.dart';
import '../auth/role_selection_screen.dart';
import 'service_history_screen.dart';
import 'wallet_transactions_screen.dart';
import 'employee_main_screen.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onBackToWallet;

  const EmployeeProfileScreen({
    super.key,
    required this.appState,
    this.onBackToWallet,
  });

  @override
  Widget build(BuildContext context) {
    final employee = appState.employee;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 20),
          onPressed: () {
            if (onBackToWallet != null) {
              onBackToWallet!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const EmployeeMainScreen(initialTabIndex: 2),
                ),
              );
            }
          },
        ),
        title: Text(
          'Specialist Profile',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: AppColors.textLight),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile details are synced with central dispatch.')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.surfaceDark,
                          backgroundImage: employee.avatarUrl != null
                              ? NetworkImage(employee.avatarUrl!)
                              : null,
                          child: employee.avatarUrl == null
                              ? const Icon(Icons.person, color: Colors.white, size: 36)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.fullName,
                                style: GoogleFonts.outfit(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                employee.email,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  color: AppColors.textLightSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.fingerprint_rounded, size: 14, color: AppColors.primaryRed),
                                    const SizedBox(width: 6),
                                    Text(
                                      employee.id,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.borderDark, height: 1),
                    const SizedBox(height: 14),

                    // Phone & Vehicle
                    _buildInfoRow(Icons.phone_rounded, 'Mobile Phone', employee.phone),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.directions_car_rounded, 'Vehicle & Reg', employee.vehicleInfo),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.verified_rounded, 'DL License', employee.licenseNumber),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quick Performance Grid
              Row(
                children: [
                  _buildMetricCard(
                    title: 'RATING',
                    value: '${employee.rating} ★',
                    subtext: '58 Reviews',
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 12),
                  _buildMetricCard(
                    title: 'COMPLETED',
                    value: '${employee.totalJobsCompleted}',
                    subtext: '100% Success',
                    color: AppColors.evGreen,
                  ),
                  const SizedBox(width: 12),
                  _buildMetricCard(
                    title: 'EARNINGS',
                    value: '₹${employee.walletBalance.toStringAsFixed(0)}',
                    subtext: 'Direct Wallet',
                    color: AppColors.primaryRed,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Active Assigned Roles
              Text(
                'Certified Service Roles',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: employee.assignedRoles.map((role) {
                  return ServiceBadge(
                    roleType: role,
                    isEv: role == ServiceRoleType.evSupport,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Navigation Shortcuts
              Text(
                'Quick Portals',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10),

              _buildShortcutTile(
                icon: Icons.history_rounded,
                title: 'Service History & Invoices',
                subtitle: 'View all past rescue operations & download PDF bills',
                color: AppColors.primaryRed,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ServiceHistoryScreen(appState: appState),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              _buildShortcutTile(
                icon: Icons.account_balance_wallet_rounded,
                title: 'Wallet & Payout Records',
                subtitle: 'Bank transfers, commission breakdown & tax summary',
                color: AppColors.evGreen,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WalletTransactionsScreen(appState: appState),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Logout / Switch Account
              ResQOutlineButton(
                text: 'Switch Account / Log Out',
                icon: Icons.logout_rounded,
                borderColor: AppColors.primaryRed.withValues(alpha: 0.6),
                textColor: AppColors.primaryRed,
                onPressed: () {
                  appState.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textLightSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            color: AppColors.textLightSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtext,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.textLightSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtext,
              style: GoogleFonts.outfit(
                fontSize: 10.5,
                color: AppColors.textLightSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      color: AppColors.textLightSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}
