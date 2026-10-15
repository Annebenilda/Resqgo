import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ServiceRoleType {
  mechanic,
  towing,
  batteryInstallation,
  petrolSupply,
  evSupport,
}

class ServiceRole {
  final ServiceRoleType type;
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isEvRelated;

  const ServiceRole({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.isEvRelated = false,
  });

  static const List<ServiceRole> allRoles = [
    ServiceRole(
      type: ServiceRoleType.mechanic,
      id: 'role_mechanic',
      title: 'Mechanic & Diagnostics',
      subtitle: 'Engine, brakes, puncture & on-spot fixes',
      icon: Icons.build_circle_rounded,
      accentColor: AppColors.primaryRed,
    ),
    ServiceRole(
      type: ServiceRoleType.towing,
      id: 'role_towing',
      title: 'Towing & Recovery',
      subtitle: 'Flatbed & wheel-lift emergency towing',
      icon: Icons.fire_truck_rounded,
      accentColor: AppColors.warningOrange,
    ),
    ServiceRole(
      type: ServiceRoleType.batteryInstallation,
      id: 'role_battery',
      title: 'Battery Installation & Jumpstart',
      subtitle: '12V/24V battery replacement & jump starts',
      icon: Icons.battery_charging_full_rounded,
      accentColor: Color(0xFFF59E0B),
    ),
    ServiceRole(
      type: ServiceRoleType.petrolSupply,
      id: 'role_petrol',
      title: 'Diesel Emergency Fuel',
      subtitle: '2L to 5L on-demand fuel dispatch',
      icon: Icons.local_gas_station_rounded,
      accentColor: AppColors.primaryRed,
    ),
    ServiceRole(
      type: ServiceRoleType.evSupport,
      id: 'role_ev',
      title: 'EV Quick Charge & Swapping',
      subtitle: 'Mobile DC fast rescue & high-voltage support',
      icon: Icons.electric_car_rounded,
      accentColor: AppColors.evGreen,
      isEvRelated: true,
    ),
  ];
}

class Employee {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final List<ServiceRoleType> assignedRoles;
  final double rating;
  final int totalJobsCompleted;
  final double walletBalance;
  final bool isOnline;
  final String vehicleInfo;
  final String licenseNumber;
  final DateTime joinedDate;

  Employee({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.assignedRoles,
    this.rating = 4.9,
    this.totalJobsCompleted = 48,
    this.walletBalance = 845.50,
    this.isOnline = true,
    this.vehicleInfo = 'ResQGo Dispatch Van (DL-04-EV-9021)',
    this.licenseNumber = 'DL92837491023',
    DateTime? joinedDate,
  }) : joinedDate = joinedDate ?? DateTime.now().subtract(const Duration(days: 120));

  Employee copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    List<ServiceRoleType>? assignedRoles,
    double? rating,
    int? totalJobsCompleted,
    double? walletBalance,
    bool? isOnline,
    String? vehicleInfo,
    String? licenseNumber,
  }) {
    return Employee(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      assignedRoles: assignedRoles ?? this.assignedRoles,
      rating: rating ?? this.rating,
      totalJobsCompleted: totalJobsCompleted ?? this.totalJobsCompleted,
      walletBalance: walletBalance ?? this.walletBalance,
      isOnline: isOnline ?? this.isOnline,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      joinedDate: joinedDate,
    );
  }
}
