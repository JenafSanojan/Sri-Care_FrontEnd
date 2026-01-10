import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../controllers/network_manager.dart';
import '../../entities/error.dart';
import '../entities/packageBilling/payment_request.dart';
import '../entities/packageBilling/payment_response.dart';
import '../entities/packageBilling/transaction.dart';

class PaymentService {
  final String _servicePath = '${NetworkConfigs.getBaseUrl()}/api/payments';
  final Uuid _uuid = Uuid();

  /// Initiate a payment transaction
  /// Returns PaymentResponse with transaction details and OTP status
  Future<PaymentResponse?> initiatePayment({
    String? billId,
    required double amount,
    required String cardNumber,
    required String expiry,
    required String cvv,
    required String purpose, // 'BILL_PAYMENT' or 'TOP_UP'
    required String idempotencyKey,
  }) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return null;
      }

      final paymentRequest = PaymentRequest(
        billId: billId,
        amount: amount,
        cardNumber: cardNumber,
        expiry: expiry,
        cvv: cvv,
        purpose: purpose,
        idempotencyKey: idempotencyKey,
      );

      final headers = {
        ...NetworkConfigs.getHeaders(),
        'idempotency-key': idempotencyKey,
      };

      final response = await http.post(
        Uri.parse('$_servicePath/pay'),
        headers: headers,
        body: jsonEncode(paymentRequest.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PaymentResponse.fromJson(jsonDecode(response.body));
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Payment Failed", duration: 3, message: errorMessage);
      return null;
    } catch (e) {
      print('Error initiating payment: $e');
      CommonLoaders.errorSnackBar(
          title: "Payment Error",
          duration: 3,
          message: "An unexpected error occurred");
      return null;
    }
  }

  /// Confirm payment with OTP
  /// Returns success or error with attempts left
  Future<OtpConfirmResponse?> confirmPayment({
    required String providerRef,
    required String otp,
  }) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return null;
      }

      final response = await http.post(
        Uri.parse('$_servicePath/confirm'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({
          'providerRef': providerRef,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final confirmResponse = OtpConfirmResponse.fromJson(jsonDecode(response.body));

        if (confirmResponse.transaction.isCompleted) {
          CommonLoaders.successSnackBar(
              title: "Success",
              duration: 3,
              message: "Payment completed successfully");
        }

        return confirmResponse;
      }

      // Handle OTP errors
      if (response.statusCode == 400 || response.statusCode == 403) {
        final errorData = jsonDecode(response.body);
        final attemptsLeft = errorData['attemptsLeft'];

        String message = errorData['message'] ?? 'Invalid OTP';
        if (attemptsLeft != null) {
          message += '\n$attemptsLeft attempts left';
        }

        CommonLoaders.errorSnackBar(
            title: "Verification Failed", duration: 3, message: message);

        return null;
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Confirmation Failed", duration: 3, message: errorMessage);
      return null;
    } catch (e) {
      print('Error confirming payment: $e');
      CommonLoaders.errorSnackBar(
          title: "Confirmation Error",
          duration: 3,
          message: "An unexpected error occurred");
      return null;
    }
  }

  /// Get transaction history for the current user
  Future<List<Transaction>?> getTransactionHistory({
    String? purpose,
    String? status,
    int? limit,
  }) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return null;
      }

      // Build query parameters
      final queryParams = <String, String>{};
      if (purpose != null) queryParams['purpose'] = purpose;
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit.toString();

      final uri = Uri.parse('$_servicePath/history').replace(
          queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await http.get(
        uri,
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonBody = jsonDecode(response.body);
        return jsonBody.map((e) => Transaction.fromJson(e)).toList();
      }

      return null;
    } catch (e) {
      print('Error getting transaction history: $e');
      return null;
    }
  }

  /// Get a specific transaction by ID
  Future<Transaction?> getTransaction(String transactionId) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return null;
      }

      final response = await http.get(
        Uri.parse('$_servicePath/$transactionId'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        return Transaction.fromJson(jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      print('Error getting transaction: $e');
      return null;
    }
  }

  /// Pay a bill (convenience method)
  Future<PaymentResponse?> payBill({
    required String billId,
    required double amount,
    required String cardNumber,
    required String expiry,
    required String cvv,
  }) async {
    return initiatePayment(
      billId: billId,
      amount: amount,
      cardNumber: cardNumber,
      expiry: expiry,
      cvv: cvv,
      purpose: 'BILL_PAYMENT',
      idempotencyKey: "bill-${DateTime.now().toString()}_${_uuid.v4().substring(0,7)}",
    );
  }

  /// Top up wallet (convenience method)
  Future<PaymentResponse?> topUpWallet({
    required double amount,
    required String cardNumber,
    required String expiry,
    required String cvv,
  }) async {
    return initiatePayment(
      amount: amount,
      cardNumber: cardNumber,
      expiry: expiry,
      cvv: cvv,
      purpose: 'TOP_UP',
      idempotencyKey: "topup-${DateTime.now().toString()}_${_uuid.v4().substring(0,7)}",
    );
  }
}