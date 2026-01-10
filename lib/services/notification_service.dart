import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../controllers/network_manager.dart';
import '../../entities/notification_log.dart';
import '../../entities/error.dart';

/// Service for managing notifications (Email & SMS only)
/// View notification history and delivery status
/// Actual notification sending is handled by the backend event system
class NotificationService {
  final String _servicePath = '${NetworkConfigs.getBaseUrl()}/api/notifications';

  /// Get notification history for the current user
  /// Optional filters: channel (EMAIL/SMS), status (QUEUED/SENT/FAILED)
  Future<List<NotificationLog>?> getNotificationHistory({
    String? channel,
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
      if (channel != null) queryParams['channel'] = channel;
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit.toString();

      final uri = Uri.parse(_servicePath).replace(
          queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await http.get(
        uri,
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonBody = jsonDecode(response.body);
        return jsonBody.map((e) => NotificationLog.fromJson(e)).toList();
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Failed to load notifications",
          duration: 3,
          message: errorMessage);
      return null;
    } catch (e) {
      print('Error getting notification history: $e');
      return null;
    }
  }

  /// Get email notifications only
  Future<List<NotificationLog>?> getEmailNotifications({int? limit}) async {
    return getNotificationHistory(channel: 'EMAIL', limit: limit);
  }

  /// Get SMS notifications only
  Future<List<NotificationLog>?> getSMSNotifications({int? limit}) async {
    return getNotificationHistory(channel: 'SMS', limit: limit);
  }

  /// Get failed notifications (for retry)
  Future<List<NotificationLog>?> getFailedNotifications() async {
    return getNotificationHistory(status: 'FAILED');
  }

  /// Get count of unread/unsent notifications
  Future<Map<String, int>?> getNotificationStats() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return null;
      }

      final response = await http.get(
        Uri.parse('$_servicePath/stats'),
        headers: NetworkConfigs.getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return {
          'total': jsonResponse['total'] ?? 0,
          'sent': jsonResponse['sent'] ?? 0,
          'failed': jsonResponse['failed'] ?? 0,
          'queued': jsonResponse['queued'] ?? 0,
        };
      }

      return null;
    } catch (e) {
      print('Error getting notification stats: $e');
      return null;
    }
  }

  /// Mark notifications as read (if backend supports it)
  Future<bool> markAsRead(List<String> notificationIds) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return false;
      }

      final response = await http.post(
        Uri.parse('$_servicePath/mark-read'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({'notificationIds': notificationIds}),
      );

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print('Error marking notifications as read: $e');
      return false;
    }
  }

  /// Request retry for a failed notification (if backend supports it)
  Future<bool> retryNotification(String notificationId) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return false;
      }

      final response = await http.post(
        Uri.parse('$_servicePath/retry'),
        headers: NetworkConfigs.getHeaders(),
        body: jsonEncode({'notificationId': notificationId}),
      );

      if (response.statusCode == 200) {
        CommonLoaders.successSnackBar(
            title: "Success",
            duration: 2,
            message: "Notification queued for retry");
        return true;
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Retry Failed", duration: 3, message: errorMessage);
      return false;
    } catch (e) {
      print('Error retrying notification: $e');
      return false;
    }
  }
}