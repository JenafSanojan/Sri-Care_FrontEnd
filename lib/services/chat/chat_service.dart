import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../../controllers/network_manager.dart';
import '../../../entities/chat/chat_message.dart';
import '../../../entities/chat/chat_session.dart';
import '../../../entities/error.dart';

/// REST API service for chat operations
/// Note: For real-time messaging, use Socket.IO client separately
/// This service provides REST endpoints for history and session management
class ChatService {
  final String _servicePath = '${NetworkConfigs.getBaseUrl()}/api/chat';
  final String _sessionPath = '${NetworkConfigs.getBaseUrl()}/api/sessions';
  final String _queuePath = '${NetworkConfigs.getBaseUrl()}/api/queue';

  /// Get chat history for a specific room
  Future<List<ChatMessage>?> getChatHistory(String roomId) async {
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
        Uri.parse('$_servicePath/history/$roomId'),
        headers: NetworkConfigs.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          List<dynamic> messages = jsonResponse['messages'];
          return messages.map((e) => ChatMessage.fromJson(e)).toList();
        }
        return [];
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Failed to load chat history",
          duration: 3,
          message: errorMessage);
      return null;
    } catch (e) {
      print('Error getting chat history: $e');
      return null;
    }
  }

  /// Get all active chat sessions
  Future<List<ChatSession>?> getActiveSessions() async {
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
        Uri.parse('$_sessionPath/active'),
        headers: NetworkConfigs.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          List<dynamic> sessions = jsonResponse['sessions'];
          return sessions.map((e) => ChatSession.fromJson(e)).toList();
        }
        return [];
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Failed to load active sessions",
          duration: 3,
          message: errorMessage);
      return null;
    } catch (e) {
      print('Error getting active sessions: $e');
      return null;
    }
  }

  /// Get current queue status
  Future<int?> getQueueLength() async {
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
        Uri.parse('$_queuePath/status'),
        headers: NetworkConfigs.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          return jsonResponse['queueLength'] as int;
        }
        return 0;
      }

      final errorResponse = CommonError.fromJson(jsonDecode(response.body));
      String errorMessage = errorResponse.message ?? 'Please try again later';
      CommonLoaders.errorSnackBar(
          title: "Failed to get queue status",
          duration: 3,
          message: errorMessage);
      return null;
    } catch (e) {
      print('Error getting queue status: $e');
      return null;
    }
  }
}