import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'employee_model.dart';

enum RequestStatus {
  pending,
  accepted,
  onTheWay,
  arrived,
  inProgress,
  completed,
  paid,
  cancelled,
}

class ChecklistItem {
  final String id;
  final String title;
  bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

class ServiceRequest {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAvatar;
  final String customerAddress;
  final double customerLat;
  final double customerLng;
  final String vehicleModel;
  final String vehiclePlate;
  final bool isEv;
  final ServiceRoleType roleType;
  final String title;
  final String description;
  final String? issueImage;
  final double distanceKm;
  final int etaMinutes;
  final double baseFare;
  final double partsCost;
  final double laborCost;
  final double taxAmount;
  final double tipAmount;
  final String paymentMethod; // 'Online UPI', 'Card', 'Cash'
  RequestStatus status;
  final DateTime createdAt;
  final List<ChecklistItem> checklist;

  ServiceRequest({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    this.customerAvatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    required this.customerAddress,
    required this.customerLat,
    required this.customerLng,
    required this.vehicleModel,
    required this.vehiclePlate,
    this.isEv = false,
    required this.roleType,
    required this.title,
    required this.description,
    this.issueImage,
    required this.distanceKm,
    required this.etaMinutes,
    required this.baseFare,
    this.partsCost = 0.0,
    this.laborCost = 0.0,
    this.taxAmount = 0.0,
    this.tipAmount = 0.0,
    this.paymentMethod = 'Online UPI',
    this.status = RequestStatus.pending,
    DateTime? createdAt,
    List<ChecklistItem>? checklist,
  })  : createdAt = createdAt ?? DateTime.now(),
        checklist = checklist ??
            [
              ChecklistItem(id: 'c1', title: 'Setup Safety Cones & Hazard Warning Lights'),
              ChecklistItem(id: 'c2', title: 'Perform Diagnostic Inspection of Issue'),
              ChecklistItem(id: 'c3', title: 'Execute Authorized Repair / Fuel / EV Charge'),
              ChecklistItem(id: 'c4', title: 'Verify Vehicle Start & Safe Driveability'),
              ChecklistItem(id: 'c5', title: 'Obtain Customer Digital Signature / Confirmation'),
            ];

  double get totalFare => baseFare + partsCost + laborCost + taxAmount + tipAmount;

  String get categoryName {
    switch (roleType) {
      case ServiceRoleType.mechanic:
        return 'Mechanic Service';
      case ServiceRoleType.towing:
        return 'Towing Recovery';
      case ServiceRoleType.batteryInstallation:
        return 'Battery Installation';
      case ServiceRoleType.petrolSupply:
        return 'Emergency Diesel Supply';
      case ServiceRoleType.evSupport:
        return 'EV Rapid Charge & Support';
    }
  }

  Color get categoryColor {
    if (isEv || roleType == ServiceRoleType.evSupport) {
      return AppColors.evGreen;
    }
    switch (roleType) {
      case ServiceRoleType.mechanic:
      case ServiceRoleType.petrolSupply:
        return AppColors.primaryRed;
      case ServiceRoleType.towing:
        return AppColors.warningOrange;
      case ServiceRoleType.batteryInstallation:
        return const Color(0xFFF59E0B);
      default:
        return AppColors.primaryRed;
    }
  }

  IconData get categoryIcon {
    switch (roleType) {
      case ServiceRoleType.mechanic:
        return Icons.build_circle_rounded;
      case ServiceRoleType.towing:
        return Icons.fire_truck_rounded;
      case ServiceRoleType.batteryInstallation:
        return Icons.battery_charging_full_rounded;
      case ServiceRoleType.petrolSupply:
        return Icons.local_gas_station_rounded;
      case ServiceRoleType.evSupport:
        return Icons.electric_car_rounded;
    }
  }
}
