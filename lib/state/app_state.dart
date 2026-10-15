import 'dart:math';
import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../models/service_request_model.dart';
import '../models/transaction_model.dart';
import '../models/invoice_model.dart';

class AppState extends ChangeNotifier {
  // Current Auth State
  bool _isLoggedIn = true;
  String _currentUserRole = 'employee'; // 'employee' or 'user'
  Employee _employee = Employee(
    id: 'RSQ-EMP-7842',
    fullName: 'Alex Vance',
    email: 'alex.vance@resqgo.com',
    phone: '+91 98765 43210',
    avatarUrl: null,
    assignedRoles: [
      ServiceRoleType.evSupport,
      ServiceRoleType.mechanic,
      ServiceRoleType.petrolSupply,
      ServiceRoleType.batteryInstallation,
      ServiceRoleType.towing,
    ],
    rating: 4.92,
    totalJobsCompleted: 58,
    walletBalance: 1280.00,
    isOnline: true,
    vehicleInfo: 'ResQGo Rapid Support Van (DL-08-EV-2024)',
    licenseNumber: 'DL-98202319842',
  );

  // Active / Current in-progress service
  ServiceRequest? _activeRequest;
  InvoiceModel? _latestGeneratedInvoice;

  // Nearby requests pool
  List<ServiceRequest> _nearbyRequests = [];

  // Completed history
  final List<ServiceRequest> _completedRequests = [];

  // Transactions list
  final List<TransactionModel> _transactions = [];

  // Invoices list
  final List<InvoiceModel> _invoices = [];

  // Selected distance filter in km
  double _distanceFilterKm = 10.0;

  AppState() {
    _initializeMockData();
  }

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get currentUserRole => _currentUserRole;
  Employee get employee => _employee;
  ServiceRequest? get activeRequest => _activeRequest;
  InvoiceModel? get latestGeneratedInvoice => _latestGeneratedInvoice;
  List<ServiceRequest> get nearbyRequests => List.unmodifiable(_nearbyRequests);
  List<ServiceRequest> get completedRequests => List.unmodifiable(_completedRequests);
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  List<InvoiceModel> get invoices => List.unmodifiable(_invoices);
  double get distanceFilterKm => _distanceFilterKm;

  void setDistanceFilter(double km) {
    _distanceFilterKm = km;
    notifyListeners();
  }

  static String generateUniqueEmployeeId() {
    final random = Random();
    final number = 1000 + random.nextInt(9000);
    return 'RSQ-EMP-$number';
  }

  void loginAsEmployee({
    required String fullName,
    required String email,
    required String phone,
    required String employeeId,
    required List<ServiceRoleType> roles,
    String? avatarUrl,
  }) {
    _employee = Employee(
      id: employeeId.isNotEmpty ? employeeId : generateUniqueEmployeeId(),
      fullName: fullName,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      assignedRoles: roles.isNotEmpty ? roles : [ServiceRoleType.mechanic, ServiceRoleType.evSupport],
      rating: 5.0,
      totalJobsCompleted: 0,
      walletBalance: 0.0,
      isOnline: true,
    );
    _currentUserRole = 'employee';
    _isLoggedIn = true;
    notifyListeners();
  }

  void loginAsUser({required String name, required String phone}) {
    _currentUserRole = 'user';
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void toggleOnlineStatus() {
    _employee = _employee.copyWith(isOnline: !_employee.isOnline);
    notifyListeners();
  }

  void updateEmployeeRoles(List<ServiceRoleType> newRoles) {
    _employee = _employee.copyWith(assignedRoles: newRoles);
    notifyListeners();
  }

  void updateEmployeeDetails({
    String? fullName,
    String? email,
    String? phone,
    String? vehicleInfo,
    String? avatarUrl,
  }) {
    _employee = _employee.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      vehicleInfo: vehicleInfo,
      avatarUrl: avatarUrl,
    );
    notifyListeners();
  }

  // Service Request Flow
  void acceptRequest(ServiceRequest request) {
    _nearbyRequests.removeWhere((item) => item.id == request.id);
    request.status = RequestStatus.accepted;
    _activeRequest = request;
    notifyListeners();
  }

  void rejectRequest(ServiceRequest request) {
    _nearbyRequests.removeWhere((item) => item.id == request.id);
    notifyListeners();
  }

  void setRequestStatus(RequestStatus newStatus) {
    if (_activeRequest != null) {
      _activeRequest!.status = newStatus;
      notifyListeners();
    }
  }

  void toggleChecklistItem(String itemId) {
    if (_activeRequest != null) {
      final item = _activeRequest!.checklist.firstWhere((i) => i.id == itemId);
      item.isCompleted = !item.isCompleted;
      notifyListeners();
    }
  }

