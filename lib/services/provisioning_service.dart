import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../controllers/network_manager.dart';
import '../../entities/provisioning/telco_balance.dart';
import '../../entities/provisioning/telco_package.dart';
import '../../entities/provisioning/provisioning_response.dart';
import '../../entities/provisioning/user_sim_profile.dart';
import '../../entities/error.dart';

/// Service for managing telco network provisioning
/// Handles balance checks, reloads, package activations, and roaming
class ProvisioningService {
  final String _servicePath = '${NetworkConfigs.getBaseUrl()}/provision';

  /// Get balance for a phone number
  Future<TelcoBalance?> getBalance(String phoneNumber) async {
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
        Uri.parse('$_servicePath/balance/$phoneNumber'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        return TelcoBalance.fromJson(jsonDecode(response.body));
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Failed to get balance';
      CommonLoaders.errorSnackBar(
          title: "Balance Check Failed", duration: 3, message: errorMessage);
      return null;
    } catch (e) {
      print('Error getting balance: $e');
      return null;
    }
  }

  /// Reload/top-up a phone number
  Future<ProvisioningResponse?> reload({
    required String phoneNumber,
    required double amount,
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
        Uri.parse('$_servicePath/reload'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({
          'phone': phoneNumber,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final reloadResponse = ProvisioningResponse.fromJson(jsonDecode(response.body));

        if (reloadResponse.isSuccess) {
          CommonLoaders.successSnackBar(
              title: "Success",
              duration: 3,
              message: "Reloaded LKR ${amount.toStringAsFixed(2)}");
        }

        return reloadResponse;
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Reload failed';
      CommonLoaders.errorSnackBar(
          title: "Reload Failed", duration: 3, message: errorMessage);
      return null;
    } catch (e) {
      print('Error reloading: $e');
      CommonLoaders.errorSnackBar(
          title: "Reload Error",
          duration: 3,
          message: "An unexpected error occurred");
      return null;
    }
  }

  /// Activate a package
  Future<ProvisioningResponse?> activatePackage({
    required String phoneNumber,
    required String packageName,
    required double cost,
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
        Uri.parse('$_servicePath/package'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({
          'phone': phoneNumber,
          'packageName': packageName,
          'cost': cost,
        }),
      );

      if (response.statusCode == 200) {
        final packageResponse = ProvisioningResponse.fromJson(jsonDecode(response.body));

        if (packageResponse.isSuccess) {
          CommonLoaders.successSnackBar(
              title: "Package Activated",
              duration: 3,
              message: "$packageName has been activated");
        }

        return packageResponse;
      }

      // Handle insufficient balance
      if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        CommonLoaders.errorSnackBar(
            title: "Activation Failed",
            duration: 3,
            message: errorData['message'] ?? 'Insufficient Balance');
        return null;
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Activation failed';
      CommonLoaders.errorSnackBar(
          title: "Activation Failed", duration: 3, message: errorMessage);
      return null;
    } catch (e) {
      print('Error activating package: $e');
      CommonLoaders.errorSnackBar(
          title: "Activation Error",
          duration: 3,
          message: "An unexpected error occurred");
      return null;
    }
  }

  /// Enable or disable roaming
  Future<ProvisioningResponse?> setRoaming({
    required String phoneNumber,
    required bool enabled,
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
        Uri.parse('$_servicePath/roaming'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({
          'phone': phoneNumber,
          'status': enabled,
        }),
      );

      if (response.statusCode == 200) {
        final roamingResponse = ProvisioningResponse.fromJson(jsonDecode(response.body));

        if (roamingResponse.isSuccess) {
          CommonLoaders.successSnackBar(
              title: enabled ? "Roaming Enabled" : "Roaming Disabled",
              duration: 2,
              message: roamingResponse.message);
        }

        return roamingResponse;
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Roaming update failed';
      CommonLoaders.errorSnackBar(
          title: "Roaming Failed", duration: 3, message: errorMessage);
      return null;
    } catch (e) {
      print('Error setting roaming: $e');
      CommonLoaders.errorSnackBar(
          title: "Roaming Error",
          duration: 3,
          message: "An unexpected error occurred");
      return null;
    }
  }

  /// Get complete user SIM profile (if backend provides it)
  Future<UserSimProfile?> getUserProfile(String phoneNumber) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return null;
      }

      final response = await http.get(
        Uri.parse('$_servicePath/profile/$phoneNumber'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        return UserSimProfile.fromJson(jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Get available packages (if backend provides it)
  Future<List<TelcoPackage>?> getAvailablePackages() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return null;
      }

      final response = await http.get(
        Uri.parse('$_servicePath/packages'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonBody = jsonDecode(response.body);
        return jsonBody.map((e) => TelcoPackage.fromJson(e)).toList();
      }

      return null;
    } catch (e) {
      print('Error getting packages: $e');
      return null;
    }
  }
}