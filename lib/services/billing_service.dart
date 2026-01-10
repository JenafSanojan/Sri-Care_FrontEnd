import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../controllers/network_manager.dart';
import '../entities/packageBilling/bill.dart';
import '../../entities/error.dart';

class BillingService {
  final String _servicePath = '${NetworkConfigs.getBaseUrl()}/api/billing';

  Future<List<Bill>?> getUserBills() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return null;
      }

      final response = await http.get(
        Uri.parse(_servicePath),
        headers: NetworkConfigs.defaultHeaders,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonBody = jsonDecode(response.body);
        return jsonBody.map((e) => Bill.fromJson(e)).toList();
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Failed to load bills", duration: 3, message: errorMessage);
      return null;
    } catch (e) {
      print('Error getting user bills: $e');
      return null;
    }
  }

  Future<Bill?> generateBill({
    required String billingMonth,
    double? amount,
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

      final body = {
        'billingMonth': billingMonth,
        if (amount != null) 'amount': amount,
      };

      final response = await http.post(
        Uri.parse('$_servicePath/generate'),
        headers: NetworkConfigs.defaultHeaders,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return Bill.fromJson(jsonDecode(response.body));
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Failed to generate bill", duration: 3, message: errorMessage);
      return null;
    } catch (e) {
      print('Error generating bill: $e');
      return null;
    }
  }
}