  void completeActiveService() {
    if (_activeRequest != null) {
      _activeRequest!.status = RequestStatus.completed;
      notifyListeners();
    }
  }

  void processPaymentAndFinalize({
    required String paymentMethod,
    double tipAmount = 0.0,
  }) {
    if (_activeRequest == null) return;

    final req = _activeRequest!;
    req.status = RequestStatus.paid;

    // Generate Invoice
    final invoice = InvoiceModel.fromServiceRequest(req, _employee.fullName, _employee.id);
    _latestGeneratedInvoice = invoice;
    _invoices.insert(0, invoice);

    // Update Wallet & Transactions
    final earned = req.totalFare;
    _employee = _employee.copyWith(
      walletBalance: _employee.walletBalance + earned,
      totalJobsCompleted: _employee.totalJobsCompleted + 1,
    );

    _transactions.insert(
      0,
      TransactionModel(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
        title: 'Payout: ${req.categoryName}',
        subtitle: 'Customer: ${req.customerName} (${req.vehicleModel})',
        amount: earned,
        type: TransactionType.credit,
        date: DateTime.now(),
        requestId: req.id,
        method: paymentMethod,
      ),
    );

    _completedRequests.insert(0, req);
    _activeRequest = null;
    notifyListeners();
  }

  void withdrawWalletBalance(double amount, String destination) {
    if (amount <= 0 || amount > _employee.walletBalance) return;

    _employee = _employee.copyWith(
      walletBalance: _employee.walletBalance - amount,
    );

    _transactions.insert(
      0,
      TransactionModel(
        id: 'WTH-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
        title: 'Withdrawal to $destination',
        subtitle: 'Processed instantly',
        amount: amount,
        type: TransactionType.payout,
        date: DateTime.now(),
        method: destination,
      ),
    );

    notifyListeners();
  }

  void addNewRequestFromUser(ServiceRequest req) {
    _nearbyRequests.insert(0, req);
    notifyListeners();
  }

