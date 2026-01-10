class UserSimProfile {
  final String phone;
  final double balance;
  final bool roaming;
  final List<String> activePackages;

  UserSimProfile({
    required this.phone,
    required this.balance,
    this.roaming = false,
    this.activePackages = const [],
  });

  factory UserSimProfile.fromJson(Map<String, dynamic> json) {
    return UserSimProfile(
      phone: json['phone'],
      balance: (json['balance'] as num).toDouble(),
      roaming: json['roaming'] ?? false,
      activePackages: json['activePackages'] != null
          ? List<String>.from(json['activePackages'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'balance': balance,
      'roaming': roaming,
      'activePackages': activePackages,
    };
  }

  // Display helpers
  String get balanceDisplay => 'LKR ${balance.toStringAsFixed(2)}';
  String get roamingStatus => roaming ? 'Enabled ✈️' : 'Disabled';
  bool get hasActivePackages => activePackages.isNotEmpty;
}