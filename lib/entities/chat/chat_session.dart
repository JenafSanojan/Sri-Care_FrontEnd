class ChatSession {
  final String id;
  final String roomId;
  final String customerId;
  final String customerName;
  final String? agentId;
  final String? agentName;
  final String status;
  final DateTime createdAt;
  final DateTime lastActivityAt;
  final DateTime? closedAt;
  final String? closeReason;

  ChatSession({
    required this.id,
    required this.roomId,
    required this.customerId,
    required this.customerName,
    this.agentId,
    this.agentName,
    required this.status,
    required this.createdAt,
    required this.lastActivityAt,
    this.closedAt,
    this.closeReason,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['_id'] ?? json['id'],
      roomId: json['roomId'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      agentId: json['agentId'],
      agentName: json['agentName'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      lastActivityAt: DateTime.parse(json['lastActivityAt']),
      closedAt: json['closedAt'] != null ? DateTime.parse(json['closedAt']) : null,
      closeReason: json['closeReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'roomId': roomId,
      'customerId': customerId,
      'customerName': customerName,
      'agentId': agentId,
      'agentName': agentName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'lastActivityAt': lastActivityAt.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
      'closeReason': closeReason,
    };
  }
}