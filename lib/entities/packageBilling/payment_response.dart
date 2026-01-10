import 'transaction.dart';

class PaymentResponse {
  final String message;
  final Transaction transaction;
  final bool otpSent;

  PaymentResponse({
    required this.message,
    required this.transaction,
    this.otpSent = false,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      message: json['message'],
      transaction: Transaction.fromJson(json['transaction']),
      otpSent: json['otpSent'] ?? false,
    );
  }
}

class OtpConfirmResponse {
  final String message;
  final Transaction transaction;
  final int? attemptsLeft;

  OtpConfirmResponse({
    required this.message,
    required this.transaction,
    this.attemptsLeft,
  });

  factory OtpConfirmResponse.fromJson(Map<String, dynamic> json) {
    return OtpConfirmResponse(
      message: json['message'],
      transaction: Transaction.fromJson(json['transaction']),
      attemptsLeft: json['attemptsLeft'],
    );
  }
}