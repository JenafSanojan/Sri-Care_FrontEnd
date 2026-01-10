class NotificationLog {
  final String id;
  final String userId;
  final String channel;
  final String recipient;
  final String message;
  final String status;
  final String? error;
  final DateTime? sentAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationLog({
    required this.id,
    required this.userId,
    required this.channel,
    required this.recipient,
    required this.message,
    required this.status,
    this.error,
    this.sentAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationLog.fromJson(Map<String, dynamic> json) {
    return NotificationLog(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      channel: json['channel'],
      recipient: json['recipient'],
      message: json['message'],
      status: json['status'],
      error: json['error'],
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'channel': channel,
      'recipient': recipient,
      'message': message,
      'status': status,
      'error': error,
      'sentAt': sentAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Channel type helpers
  bool get isEmail => channel == 'EMAIL';
  bool get isSMS => channel == 'SMS';

  // Status helpers
  bool get isSent => status == 'SENT';
  bool get isFailed => status == 'FAILED';
  bool get isQueued => status == 'QUEUED';

  // Display helpers
  String get channelIcon => isEmail ? '📧' : '📱';
  String get statusColor => isSent ? 'green' : isFailed ? 'red' : 'orange';
}