class Bill {
  final String id;
  final String userId;
  final String billingMonth;
  final double amount;
  final String status;
  final Map<String, dynamic>? details;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Bill({
    required this.id,
    required this.userId,
    required this.billingMonth,
    required this.amount,
    required this.status,
    this.details,
    this.createdAt,
    this.updatedAt,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      billingMonth: json['billingMonth'],
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      details: json['details'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'billingMonth': billingMonth,
      'amount': amount,
      'status': status,
      'details': details,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}