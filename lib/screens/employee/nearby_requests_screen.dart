import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/service_request_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/radar_pulse_widget.dart';
import '../../widgets/request_card.dart';
import '../../state/app_state.dart';
import 'live_tracking_screen.dart';

class NearbyRequestsScreen extends StatefulWidget {
  final AppState appState;

  const NearbyRequestsScreen({
    super.key,
    required this.appState,
  });

  @override
  State<NearbyRequestsScreen> createState() => _NearbyRequestsScreenState();
}

class _NearbyRequestsScreenState extends State<NearbyRequestsScreen> {
  final List<double> _distanceFilters = [2.0, 5.0, 10.0, 25.0];

  void _acceptRequest(ServiceRequest req) {
    widget.appState.acceptRequest(req);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LiveTrackingScreen(
          appState: widget.appState,
          request: req,
        ),
      ),
    );
  }

  void _rejectRequest(ServiceRequest req) {
    widget.appState.rejectRequest(req);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request #${req.id} dismissed.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employee = widget.appState.employee;
    final isOnline = employee.isOnline;
    final allRequests = widget.appState.nearbyRequests;

    // Filter by distance
    final filteredRequests = allRequests.where((r) {
      return r.distanceKm <= widget.appState.distanceFilterKm;
    }).toList();

    final evCount = filteredRequests.where((r) => r.isEv).length;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header with Employee ID & Status Switch
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.surfaceDark,
                    backgroundImage: employee.avatarUrl != null
                        ? NetworkImage(employee.avatarUrl!)
                        : null,
                    child: employee.avatarUrl == null
                        ? const Icon(Icons.person, color: AppColors.textLightSecondary, size: 22)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.fullName,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textLight,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                employee.id,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                            Text(
                              ' ${employee.rating}',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Online / Offline Status Chip Toggle
                  InkWell(
                    onTap: () => widget.appState.toggleOnlineStatus(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppColors.evGreen.withValues(alpha: 0.15)
                            : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isOnline ? AppColors.evGreen : AppColors.borderDark,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isOnline ? AppColors.evGreen : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isOnline ? 'ONLINE' : 'OFFLINE',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isOnline ? AppColors.evGreen : AppColors.textLightSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Active Request Bar (If currently servicing a customer)
            if (widget.appState.activeRequest != null)
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LiveTrackingScreen(
                        appState: widget.appState,
                        request: widget.appState.activeRequest!,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryRed, AppColors.redDark],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRed.withValues(alpha: 0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emergency_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ACTIVE TASK IN PROGRESS',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Colors.white70,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              '${widget.appState.activeRequest!.customerName} (${widget.appState.activeRequest!.vehicleModel})',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),

            // Radar Scan Summary Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Row(
                children: [
                  RadarPulseWidget(
                    size: 64,
                    count: 2,
                    isEvMode: evCount > 0,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOnline
                              ? '${filteredRequests.length} Nearby Requests Found'
                              : 'Radar is Paused (Offline)',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isOnline
                              ? 'Includes $evCount EV Priority calls & ${filteredRequests.length - evCount} Standard Emergencies'
                              : 'Go online to receive nearby rescue dispatch calls.',
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            color: AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Distance Radius Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  Text(
                    'Range:',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLightSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ..._distanceFilters.map((km) {
                    final isSelected = widget.appState.distanceFilterKm == km;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => widget.appState.setDistanceFilter(km),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryRed : AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryRed : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            '${km.toInt()} km',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.textLightSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Requests List
            Expanded(
              child: !isOnline
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textLightSecondary),
                          const SizedBox(height: 12),
                          Text(
                            'You are currently offline',
                            style: GoogleFonts.outfit(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap "Go Online" at the top to scan for emergency requests.',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : filteredRequests.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, size: 48, color: AppColors.evGreen),
                              const SizedBox(height: 12),
                              Text(
                                'No requests in this radius',
                                style: GoogleFonts.outfit(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Try extending your range filter to 25 km.',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: AppColors.textLightSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: filteredRequests.length,
                          itemBuilder: (context, index) {
                            final req = filteredRequests[index];
                            return RequestCard(
                              request: req,
                              onAccept: () => _acceptRequest(req),
                              onReject: () => _rejectRequest(req),
                              onTap: () => _acceptRequest(req),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
