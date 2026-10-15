import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/employee_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/resqgo_logo.dart';
import '../auth/role_selection_screen.dart';
import '../onboarding/instructions_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  final String? userName;
  final String? userPhone;
  final String? userEmail;

  const UserDashboardScreen({
    super.key,
    this.userName,
    this.userPhone,
    this.userEmail,
  });

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  ServiceRoleType _selectedCategory = ServiceRoleType.evSupport;
  bool _isSosActive = false;

  final _addressController = TextEditingController(text: 'National Highway 48, Near Ambience Mall, Exit 7');
  final _vehicleController = TextEditingController(text: 'Tesla Model 3 Long Range (DL-01-EV-4421)');
  final _issueDescController = TextEditingController(text: 'Battery depleted to 0%. Vehicle halted on shoulder.');

  void _dispatchRescue() {
    setState(() => _isSosActive = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.evGreen,
        content: Text('Distress Beacon Dispatched! Nearest ResQGo Response Van is en route.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 20),
          tooltip: 'Back to Instructions',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => InstructionsScreen(
                    userRole: 'user',
                    employeeName: widget.userName ?? 'Priya Sharma',
                    employeeId: 'USR-2024',
                    phone: widget.userPhone ?? '9811234567',
                    email: widget.userEmail,
                  ),
                ),
              );
            }
          },
        ),
        title: const ResQGoLogo(size: 28, showTagline: false),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account_rounded, color: AppColors.textLight),
            tooltip: 'Switch to Employee Portal',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Status & SOS Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isSosActive
                        ? [const Color(0xFF1B382B), const Color(0xFF0D241A)]
                        : [const Color(0xFF2E1315), const Color(0xFF180A0B)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _isSosActive ? AppColors.evGreen : AppColors.primaryRed,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (_isSosActive ? AppColors.evGreen : AppColors.primaryRed).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isSosActive ? Icons.satellite_alt_rounded : Icons.emergency_rounded,
                            color: _isSosActive ? AppColors.evGreen : AppColors.primaryRed,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isSosActive ? 'RESCUE VAN EN ROUTE (ETA 6m)' : 'NEED IMMEDIATE HELP?',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: _isSosActive ? AppColors.evGreenAccent : AppColors.primaryRed,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                _isSosActive ? 'Specialist Alex Vance (#RSQ-7842)' : 'One-Tap Roadside & EV SOS',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_isSosActive) ...[
                      const SizedBox(height: 14),
                      const LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.evGreen),
                        backgroundColor: Color(0xFF1B382B),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Technician driving ResQGo EV Rapid Support Van',
                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Service Picker
              Text(
                'Select Emergency Category',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ServiceRole.allRoles.map((role) {
                  final isSelected = _selectedCategory == role.type;
                  final isEv = role.isEvRelated;

                  return InkWell(
                    onTap: () => setState(() => _selectedCategory = role.type),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isEv ? AppColors.evGreen.withValues(alpha: 0.2) : AppColors.primaryRed.withValues(alpha: 0.2))
                            : AppColors.cardDark,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? (isEv ? AppColors.evGreen : AppColors.primaryRed)
                              : AppColors.borderDark,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            role.icon,
                            size: 18,
                            color: isSelected
                                ? (isEv ? AppColors.evGreen : AppColors.primaryRed)
                                : AppColors.textLightSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            role.title,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.black : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Location & Vehicle Form
              Text(
                'Distress & Vehicle Details',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Your Current Stranded Location',
                  prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.primaryRed),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _vehicleController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Model & Number',
                  prefixIcon: Icon(Icons.directions_car_rounded, color: AppColors.primaryRed),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _issueDescController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Describe Breakdown or Emergency',
                  prefixIcon: Icon(Icons.description_rounded, color: AppColors.primaryRed),
                ),
              ),
              const SizedBox(height: 24),

              // Action Dispatch Button
              ResQButton(
                text: _isSosActive ? 'Cancel Active Distress' : 'Request Emergency ResQGo Dispatch',
                icon: _isSosActive ? Icons.cancel_rounded : null,
                fontSize: 14,
                color: _isSosActive ? AppColors.cardDark : AppColors.primaryRed,
                onPressed: () {
                  if (_isSosActive) {
                    setState(() => _isSosActive = false);
                  } else {
                    _dispatchRescue();
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
