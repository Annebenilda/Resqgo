import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../state/app_state.dart';
import 'nearby_requests_screen.dart';
import 'service_history_screen.dart';
import 'wallet_transactions_screen.dart';
import 'employee_profile_screen.dart';

class EmployeeMainScreen extends StatefulWidget {
  final int initialTabIndex;

  const EmployeeMainScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<EmployeeMainScreen> createState() => _EmployeeMainScreenState();
}

class _EmployeeMainScreenState extends State<EmployeeMainScreen> {
  late int _currentIndex;
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
    _appState = AppState();
    _appState.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      NearbyRequestsScreen(appState: _appState),
      ServiceHistoryScreen(
        appState: _appState,
        onBackToRadar: () => setState(() => _currentIndex = 0),
      ),
      WalletTransactionsScreen(
        appState: _appState,
        onBackToHistory: () => setState(() => _currentIndex = 1),
      ),
      EmployeeProfileScreen(
        appState: _appState,
        onBackToWallet: () => setState(() => _currentIndex = 2),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          border: const Border(
            top: BorderSide(color: AppColors.borderDark, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: AppColors.textLightSecondary,
          selectedLabelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500),
          items: [
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.radar_rounded),
                  if (_appState.nearbyRequests.isNotEmpty)
                    Positioned(
                      top: -2,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_appState.nearbyRequests.length}',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Radar',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_rounded),
              label: '₹${_appState.employee.walletBalance.toStringAsFixed(0)}',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
