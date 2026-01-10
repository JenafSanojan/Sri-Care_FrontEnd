import 'package:sri_tel_flutter_web_mob/entities/packageBilling/transaction_type.dart';

class TransactionItem { // for temp ui usage, delete later
  final String title;
  final String? description;
  final String? imagePath; // Asset path or IconData could be used
  final String date;
  final TransactionType type;
  final double amount;

  TransactionItem({
    required this.title,
    this.description,
    this.imagePath,
    required this.date,
    required this.type,
    required this.amount,
  });
}

class Transaction {
  final String id;
  final String userId;
  final String? billId;
  final int cardNumber;
  final double amount;
  final String purpose;
  final String idempotencyKey;
  final String paymentStage;
  final String status;
  final String? providerRef;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    this.billId,
    required this.cardNumber,
    required this.amount,
    required this.purpose,
    required this.idempotencyKey,
    required this.paymentStage,
    required this.status,
    this.providerRef,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      billId: json['billId'],
      cardNumber: json['cardNumber'],
      amount: (json['amount'] as num).toDouble(),
      purpose: json['purpose'],
      idempotencyKey: json['idempotencyKey'],
      paymentStage: json['paymentStage'] ?? 'OTP_PENDING',
      status: json['status'],
      providerRef: json['providerRef'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'billId': billId,
      'cardNumber': cardNumber,
      'amount': amount,
      'purpose': purpose,
      'idempotencyKey': idempotencyKey,
      'paymentStage': paymentStage,
      'status': status,
      'providerRef': providerRef,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Purpose helpers
  bool get isBillPayment => purpose == 'BILL_PAYMENT';
  bool get isTopUp => purpose == 'TOP_UP';

  // Status helpers
  bool get isSuccess => status == 'SUCCESS';
  bool get isFailed => status == 'FAILED';
  bool get isPending => status == 'PENDING';
  bool get isCompleted => status == 'COMPLETED';
  bool get isRolledBack => status == 'ROLLED_BACK';

  // Stage helpers
  bool get isOtpPending => paymentStage == 'OTP_PENDING';
  bool get isBankConfirmed => paymentStage == 'BANK_CONFIRMED';
  bool get isBusinessDone => paymentStage == 'BUSINESS_DONE';

  // Display helpers
  String get purposeDisplay => isBillPayment ? 'Bill Payment' : 'Top Up';
  String get statusDisplay {
    switch (status) {
      case 'SUCCESS':
      case 'COMPLETED':
        return 'Completed';
      case 'FAILED':
        return 'Failed';
      case 'PENDING':
        return 'Pending OTP';
      case 'ROLLED_BACK':
        return 'Refunded';
      default:
        return status;
    }
  }
}