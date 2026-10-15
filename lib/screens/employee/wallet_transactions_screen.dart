import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../state/app_state.dart';
import 'employee_main_screen.dart';

class WalletTransactionsScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback? onBackToHistory;

  const WalletTransactionsScreen({
    super.key,
    required this.appState,
    this.onBackToHistory,
  });

  @override
  State<WalletTransactionsScreen> createState() => _WalletTransactionsScreenState();
}

class _WalletTransactionsScreenState extends State<WalletTransactionsScreen> {
  void _openWithdrawModal() {
    final amountController = TextEditingController(text: '500');
    final upiController = TextEditingController(text: 'rohan.sharma@okaxis');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Instant Bank Transfer',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded, color: AppColors.textLightSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Available to withdraw: ₹${widget.appState.employee.walletBalance.toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppColors.evGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Withdrawal Amount (₹)',
                  prefixIcon: Icon(Icons.currency_rupee_rounded, color: AppColors.evGreen),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: upiController,
                decoration: const InputDecoration(
                  labelText: 'UPI ID / Bank Account',
                  prefixIcon: Icon(Icons.account_balance_rounded, color: AppColors.evGreen),
                ),
              ),
              const SizedBox(height: 20),
              EvGreenButton(
                text: 'Transfer to Bank Instantly',
                icon: Icons.send_rounded,
                onPressed: () {
                  final amt = double.tryParse(amountController.text) ?? 0.0;
                  if (amt > 0 && amt <= widget.appState.employee.walletBalance) {
                    widget.appState.withdrawWalletBalance(amt, upiController.text.trim());
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.evGreen,
                        content: Text('₹${amt.toStringAsFixed(2)} transferred to ${upiController.text}!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.primaryRed,
                        content: Text('Invalid amount or insufficient balance.'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final employee = widget.appState.employee;
    final transactions = widget.appState.transactions;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 20),
          onPressed: () {
            if (widget.onBackToHistory != null) {
              widget.onBackToHistory!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const EmployeeMainScreen(initialTabIndex: 1),
                ),
              );
            }
          },
        ),
        title: Text(
          'Wallet & Payouts',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Earnings Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B382B), Color(0xFF0D241A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.evGreen.withValues(alpha: 0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.evGreen.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL WALLET BALANCE',
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: AppColors.evGreenAccent,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.evGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.bolt_rounded, size: 14, color: AppColors.evGreen),
                              const SizedBox(width: 4),
                              Text(
                                'EV & RESCUE PAY',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.evGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '₹${employee.walletBalance.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: Color(0xFF2C5642)),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jobs Completed',
                              style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
                            ),
                            Text(
                              '${employee.totalJobsCompleted} Rescues',
                              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.evGreen,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          icon: const Icon(Icons.account_balance_wallet_rounded, size: 16),
                          label: Text(
                            'Withdraw Funds',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                          onPressed: _openWithdrawModal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Transaction History Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction History',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    '${transactions.length} Records',
                    style: GoogleFonts.outfit(
                      fontSize: 12.5,
                      color: AppColors.textLightSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...transactions.map((txn) {
                final isCredit = txn.isPositive;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
                          color: (isCredit ? AppColors.evGreen : AppColors.primaryRed).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                          color: isCredit ? AppColors.evGreen : AppColors.primaryRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              txn.title,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${DateFormat('dd MMM, hh:mm a').format(txn.date)} • ${txn.method}',
                              style: GoogleFonts.outfit(
                                fontSize: 11.5,
                                color: AppColors.textLightSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isCredit ? "+" : "-"}₹${txn.amount.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isCredit ? AppColors.evGreen : AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
