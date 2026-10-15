import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum TransactionType { credit, debit, payout }

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? requestId;
  final String status;
  final String method;

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.date,
    this.requestId,
    this.status = 'Completed',
    this.method = 'UPI / Bank Transfer',
  });

  bool get isPositive => type == TransactionType.credit;

  Color get amountColor => isPositive ? AppColors.evGreen : AppColors.primaryRed;
}
