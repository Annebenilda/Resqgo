import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/service_request_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/service_badge.dart';
import '../../state/app_state.dart';
import 'invoice_viewer_screen.dart';
import 'employee_main_screen.dart';

class PaymentReceivedScreen extends StatefulWidget {
  final AppState appState;
  final ServiceRequest request;

  const PaymentReceivedScreen({
    super.key,
    required this.appState,
    required this.request,
  });

  @override
  State<PaymentReceivedScreen> createState() => _PaymentReceivedScreenState();
}

class _PaymentReceivedScreenState extends State<PaymentReceivedScreen> {
  String _selectedPaymentMethod = 'Instant UPI (GPay / PhonePe / Paytm)';
  double _tip = 10.0;

  final List<String> _paymentMethods = [
    'Instant UPI (GPay / PhonePe / Paytm)',
    'Direct Cash Collected',
    'Credit / Debit Card Terminal',
    'ResQGo Motorist Wallet',
  ];

  void _confirmAndGenerateInvoice() {
    widget.appState.processPaymentAndFinalize(
      paymentMethod: _selectedPaymentMethod,
      tipAmount: _tip,
    );

    final invoice = widget.appState.latestGeneratedInvoice;
    if (invoice != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => InvoiceViewerScreen(
            appState: widget.appState,
            invoice: invoice,
          ),
        ),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const EmployeeMainScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final isEv = req.isEv;
    final total = req.baseFare + req.partsCost + req.laborCost + req.taxAmount + _tip;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Payment Settlement',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Celebration Badge
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.evGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.evGreen, width: 2),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.evGreen,
                  size: 44,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Service Successfully Completed!',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Collect customer payment & generate official tax invoice',
                style: GoogleFonts.outfit(
                  fontSize: 13.5,
                  color: AppColors.textLightSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Itemized Fare Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BILLING BREAKDOWN',
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
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
                    const SizedBox(height: 14),

                    _buildBillRow('Emergency Base Callout', '₹${req.baseFare.toStringAsFixed(2)}'),
                    if (req.laborCost > 0)
                      _buildBillRow('Technician Labor & Diagnostics', '₹${req.laborCost.toStringAsFixed(2)}'),
                    if (req.partsCost > 0)
                      _buildBillRow(
                        isEv ? 'EV Mobile Boost (kWh Delivered)' : 'Parts / Consumables / Petrol',
                        '₹${req.partsCost.toStringAsFixed(2)}',
                      ),
                    _buildBillRow('GST / Service Tax (18%)', '₹${req.taxAmount.toStringAsFixed(2)}'),

                    // Tip Selection Row
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer Tip / Gratitude',
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            color: AppColors.textLight,
                          ),
                        ),
                        Row(
                          children: [0.0, 5.0, 10.0, 20.0].map((tipVal) {
                            final isSel = _tip == tipVal;
                            return Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: InkWell(
                                onTap: () => setState(() => _tip = tipVal),
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSel ? AppColors.evGreen : AppColors.surfaceDark,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '₹${tipVal.toInt()}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isSel ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderDark, height: 1),
                    const SizedBox(height: 12),

                    // Grand Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Receivable',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textLight,
                          ),
                        ),
                        Text(
                          '₹${total.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.evGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Payment Method Picker
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Received Payment Method',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              ..._paymentMethods.map((method) {
                final isSelected = _selectedPaymentMethod == method;
                return InkWell(
                  onTap: () => setState(() => _selectedPaymentMethod = method),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.evGreen.withValues(alpha: 0.12) : AppColors.cardDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.evGreen : AppColors.borderDark,
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                          color: isSelected ? AppColors.evGreen : AppColors.textLightSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            method,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Green Action Button: Generate & Download Invoice
              EvGreenButton(
                text: 'Confirm Payment & Generate Invoice',
                icon: Icons.receipt_long_rounded,
                onPressed: _confirmAndGenerateInvoice,
              ),
              const SizedBox(height: 12),

              // Red Action Button: Finish and Go to Radar
              ResQOutlineButton(
                text: 'Skip to Dispatch Radar',
                borderColor: AppColors.borderDark,
                onPressed: () {
                  widget.appState.processPaymentAndFinalize(paymentMethod: _selectedPaymentMethod);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const EmployeeMainScreen()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13.5,
              color: AppColors.textLightSecondary,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
