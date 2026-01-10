import 'dart:convert';

import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/entities/user.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import 'package:http/http.dart' as http;
import '../controllers/network_manager.dart';
import '../entities/error.dart';

// List<dynamic> jsonBody = jsonDecode(response.body);
// return jsonBody.map((e) => KitchenUser.fromJson(e)).toList();

// return Shop.fromJson(jsonDecode(response.body));

class UserService {
  final String _servicePath = '${NetworkConfigs.getBaseUrl()}/api/users';

  // feedbacks handled here
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String mobileNumber,
    String? photoURL, // Optional: to set on Firebase Auth profile
    String? defaultRoleId, // Optional: to set in the Firestore user profile
  }) async {
    try {
      // checking the connection
      final isConnected = await NetworkManager.instance.isConnected();
      // print(isConnected);
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return null; // cannot login
      }

      final response = await http.post(
        Uri.parse('$_servicePath/register'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({
          "name": displayName,
          "email": email,
          "mobileNumber": mobileNumber,
          "password": password
        }),
      );

      if (response.statusCode == 201) {
        return User.fromJson(jsonDecode(response.body));
      }
      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Sign Up Failed", duration: 3, message: errorMessage);
      return null; // failed login
    } catch (e) {
      print('Error during canSignIn check: $e');
      return null;
    }
  }

  // feedbacks handled here
  Future<User?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      // checking the connection
      final isConnected = await NetworkManager.instance.isConnected();
      // print(isConnected);
      if (!isConnected) {
        CommonLoaders.warningSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return null; // cannot login
      }

      final response = await http.post(
        Uri.parse('$_servicePath/login'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
      CommonLoaders.errorSnackBar(
          title: "Sign In Failed",
          duration: 3,
          message: "Please check your credentials and try again");
      return null; // failed login
    } catch (e) {
      print('Error during sign in process: $e');
      throw Exception('An unexpected error occurred during sign in.');
    }
  }

  Future<bool?> changePassword(User user, String currentPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$_servicePath/change-password'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({
          "user": user.toJson(),
          "currentPassword": currentPassword,
          "newPassword": newPassword
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Change Password Failed", duration: 3, message: errorMessage);
      return false; // failed
    } catch (e) {
      print('Error changing password: $e');
      return null;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_servicePath/reset-password'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        return true;
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Password Reset Failed", duration: 3, message: errorMessage);
      return false; // failed
    } catch (e) {
      print('Error sending password reset email: $e');
      return false;
    }
  }
}