import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/entities/chat/chat_message.dart';
import 'package:sri_tel_flutter_web_mob/services/chat/chat_service.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';

import '../../Global/global_configs.dart';
import 'chat_screen.dart';
import 'package:get/get.dart';

class SupportListScreen extends StatefulWidget {
  final bool dontShowBackButton;

  const SupportListScreen({super.key, this.dontShowBackButton = false});

  @override
  State<SupportListScreen> createState() => _SupportListScreenState();
}

class _SupportListScreenState extends State<SupportListScreen> {
  final ChatService _chatService = ChatService();
  ChatMessage? _lastMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLastConversation();
  }

  // Check if we have history for the default customer room
  Future<void> _fetchLastConversation() async {
    try {
      final user = GlobalAuthData.instance.user;
      if (user.uid == null) return;

      // Based on your socket logic, customer room is 'room_UID'
      final String roomId = 'room_${user.uid}';
      final history = await _chatService.getChatHistory(roomId);

      if (history != null && history.isNotEmpty) {
        setState(() {
          _lastMessage = history.last; // Get the most recent message
        });
      }
    } catch (e) {
      print("Error fetching summary: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(context, isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _buildContent(context, isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isWeb}) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: orangeColor,
        elevation: 0,
        leading: widget.dontShowBackButton
            ? SizedBox()
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: white),
                onPressed: Get.back),
        title: const Text("Help & Support",
            style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: orangeColor,
        onPressed: () {
          // Navigate to the Chat Room
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ChatScreen()))
              .then((_) => _fetchLastConversation()); // Refresh on return
        },
        icon: const Icon(Icons.support_agent, color: white),
        label: const Text("Chat with Agent",
            style: TextStyle(color: white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // --- 1. FAQ BANNER ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: orangeColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.help_outline, size: 40, color: orangeColor),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Have a question?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColorOne)),
                      SizedBox(height: 5),
                      Text("Check our FAQ for instant answers.",
                          style: TextStyle(fontSize: 12, color: greyColor)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Recent Activity",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: textColorOne),
          ),
          const SizedBox(height: 15),

          // --- 2. ACTIVE CONVERSATION CARD ---
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: orangeColor))
          else if (_lastMessage != null)
            _buildConversationCard(context)
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text("No recent support conversations.",
                    style: TextStyle(color: greyColor)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ChatScreen()))
            .then((_) => _fetchLastConversation());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: orangeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat, color: orangeColor),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Customer Support",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColorOne),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${_lastMessage!.senderRole == 'agent' ? 'Agent: ' : 'You: '}${_lastMessage!.message}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: greyColor, fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(_lastMessage!.timestamp),
                  style: const TextStyle(color: greyColor, fontSize: 11),
                ),
                if (_lastMessage!.senderRole == 'agent' &&
                    !_lastMessage!.isRead)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}