  void _initializeMockData() {
    _nearbyRequests = [
      ServiceRequest(
        id: 'REQ-901',
        customerName: 'Priya Sharma',
        customerPhone: '+91 98112 34567',
        customerAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        customerAddress: 'Outer Ring Road, Near Tech Park Gate 3, Sector 62',
        customerLat: 28.6280,
        customerLng: 77.3649,
        vehicleModel: 'Tesla Model 3 Long Range',
        vehiclePlate: 'DL-01-EV-4421',
        isEv: true,
        roleType: ServiceRoleType.evSupport,
        title: 'EV Battery Depleted - Emergency Fast Boost Required',
        description: 'Battery dropped to 1% while stuck in traffic. Vehicle parked at shoulder near Metro Pillar 124.',
        distanceKm: 1.2,
        etaMinutes: 6,
        baseFare: 45.00,
        partsCost: 35.00,
        laborCost: 15.00,
        taxAmount: 8.50,
      ),
      ServiceRequest(
        id: 'REQ-902',
        customerName: 'Rahul Verma',
        customerPhone: '+91 98223 99881',
        customerAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        customerAddress: 'Expressway Flyover, Lane 2, Milestone 14',
        customerLat: 28.6139,
        customerLng: 77.3512,
        vehicleModel: 'Hyundai Creta SX 1.5 Diesel',
        vehiclePlate: 'UP-16-BZ-8920',
        isEv: false,
        roleType: ServiceRoleType.petrolSupply,
        title: 'Fuel Empty - Need 5 Litres Speed Diesel',
        description: 'Fuel indicator showed empty and engine cut off on the ramp. Need emergency canister.',
        distanceKm: 2.8,
        etaMinutes: 11,
        baseFare: 25.00,
        partsCost: 20.00,
        laborCost: 10.00,
        taxAmount: 6.00,
      ),
      ServiceRequest(
        id: 'REQ-903',
        customerName: 'Ananya Deshmukh',
        customerPhone: '+91 98990 11223',
        customerAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
        customerAddress: 'Cyber City Cyber Hub Parking B2',
        customerLat: 28.4950,
        customerLng: 77.0890,
        vehicleModel: 'Honda City ZX',
        vehiclePlate: 'HR-26-EQ-5510',
        isEv: false,
        roleType: ServiceRoleType.batteryInstallation,
        title: '12V Battery Dead / No Ignition Crank',
        description: 'Car was parked for 2 weeks. Clicking sound on ignition. Need jumpstart or new Amaron battery.',
        distanceKm: 3.5,
        etaMinutes: 14,
        baseFare: 30.00,
        partsCost: 65.00,
        laborCost: 15.00,
        taxAmount: 9.00,
      ),
      ServiceRequest(
        id: 'REQ-904',
        customerName: 'Vikramjit Singh',
        customerPhone: '+91 97114 88371',
        customerAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        customerAddress: 'Grand Trunk Road, Near toll plaza',
        customerLat: 28.7041,
        customerLng: 77.1025,
        vehicleModel: 'Tata Harrier XZA+',
        vehiclePlate: 'HR-10-AJ-1209',
        isEv: false,
        roleType: ServiceRoleType.mechanic,
        title: 'Severe Tyre Puncture & Rim Damage',
        description: 'Hit a pothole at 60kmph. Tyre completely deflated and lug nuts are jammed.',
        distanceKm: 4.9,
        etaMinutes: 18,
        baseFare: 35.00,
        partsCost: 20.00,
        laborCost: 20.00,
        taxAmount: 8.00,
      ),
      ServiceRequest(
        id: 'REQ-905',
        customerName: 'Rohan Mehra',
        customerPhone: '+91 99110 55442',
        customerAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
        customerAddress: 'Golf Course Road, Near Rapid Metro Pillar 42',
        customerLat: 28.4595,
        customerLng: 77.0266,
        vehicleModel: 'Mahindra Scorpio-N 4x4',
        vehiclePlate: 'DL-03-CC-9001',
        isEv: false,
        roleType: ServiceRoleType.towing,
        title: 'Transmission Lockup - Flatbed Tow Needed',
        description: 'Clutch failed completely and vehicle won’t enter neutral. Needs flatbed tow to nearest service center.',
        distanceKm: 6.2,
        etaMinutes: 22,
        baseFare: 80.00,
        partsCost: 0.00,
        laborCost: 40.00,
        taxAmount: 18.00,
      ),
    ];

    // Prepopulate Completed Requests & Invoices
    final completed1 = ServiceRequest(
      id: 'REQ-882',
      customerName: 'Arjun Kapoor',
      customerPhone: '+91 98450 12345',
      customerAddress: 'South Extension Part II, Ring Road',
      customerLat: 28.5680,
      customerLng: 77.2200,
      vehicleModel: 'MG ZS EV Excite',
      vehiclePlate: 'DL-09-EV-7788',
      isEv: true,
      roleType: ServiceRoleType.evSupport,
      title: 'EV Fast Charge Top-up',
      description: 'Emergency 15 kWh DC charge delivered on spot.',
      distanceKm: 2.1,
      etaMinutes: 8,
      baseFare: 50.00,
      partsCost: 40.00,
      laborCost: 20.00,
      taxAmount: 12.00,
      tipAmount: 10.00,
      status: RequestStatus.paid,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    );

    final completed2 = ServiceRequest(
      id: 'REQ-879',
      customerName: 'Meera Nambiar',
      customerPhone: '+91 97123 45678',
      customerAddress: 'Noida Expressway Sector 128',
      customerLat: 28.5100,
      customerLng: 77.3800,
      vehicleModel: 'Maruti Suzuki Swift',
      vehiclePlate: 'UP-16-CK-3321',
      isEv: false,
      roleType: ServiceRoleType.petrolSupply,
      title: '3L Diesel Emergency Delivery',
      description: 'Fuel delivered and air purge completed.',
      distanceKm: 3.4,
      etaMinutes: 12,
      baseFare: 25.00,
      partsCost: 15.00,
      laborCost: 10.00,
      taxAmount: 5.50,
      tipAmount: 5.00,
      status: RequestStatus.paid,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );

    final completed3 = ServiceRequest(
      id: 'REQ-864',
      customerName: 'Kunal Singhania',
      customerPhone: '+91 99200 88776',
      customerAddress: 'Vasant Kunj Pocket C',
      customerLat: 28.5200,
      customerLng: 77.1500,
      vehicleModel: 'Hyundai Ioniq 5',
      vehiclePlate: 'DL-02-EV-9011',
      isEv: true,
      roleType: ServiceRoleType.evSupport,
      title: 'EV 12V Auxiliary Battery Jump & HV Diagnostics',
      description: 'Diagnosed aux battery failure and cleared BMS alert.',
      distanceKm: 4.8,
      etaMinutes: 15,
      baseFare: 60.00,
      partsCost: 45.00,
      laborCost: 25.00,
      taxAmount: 15.00,
      status: RequestStatus.paid,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    );

    _completedRequests.addAll([completed1, completed2, completed3]);

    for (final req in _completedRequests) {
      final inv = InvoiceModel.fromServiceRequest(req, _employee.fullName, _employee.id);
      _invoices.add(inv);

      _transactions.add(
        TransactionModel(
          id: 'TXN-${req.id.replaceAll("REQ-", "88")}',
          title: 'Payout: ${req.categoryName}',
          subtitle: 'Customer: ${req.customerName} (${req.vehicleModel})',
          amount: req.totalFare,
          type: TransactionType.credit,
          date: req.createdAt,
          requestId: req.id,
          method: 'UPI Direct',
        ),
      );
    }
  }
}
