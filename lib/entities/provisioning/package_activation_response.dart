class PackageActivationResponse {
  final String status;
  final String message;
  final PackageInfo? package;
  final WalletInfo? wallet;
  final DateTime? expiresAt;

  PackageActivationResponse({
    required this.status,
    required this.message,
    this.package,
    this.wallet,
    this.expiresAt,
  });

  factory PackageActivationResponse.fromJson(Map<String, dynamic> json) {
    return PackageActivationResponse(
      status: json['status'],
      message: json['message'],
      package: json['package'] != null ? PackageInfo.fromJson(json['package']) : null,
      wallet: json['wallet'] != null ? WalletInfo.fromJson(json['wallet']) : null,
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
    );
  }

  bool get isSuccess => status == 'SUCCESS';
  bool get isFailed => status == 'FAILED';
}

class PackageInfo {
  final String id;
  final String name;
  final String type;
  final double cost;

  PackageInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
  });

  factory PackageInfo.fromJson(Map<String, dynamic> json) {
    return PackageInfo(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      cost: (json['cost'] as num).toDouble(),
    );
  }
}

class WalletInfo {
  final double previousBalance;
  final double deducted;
  final double newBalance;

  WalletInfo({
    required this.previousBalance,
    required this.deducted,
    required this.newBalance,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      previousBalance: (json['previousBalance'] as num).toDouble(),
      deducted: (json['deducted'] as num).toDouble(),
      newBalance: (json['newBalance'] as num).toDouble(),
    );
  }
}