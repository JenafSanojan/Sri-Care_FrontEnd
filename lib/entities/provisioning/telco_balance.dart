class TelcoBalance {
  final String status;
  final String phone;
  final double balance;

  TelcoBalance({
    required this.status,
    required this.phone,
    required this.balance,
  });

  factory TelcoBalance.fromJson(Map<String, dynamic> json) {
    return TelcoBalance(
      status: json['status'],
      phone: json['phone'],
      balance: (json['balance'] as num).toDouble(),
    );
  }

  bool get isSuccess => status == 'SUCCESS';
}