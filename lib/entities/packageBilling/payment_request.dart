class PaymentRequest {
  final String? billId;
  final double amount;
  final String cardNumber;
  final String expiry;
  final String cvv;
  final String purpose;
  final String idempotencyKey;

  PaymentRequest({
    this.billId,
    required this.amount,
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
    required this.purpose,
    required this.idempotencyKey,
  });

  Map<String, dynamic> toJson() {
    return {
      if (billId != null) 'billId': billId,
      'amount': amount,
      'cardNumber': cardNumber,
      'expiry': expiry,
      'cvv': cvv,
      'purpose': purpose,
    };
  }
}