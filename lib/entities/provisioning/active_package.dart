class ActivePackage {
  final String packageId;
  final String name;
  final DateTime activatedAt;
  final DateTime expiresAt;

  ActivePackage({
    required this.packageId,
    required this.name,
    required this.activatedAt,
    required this.expiresAt,
  });

  factory ActivePackage.fromJson(Map<String, dynamic> json) {
    return ActivePackage(
      packageId: json['packageId'],
      name: json['name'],
      activatedAt: DateTime.parse(json['activatedAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'name': name,
      'activatedAt': activatedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  // Status helpers
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isActive => !isExpired;

  int get daysRemaining {
    if (isExpired) return 0;
    return expiresAt.difference(DateTime.now()).inDays;
  }

  String get daysRemainingDisplay {
    final days = daysRemaining;
    if (days == 0) return 'Expires today';
    if (days == 1) return '1 day left';
    return '$days days left';
  }

  String get statusDisplay => isExpired ? 'Expired' : 'Active';
}