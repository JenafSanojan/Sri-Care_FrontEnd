class ProvisioningResponse {
  final String status;
  final String message;
  final double? currentBalance;

  ProvisioningResponse({
    required this.status,
    required this.message,
    this.currentBalance,
  });

  factory ProvisioningResponse.fromJson(Map<String, dynamic> json) {
    return ProvisioningResponse(
      status: json['status'],
      message: json['message'] ?? '',
      currentBalance: json['currentBalance'] != null
          ? (json['currentBalance'] as num).toDouble()
          : null,
    );
  }

  bool get isSuccess => status == 'SUCCESS';
  bool get isFailed => status == 'FAILED';
}