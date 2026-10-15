import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/service_request_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../state/app_state.dart';
import 'payment_received_screen.dart';

class ServiceExecutionScreen extends StatefulWidget {
  final AppState appState;
  final ServiceRequest request;

  const ServiceExecutionScreen({
    super.key,
    required this.appState,
    required this.request,
  });

  @override
  State<ServiceExecutionScreen> createState() => _ServiceExecutionScreenState();
}

class _ServiceExecutionScreenState extends State<ServiceExecutionScreen> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _formattedTime = '00:00:00';
  String _notes = 'Replaced flat tyre with spare wheel. Checked torque on all 5 lug nuts at 120 Nm.';

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          final duration = _stopwatch.elapsed;
          final hours = duration.inHours.toString().padLeft(2, '0');
          final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
          _formattedTime = '$hours:$minutes:$seconds';
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _onCompleteService() {
    // Check if checklist is completed or ask confirmation
    final incomplete = widget.request.checklist.where((i) => !i.isCompleted).length;
    if (incomplete > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Incomplete Checklist',
            style: GoogleFonts.outfit(color: AppColors.textLight, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'You still have $incomplete unchecked items in the safety checklist. Do you want to mark all as completed and proceed to payment collection?',
            style: GoogleFonts.outfit(color: AppColors.textLightSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Review', style: GoogleFonts.outfit(color: AppColors.textLightSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed),
              onPressed: () {
                for (var item in widget.request.checklist) {
                  item.isCompleted = true;
                }
                Navigator.pop(ctx);
                _proceedToPayment();
              },
              child: Text('Complete All & Continue', style: GoogleFonts.outfit(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      _proceedToPayment();
    }
  }

  void _proceedToPayment() {
    widget.appState.completeActiveService();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PaymentReceivedScreen(
          appState: widget.appState,
          request: widget.request,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final isEv = req.isEv;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Service In Progress',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warningOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.warningOrange),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.build_circle_rounded, size: 14, color: AppColors.warningOrange),
                const SizedBox(width: 4),
                Text(
                  'EXECUTING',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.warningOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timer & Status Dashboard Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cardDark,
                      isEv ? const Color(0xFF132D23) : const Color(0xFF2C1819),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isEv ? AppColors.evGreen.withValues(alpha: 0.5) : AppColors.primaryRed.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SERVICE TIMER',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: AppColors.textLightSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formattedTime,
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: isEv ? AppColors.evGreen : Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isEv ? AppColors.evGreen.withValues(alpha: 0.15) : AppColors.primaryRed.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isEv ? Icons.electric_bolt_rounded : Icons.timer_rounded,
                            color: isEv ? AppColors.evGreen : AppColors.primaryRed,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: AppColors.borderDark, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer: ${req.customerName}',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight,
                          ),
                        ),
                        Text(
                          req.vehicleModel,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isEv ? AppColors.evGreen : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Checklist Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Safety & Execution Checklist',
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    '${req.checklist.where((i) => i.isCompleted).length}/${req.checklist.length} Done',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isEv ? AppColors.evGreen : AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              ...req.checklist.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: item.isCompleted ? AppColors.surfaceDark.withValues(alpha: 0.4) : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: item.isCompleted ? AppColors.evGreen.withValues(alpha: 0.4) : AppColors.borderDark,
                    ),
                  ),
                  child: CheckboxListTile(
                    activeColor: isEv ? AppColors.evGreen : AppColors.primaryRed,
                    checkColor: Colors.white,
                    value: item.isCompleted,
                    onChanged: (val) {
                      setState(() {
                        item.isCompleted = val ?? false;
                      });
                    },
                    title: Text(
                      item.title,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: item.isCompleted ? FontWeight.w500 : FontWeight.w600,
                        color: item.isCompleted ? Colors.white70 : AppColors.textLight,
                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Photo Proof & Verification
              Text(
                'Work Proof & Verification',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.evGreen),
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: AppColors.evGreen, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Repairs / Deliveries Verified',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textLight,
                            ),
                          ),
                          Text(
                            'High-res photo evidence captured and timestamped',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryRed),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('New inspection photo captured!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Service Notes
              Text(
                'Technician Work Notes',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _notes,
                maxLines: 2,
                onChanged: (val) => _notes = val,
                decoration: const InputDecoration(
                  hintText: 'Enter any service observations or part serial numbers...',
                ),
              ),
              const SizedBox(height: 24),

              // Complete Service & Switch to Payment Screen (Red Button)
              ResQButton(
                text: 'Complete Service & Collect Payment →',
                icon: Icons.check_circle_rounded,
                onPressed: _onCompleteService,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
