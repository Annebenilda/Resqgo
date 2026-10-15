import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/employee_model.dart';
import '../../models/invoice_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/service_badge.dart';
import '../../state/app_state.dart';
import 'invoice_viewer_screen.dart';
import 'employee_main_screen.dart';

class ServiceHistoryScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback? onBackToRadar;

  const ServiceHistoryScreen({
    super.key,
    required this.appState,
    this.onBackToRadar,
  });

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  ServiceRoleType? _filterRole;

  @override
  Widget build(BuildContext context) {
    final completed = widget.appState.completedRequests;
    final filtered = _filterRole == null
        ? completed
        : completed.where((r) => r.roleType == _filterRole).toList();

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 20),
          onPressed: () {
            if (widget.onBackToRadar != null) {
              widget.onBackToRadar!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const EmployeeMainScreen(initialTabIndex: 0),
                ),
              );
            }
          },
        ),
        title: Text(
          'Service History',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Chips Carousel
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildFilterChip('All Jobs (${completed.length})', null),
                  ...ServiceRole.allRoles.map((role) {
                    final count = completed.where((r) => r.roleType == role.type).length;
                    return _buildFilterChip('${role.title} ($count)', role.type, isEv: role.isEvRelated);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // History List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.history_rounded, size: 48, color: AppColors.textLightSecondary),
                          const SizedBox(height: 12),
                          Text(
                            'No completed jobs in this filter',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final req = filtered[index];
                        final isEv = req.isEv;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardDark,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isEv ? AppColors.evGreen.withValues(alpha: 0.3) : AppColors.borderDark,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Date & Status & Payout
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd MMM yyyy, hh:mm a').format(req.createdAt),
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppColors.textLightSecondary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.evGreen.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '₹${req.totalFare.toStringAsFixed(0)} EARNED',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.evGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Category Badge & Title
                              Row(
                                children: [
                                  ServiceBadge(
                                    roleType: req.roleType,
                                    isEv: isEv,
                                    isCompact: true,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      req.title,
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textLight,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Customer & Vehicle info
                              Text(
                                '${req.customerName} • ${req.vehicleModel} (${req.vehiclePlate})',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: AppColors.textLightSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: AppColors.borderDark, height: 1),
                              const SizedBox(height: 10),

                              // Bottom Actions: Downloadable Invoice
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Settled via ${req.paymentMethod}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppColors.textLightSecondary,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.surfaceDark,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(Icons.receipt_long_rounded, size: 16, color: AppColors.evGreen),
                                    label: Text(
                                      'View Invoice',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.evGreen,
                                      ),
                                    ),
                                    onPressed: () {
                                      final inv = InvoiceModel.fromServiceRequest(
                                        req,
                                        widget.appState.employee.fullName,
                                        widget.appState.employee.id,
                                      );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => InvoiceViewerScreen(
                                            appState: widget.appState,
                                            invoice: inv,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, ServiceRoleType? roleType, {bool isEv = false}) {
    final isSelected = _filterRole == roleType;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _filterRole = roleType),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? (isEv ? AppColors.evGreen : AppColors.primaryRed)
                : AppColors.cardDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isEv ? AppColors.evGreen.withValues(alpha: 0.5) : AppColors.borderDark),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.black : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
}
