import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/service_request_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/map_simulation_widget.dart';
import '../../widgets/service_badge.dart';
import '../../state/app_state.dart';
import 'service_execution_screen.dart';

class LiveTrackingScreen extends StatefulWidget {
  final AppState appState;
  final ServiceRequest request;

  const LiveTrackingScreen({
    super.key,
    required this.appState,
    required this.request,
  });

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  void _callCustomer() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.cardDark,
        content: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: AppColors.evGreen),
            const SizedBox(width: 10),
            Text(
              'Calling ${widget.request.customerName} (${widget.request.customerPhone})...',
              style: GoogleFonts.outfit(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _chatWithCustomer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return _buildChatSheet();
      },
    );
  }

  void _markArrivedAndProceed() {
    widget.appState.setRequestStatus(RequestStatus.arrived);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ServiceExecutionScreen(
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
          'Live Route & User Distress',
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
              color: isEv ? AppColors.evGreen.withValues(alpha: 0.15) : AppColors.primaryRed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isEv ? AppColors.evGreen : AppColors.primaryRed,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.gps_fixed_rounded,
                  size: 14,
                  color: isEv ? AppColors.evGreen : AppColors.primaryRed,
                ),
                const SizedBox(width: 4),
                Text(
                  'EN ROUTE',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isEv ? AppColors.evGreen : AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Interactive Map Simulation (Top Half)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: MapSimulationWidget(
                request: req,
                height: 240,
                isProviderMoving: true,
              ),
            ),

            // Scrollable User Distress Details & Actions (Bottom Half)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile Card & Direct Action Buttons (Call / Message)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: AppColors.surfaceDark,
                                backgroundImage: NetworkImage(req.customerAvatar),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      req.customerName,
                                      style: GoogleFonts.outfit(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    Text(
                                      req.customerPhone,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        color: AppColors.textLightSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Quick Call & Chat Action Icons
                              IconButton(
                                onPressed: _callCustomer,
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.evGreen.withValues(alpha: 0.15),
                                  side: const BorderSide(color: AppColors.evGreen),
                                ),
                                icon: const Icon(Icons.call_rounded, color: AppColors.evGreen, size: 20),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                onPressed: _chatWithCustomer,
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.infoBlue.withValues(alpha: 0.15),
                                  side: const BorderSide(color: AppColors.infoBlue),
                                ),
                                icon: const Icon(Icons.chat_bubble_rounded, color: AppColors.infoBlue, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.borderDark, height: 1),
                          const SizedBox(height: 12),

                          // Vehicle Info & Plate
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isEv ? Icons.electric_car_rounded : Icons.directions_car_rounded,
                                    size: 18,
                                    color: isEv ? AppColors.evGreen : AppColors.primaryRed,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    req.vehicleModel,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceDark,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.borderDark),
                                ),
                                child: Text(
                                  req.vehiclePlate,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // User's Problem Details Entered During Request
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isEv ? AppColors.evGreen.withValues(alpha: 0.4) : AppColors.borderDark,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PROBLEM REPORTED BY USER',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: AppColors.textLightSecondary,
                                ),
                              ),
                              ServiceBadge(
                                roleType: req.roleType,
                                isEv: isEv,
                                isCompact: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            req.title,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            req.description,
                            style: GoogleFonts.outfit(
                              fontSize: 13.5,
                              color: AppColors.textLightSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Simulated Attached User Photo or Diagnostic Checklist
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isEv ? AppColors.evGreen.withValues(alpha: 0.2) : AppColors.primaryRed.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    isEv ? Icons.battery_alert_rounded : Icons.photo_camera_rounded,
                                    color: isEv ? AppColors.evGreen : AppColors.primaryRed,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isEv ? 'EV Diagnostics Telemetry' : 'Distress Attachment Verified',
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                      Text(
                                        isEv ? 'SoC: 1% • 400V Architecture' : '1 Photo Attached by Customer',
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.5,
                                          color: AppColors.textLightSecondary,
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
                    ),
                    const SizedBox(height: 14),

                    // Fare & Payout Summary
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated Payout',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.textLightSecondary,
                                ),
                              ),
                              Text(
                                '₹${req.totalFare.toStringAsFixed(0)}',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.evGreen,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.bgDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 14, color: AppColors.warningOrange),
                                const SizedBox(width: 4),
                                Text(
                                  'ETA: ${req.etaMinutes} mins',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Primary Red Action Button: "I Have Arrived at Location"
                    ResQButton(
                      text: 'I Have Arrived at Location →',
                      icon: Icons.pin_drop_rounded,
                      onPressed: _markArrivedAndProceed,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatSheet() {
    return Container(
      height: 480,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(widget.request.customerAvatar),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Chat with ${widget.request.customerName}',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: AppColors.textLightSecondary),
              ),
            ],
          ),
          const Divider(color: AppColors.borderDark),
          Expanded(
            child: ListView(
              children: [
                _buildChatBubble('Hello, I am on my way with the rescue vehicle!', true),
                _buildChatBubble('Thank you so much, I am standing right next to the red hatchback.', false),
                _buildChatBubble('Got it. ETA is around 5 minutes.', true),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.outfit(color: AppColors.textLightSecondary),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primaryRed),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryRed : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
