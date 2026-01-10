import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import '../../../entities/chat/chat_message.dart';

/// Socket.IO service for real-time chat functionality
/// Handles WebSocket connections for instant messaging
/// 
/// Usage:
/// 1. Call connectAsCustomer() or connectAsAgent()
/// 2. Listen to stream events (onMessageReceived, onAgentAssigned, etc.)
/// 3. Use sendMessage() to send messages
/// 4. Call disconnect() when done
class ChatSocketService {
  io.Socket? _socket;
  String? _currentRoomId;

  // Stream controllers for real-time events
  final _messageReceivedController = StreamController<ChatMessage>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  final _agentAssignedController = StreamController<Map<String, dynamic>>.broadcast();
  final _queuedController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<ChatMessage> get onMessageReceived => _messageReceivedController.stream;
  Stream<Map<String, dynamic>> get onTyping => _typingController.stream;
  Stream<Map<String, dynamic>> get onAgentAssigned => _agentAssignedController.stream;
  Stream<Map<String, dynamic>> get onQueued => _queuedController.stream;

  bool get isConnected => _socket?.connected ?? false;
  String? get currentRoomId => _currentRoomId;

  /// Connect to chat service as a customer
  Future<void> connectAsCustomer({
    required String customerId,
    required String customerName,
  }) async {
    if (_socket != null && _socket!.connected) {
      print('Already connected');
      return;
    }

    final socketUrl = NetworkConfigs.getBaseUrl();

    _socket = io.io(socketUrl, <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': false,
    });

    _setupListeners();
    _socket!.connect();

    _socket!.onConnect((_) {
      print('🔌 Connected to chat service');
      _currentRoomId = 'room_$customerId';

      _socket!.emit('customer:join', {
        'customerId': customerId,
        'customerName': customerName,
      });
    });
  }

  /// Connect to chat service as an agent
  Future<void> connectAsAgent({
    required String agentId,
    required String agentName,
  }) async {
    if (_socket != null && _socket!.connected) {
      print('Already connected');
      return;
    }

    final socketUrl = NetworkConfigs.getBaseUrl();

    _socket = io.io(socketUrl, <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': false,
    });

    _setupListeners();
    _socket!.connect();

    _socket!.onConnect((_) {
      print('🔌 Agent connected to chat service');

      _socket!.emit('agent:online', {
        'agentId': agentId,
        'agentName': agentName,
      });
    });
  }

  /// Join a specific chat room (for agents)
  void joinRoom(String roomId) {
    if (_socket == null || !_socket!.connected) {
      print('Socket not connected');
      return;
    }

    _currentRoomId = roomId;
    _socket!.emit('agent:join-room', {'roomId': roomId});
  }

  /// Send a message
  Future<bool> sendMessage({
    required String message,
    required String recipientId,
  }) async {
    if (_socket == null || !_socket!.connected || _currentRoomId == null) {
      print('Socket not connected or no room joined');
      return false;
    }

    final completer = Completer<bool>();

    _socket!.emitWithAck('message:send', {
      'roomId': _currentRoomId,
      'message': message,
      'recipientId': recipientId,
    }, ack: (data) {
      if (data['success'] == true) {
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    });

    return completer.future;
  }

  /// Notify typing status
  void startTyping() {
    if (_socket == null || !_socket!.connected || _currentRoomId == null) return;
    _socket!.emit('typing:start', {'roomId': _currentRoomId});
  }

  void stopTyping() {
    if (_socket == null || !_socket!.connected || _currentRoomId == null) return;
    _socket!.emit('typing:stop', {'roomId': _currentRoomId});
  }

  /// Close chat session (for agents)
  void closeChat(String reason) {
    if (_socket == null || !_socket!.connected || _currentRoomId == null) return;

    _socket!.emit('agent:close-chat', {
      'roomId': _currentRoomId,
      'reason': reason,
    });
  }

  void _setupListeners() {
    // Incoming message
    _socket!.on('message:received', (data) {
      try {
        final message = ChatMessage(
          id: data['messageId'],
          roomId: _currentRoomId ?? '',
          senderId: data['senderId'],
          senderRole: data['senderRole'],
          recipientId: '',
          message: data['message'],
          timestamp: DateTime.parse(data['timestamp']),
        );
        _messageReceivedController.add(message);
      } catch (e) {
        print('Error parsing message: $e');
      }
    });

    // Agent assigned
    _socket!.on('customer:agent-assigned', (data) {
      _agentAssignedController.add(data);
    });

    // Customer queued
    _socket!.on('customer:queued', (data) {
      _queuedController.add(data);
    });

    // Typing indicators
    _socket!.on('user:typing', (data) {
      _typingController.add({'typing': true, ...data});
    });

    _socket!.on('user:stopped-typing', (data) {
      _typingController.add({'typing': false, ...data});
    });

    // Chat history
    _socket!.on('customer:chat-history', (data) {
      // Handle chat history
      print('Received chat history: ${data.length} messages');
    });

    // Error handling
    _socket!.on('error', (data) {
      print('Socket error: $data');
    });

    _socket!.onDisconnect((_) {
      print('🔌 Disconnected from chat service');
    });
  }

  /// Disconnect from chat service
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _currentRoomId = null;
  }

  /// Clean up resources
  void dispose() {
    disconnect();
    _messageReceivedController.close();
    _typingController.close();
    _agentAssignedController.close();
    _queuedController.close();
  }
}