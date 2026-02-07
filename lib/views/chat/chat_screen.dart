import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/entities/chat/chat_message.dart';
import 'package:sri_tel_flutter_web_mob/services/chat/chat_service.dart';
import 'package:sri_tel_flutter_web_mob/services/chat/chat_socket_service.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';

import '../../Global/global_configs.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Services
  final ChatService _apiService = ChatService();
  final ChatSocketService _socketService = ChatSocketService();

  // State
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isAgentTyping = false;
  String? _assignedAgentName;
  String _connectionStatus = "Connecting...";

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _socketService.dispose(); // Disconnect socket
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    final user = GlobalAuthConfigs.instance.user;
    final String customerId = user.uid ?? "guest";
    final String customerName = user.displayName ?? "Guest User";
    final String roomId = 'room_$customerId';

    // 1. Fetch History via REST
    final history = await _apiService.getChatHistory(roomId);
    if (mounted) {
      setState(() {
        if (history != null) {
          _messages = history;
        }
        _isLoading = false;
      });
      _scrollToBottom();
    }

    // 2. Connect Socket
    await _socketService.connectAsCustomer(
      customerId: customerId,
      customerName: customerName,
    );

    setState(() => _connectionStatus = "Our agents are busy right now. Come back after a week.");//"Connected");

    // 3. Setup Listeners
    _socketService.onMessageReceived.listen((message) {
      setState(() {
        _messages.add(message);
        _isAgentTyping = false; // Stop typing indicator if message received
      });
      _scrollToBottom();
    });

    _socketService.onTyping.listen((data) {
      setState(() {
        _isAgentTyping = data['typing'] ?? false;
      });
    });

    _socketService.onAgentAssigned.listen((data) {
      setState(() {
        _assignedAgentName = data['agentName'];
        _connectionStatus = "Connected with $_assignedAgentName";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are now connected with ${_assignedAgentName ?? 'an agent'}"), backgroundColor: darkGreen),
      );
    });

    _socketService.onQueued.listen((data) {
      final position = data['queuePosition'];
      setState(() => _connectionStatus = "Waiting for agent (Queue: $position)");
    });
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Optimistically add message to UI
    final user = GlobalAuthConfigs.instance.user;
    final tempMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
      roomId: _socketService.currentRoomId ?? 'room_${user.uid}',
      senderId: user.uid ?? 'guest',
      senderRole: 'customer',
      recipientId: 'agent', // Generic recipient until assigned
      message: text,
      timestamp: DateTime.now(),
      deliveryStatus: 'sending',
    );

    setState(() {
      _messages.add(tempMessage);
      _textController.clear();
    });
    _scrollToBottom();

    // Send via Socket
    final success = await _socketService.sendMessage(
      message: text,
      recipientId: 'agent',
    );

    if (!success) {
      // Handle failure (e.g., show error icon next to message)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to send message")));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Small delay to ensure list rendered
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildChatInterface(isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _buildChatInterface(isWeb: true),
        ),
      ),
    );
  }

  Widget _buildChatInterface({required bool isWeb}) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: orangeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sri-Care Support", style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(_connectionStatus, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: Column(
        children: [
          // --- MESSAGES LIST ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: orangeColor))
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.senderRole == 'customer';
                return _buildMessageBubble(msg, isMe);
              },
            ),
          ),

          // --- TYPING INDICATOR ---
          if (_isAgentTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${_assignedAgentName ?? 'Agent'} is typing...",
                  style: const TextStyle(color: greyColor, fontStyle: FontStyle.italic, fontSize: 12),
                ),
              ),
            ),

          // --- INPUT AREA ---
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: (text) {
                      if (text.isNotEmpty) _socketService.startTyping();
                      // Logic to stop typing could be added with a debounce timer
                    },
                    decoration: InputDecoration(
                      hintText: "All our agents are busy, come back later...",//"Type your message...",
                      filled: true,
                      fillColor: lightYellow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: orangeColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? orangeColor : white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.message,
              style: TextStyle(
                color: isMe ? white : textColorOne,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                color: isMe ? Colors.white70 : greyColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}