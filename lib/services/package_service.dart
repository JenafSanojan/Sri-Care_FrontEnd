import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../controllers/network_manager.dart';
import '../../entities/error.dart';
import '../entities/provisioning/package_activation_response.dart';
import '../entities/provisioning/telco_package.dart';
import '../entities/provisioning/user_active_packages.dart';

/// Service for managing packages (data, voice, VAS)
class PackageService {
  final String _servicePath = '${NetworkConfigs.getBaseUrl()}/api/provisioning';

  /// Get all data packages
  Future<List<TelcoPackage>?> getDataPackages() async {
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
        Uri.parse('$_servicePath/data'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'SUCCESS') {
          List<dynamic> packages = jsonResponse['packages'];
          return packages.map((e) => TelcoPackage.fromJson(e)).toList();
        }
        return [];
      }

      return null;
    } catch (e) {
      print('Error getting data packages: $e');
      return null;
    }
  }

  /// Get all voice packages
  Future<List<TelcoPackage>?> getVoicePackages() async {
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
        Uri.parse('$_servicePath/voice'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'SUCCESS') {
          List<dynamic> packages = jsonResponse['packages'];
          return packages.map((e) => TelcoPackage.fromJson(e)).toList();
        }
        return [];
      }

      return null;
    } catch (e) {
      print('Error getting voice packages: $e');
      return null;
    }
  }

  /// Get all VAS (Value Added Service) packages
  Future<List<TelcoPackage>?> getVASPackages() async {
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
        Uri.parse('$_servicePath/vas'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'SUCCESS') {
          List<dynamic> packages = jsonResponse['packages'];
          return packages.map((e) => TelcoPackage.fromJson(e)).toList();
        }
        return [];
      }

      return null;
    } catch (e) {
      print('Error getting VAS packages: $e');
      return null;
    }
  }

  /// Get all packages (data + voice + VAS)
  Future<List<TelcoPackage>?> getAllPackages() async {
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
        Uri.parse('$_servicePath/all'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'SUCCESS') {
          List<dynamic> packages = jsonResponse['packages'];
          return packages.map((e) => TelcoPackage.fromJson(e)).toList();
        }
        return [];
      }

      return null;
    } catch (e) {
      print('Error getting all packages: $e');
      return null;
    }
  }

  /// Activate a package
  Future<PackageActivationResponse?> activatePackage({
    required String phoneNumber,
    required String packageId,
    required String packageType,
    required double balance,
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
        Uri.parse('$_servicePath/activate'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'packageId': packageId,
          'packageType': packageType,
          'balance': balance,
        }),
      );

      if (response.statusCode == 200) {
        final activationResponse = PackageActivationResponse.fromJson(jsonDecode(response.body));

        if (activationResponse.isSuccess) {
          CommonLoaders.successSnackBar(
              title: "Success",
              duration: 3,
              message: activationResponse.message);
        }

        return activationResponse;
      }

      // Handle specific error cases
      if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Activation failed';

        // Check for insufficient balance
        if (errorData['shortfall'] != null) {
          final shortfall = errorData['shortfall'];
          errorMessage = 'Insufficient balance. You need LKR ${shortfall.toStringAsFixed(2)} more.';
        }

        CommonLoaders.errorSnackBar(
            title: "Activation Failed", duration: 3, message: errorMessage);
        return null;
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
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

  /// Get user's active packages
  Future<UserActivePackages?> getMyActivePackages() async {
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
        Uri.parse('$_servicePath/my-packages'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'SUCCESS') {
          return UserActivePackages.fromJson(jsonResponse['activePackages']);
        }
        return UserActivePackages();
      }

      return null;
    } catch (e) {
      print('Error getting active packages: $e');
      return null;
    }
  }

  /// Convenience method: Activate data package
  Future<PackageActivationResponse?> activateDataPackage({
    required String phoneNumber,
    required String packageId,
    required double balance,
  }) async {
    return activatePackage(
      phoneNumber: phoneNumber,
      packageId: packageId,
      packageType: 'data',
      balance: balance,
    );
  }

  /// Convenience method: Activate voice package
  Future<PackageActivationResponse?> activateVoicePackage({
    required String phoneNumber,
    required String packageId,
    required double balance,
  }) async {
    return activatePackage(
      phoneNumber: phoneNumber,
      packageId: packageId,
      packageType: 'voice',
      balance: balance,
    );
  }

  /// Convenience method: Activate VAS package
  Future<PackageActivationResponse?> activateVASPackage({
    required String phoneNumber,
    required String packageId,
    required double balance,
  }) async {
    return activatePackage(
      phoneNumber: phoneNumber,
      packageId: packageId,
      packageType: 'service',
      balance: balance,
    );
  }
}