class ChatMessage {
  final String id;
  final String roomId;
  final String senderId;
  final String senderRole;
  final String recipientId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String deliveryStatus;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderRole,
    required this.recipientId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.deliveryStatus = 'pending',
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? json['id'],
      roomId: json['roomId'],
      senderId: json['senderId'],
      senderRole: json['senderRole'],
      recipientId: json['recipientId'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      deliveryStatus: json['deliveryStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'roomId': roomId,
      'senderId': senderId,
      'senderRole': senderRole,
      'recipientId': recipientId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'deliveryStatus': deliveryStatus,
    };
  }
}