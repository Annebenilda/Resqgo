import 'package:intl/intl.dart';
import 'service_request_model.dart';

class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;
}

class InvoiceModel {
  final String invoiceNumber;
  final DateTime issuedDate;
  final DateTime dueDate;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String employeeName;
  final String employeeId;
  final String vehicleDetails;
  final String serviceCategory;
  final List<InvoiceItem> items;
  final double discount;
  final double taxRate;
  final String paymentMode;
  final String paymentStatus;

  InvoiceModel({
    required this.invoiceNumber,
    required this.issuedDate,
    required this.dueDate,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.employeeName,
    required this.employeeId,
    required this.vehicleDetails,
    required this.serviceCategory,
    required this.items,
    this.discount = 0.0,
    this.taxRate = 0.18, // 18% GST / VAT
    required this.paymentMode,
    this.paymentStatus = 'PAID',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get taxAmount => (subtotal - discount) * taxRate;
  double get grandTotal => (subtotal - discount) + taxAmount;

  String get formattedDate => DateFormat('dd MMM yyyy, hh:mm a').format(issuedDate);

  factory InvoiceModel.fromServiceRequest(ServiceRequest req, String empName, String empId) {
    final List<InvoiceItem> items = [
      InvoiceItem(
        description: '${req.categoryName} Base Callout & Labor',
        quantity: 1,
        unitPrice: req.baseFare + req.laborCost,
      ),
    ];

    if (req.partsCost > 0) {
      items.add(
        InvoiceItem(
          description: req.isEv
              ? 'EV Emergency Booster kWh Delivery'
              : 'Parts & Consumables / Emergency Fuel',
          quantity: 1,
          unitPrice: req.partsCost,
        ),
      );
    }

    if (req.tipAmount > 0) {
      items.add(
        InvoiceItem(
          description: 'Special Service Gratitude / Tip',
          quantity: 1,
          unitPrice: req.tipAmount,
        ),
      );
    }

    return InvoiceModel(
      invoiceNumber: 'INV-${req.id.replaceAll("REQ-", "")}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      issuedDate: DateTime.now(),
      dueDate: DateTime.now(),
      customerName: req.customerName,
      customerPhone: req.customerPhone,
      customerAddress: req.customerAddress,
      employeeName: empName,
      employeeId: empId,
      vehicleDetails: '${req.vehicleModel} (${req.vehiclePlate})',
      serviceCategory: req.categoryName,
      items: items,
      taxRate: 0.18,
      paymentMode: req.paymentMethod,
      paymentStatus: 'PAID',
    );
  }
}
