import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/employee_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/resqgo_logo.dart';
import '../employee/employee_main_screen.dart';
import '../user/user_dashboard_screen.dart';

class InstructionsScreen extends StatefulWidget {
  final String userRole; // 'employee' or 'user'
  final String employeeName;
  final String employeeId;
  final String? email;
  final String phone;
  final List<ServiceRoleType>? roles;
  final String? avatarUrl;

  const InstructionsScreen({
    super.key,
    required this.userRole,
    required this.employeeName,
    required this.employeeId,
    this.email,
    required this.phone,
    this.roles,
    this.avatarUrl,
  });

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  late final PageController _pageController;
  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _employeeSteps => [
        {
          'title': '1. Activate Rescue Radar',
          'badge': 'RADAR ACTIVE',
          'badgeColor': AppColors.primaryRed,
          'icon': Icons.radar_rounded,
          'desc':
              'Toggle your status to "Online" on the radar screen to begin receiving real-time breakdown and rescue requests within your set radius (up to 25 km).',
          'highlight': 'Instant notifications for urgent emergency SOS requests.',
        },
        {
          'title': '2. Review & Accept Nearby Jobs',
          'badge': 'JOB DISPATCH',
          'badgeColor': AppColors.warningOrange,
          'icon': Icons.assignment_turned_in_rounded,
          'desc':
              'Review user vehicle details (EV model, ICE car), exact issue description, distance, and upfront estimated payout. Tap the Red "Accept Request" button to claim the task.',
          'highlight': 'EV issues are specially flagged with vibrant Green badges.',
        },
        {
          'title': '3. Live GPS Navigation & Route',
          'badge': 'LIVE TRACKING',
          'badgeColor': AppColors.evGreen,
          'icon': Icons.navigation_rounded,
          'desc':
              'Get live turn-by-turn map guidance to the stranded motorist. Use direct one-touch in-app Calling or Chat to coordinate with the driver.',
          'highlight': 'Real-time location synchronization keeps the user updated on your ETA.',
        },
        {
          'title': '4. Execute Service & Safety Checklist',
          'badge': 'SERVICE EXECUTION',
          'badgeColor': AppColors.infoBlue,
          'icon': Icons.checklist_rounded,
          'desc':
              'Setup hazard cones, run diagnostics, deliver fuel / EV fast charge / tyre replacement, and complete all safety items before customer sign-off.',
          'highlight': 'Live service timer and photo evidence ensure transparent verification.',
        },
        {
          'title': '5. Collect Payment & Generate Invoice',
          'badge': 'INSTANT PAYOUT',
          'badgeColor': AppColors.evGreen,
          'icon': Icons.receipt_long_rounded,
          'desc':
              'Collect fare via UPI, Cash, or Card. Instant official GST/Tax invoice is generated for download, and earnings are credited directly to your ResQGo wallet.',
          'highlight': 'Downloadable PDF-ready invoice with detailed line items.',
        },
      ];

  List<Map<String, dynamic>> get _userSteps => [
        {
          'title': '1. Choose Roadside Service',
          'badge': 'ONE-TAP SOS',
          'badgeColor': AppColors.primaryRed,
          'icon': Icons.emergency_rounded,
          'desc':
              'Select what you need: EV Rapid Charge, Mechanic, Emergency Diesel, Battery Replacement, or Towing Recovery.',
          'highlight': '24/7 priority emergency dispatch network across all highways & city zones.',
        },
        {
          'title': '2. Share Pinpoint Location',
          'badge': 'GPS ACCURACY',
          'badgeColor': AppColors.evGreen,
          'icon': Icons.my_location_rounded,
          'desc':
              'Your GPS automatically detects your exact stranded location so the closest certified technician is instantly dispatched.',
          'highlight': 'Attach optional breakdown photos or notes for faster diagnostic prep.',
        },
        {
          'title': '3. Live Track Response Van',
          'badge': 'REAL-TIME TRACKING',
          'badgeColor': AppColors.infoBlue,
          'icon': Icons.map_rounded,
          'desc':
              'Watch your service technician approach in real-time with live ETA, vehicle number, and technician contact info.',
          'highlight': 'Direct calling and message support at all times.',
        },
        {
          'title': '4. Transparent Rates & Invoice',
          'badge': 'NO SURPRISES',
          'badgeColor': AppColors.evGreen,
          'icon': Icons.verified_user_rounded,
          'desc':
              'Standard standardized pricing with upfront quotes. Receive an official downloadable invoice upon service completion.',
          'highlight': 'Pay securely with UPI, Cards, or Cash.',
        },
      ];

  void _onFinish() {
    if (widget.userRole == 'employee') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const EmployeeMainScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserDashboardScreen(
            userName: widget.employeeName,
            userPhone: widget.phone,
            userEmail: widget.email,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmployee = widget.userRole == 'employee';
    final steps = isEmployee ? _employeeSteps : _userSteps;
    final primaryColor = isEmployee ? AppColors.primaryRed : AppColors.evGreen;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ResQGoLogo(size: 32, showTagline: false),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      isEmployee ? 'SPECIALIST GUIDE' : 'MOTORIST GUIDE',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Greeting & Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How ResQGo Works',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEmployee
                        ? 'Master the 5-step emergency response cycle to maximize your earnings.'
                        : 'Quick overview on requesting and tracking your roadside assistance.',
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      color: AppColors.textLightSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Step Progress Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(steps.length, (index) {
                final isSelected = _currentStepIndex == index;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isSelected ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : AppColors.borderDark,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Carousel / Step Content Area
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: steps.length,
                onPageChanged: (idx) => setState(() => _currentStepIndex = idx),
                itemBuilder: (context, index) {
                  final step = steps[index];
                  final Color badgeCol = step['badgeColor'] as Color;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.borderDark, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Step Icon & Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: badgeCol.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(step['icon'] as IconData, size: 36, color: badgeCol),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: badgeCol.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: badgeCol.withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  step['badge'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: badgeCol,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Step Title
                          Text(
                            step['title'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Step Description
                          Text(
                            step['desc'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 14.5,
                              color: AppColors.textLightSecondary,
                              height: 1.5,
                            ),
                          ),
                          const Spacer(),

                          // Highlight Box
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.lightbulb_rounded, size: 20, color: primaryColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    step['highlight'] as String,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Bottom Navigation Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  if (_currentStepIndex > 0) ...[
                    Expanded(
                      flex: 1,
                      child: ResQOutlineButton(
                        text: 'Back',
                        height: 52,
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ResQButton(
                      text: _currentStepIndex == steps.length - 1 ? 'Go to Dashboard →' : 'Next Step →',
                      color: primaryColor,
                      height: 52,
                      onPressed: () {
                        if (_currentStepIndex == steps.length - 1) {
                          _onFinish();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
