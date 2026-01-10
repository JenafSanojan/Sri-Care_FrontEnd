import 'dart:ui';


class TelcoPackage {
  final String name;
  final double cost;
  final String description;
  final int validity; // in days
  final String type; // 'DATA', 'VOICE', 'SMS', 'COMBO'
  final Color demoColor; // should be changed to image

  TelcoPackage({
    required this.name,
    required this.cost,
    required this.description,
    this.validity = 30,
    this.type = 'DATA',
    this.demoColor = const Color(0xFFCCCCCC),
  });

  factory TelcoPackage.fromJson(Map<String, dynamic> json) {
    return TelcoPackage(
      name: json['name'],
      cost: (json['cost'] as num).toDouble(),
      description: json['description'] ?? '',
      validity: json['validity'] ?? 30,
      type: json['type'] ?? 'DATA',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cost': cost,
      'description': description,
      'validity': validity,
      'type': type,
    };
  }

  // Display helpers
  String get costDisplay => 'LKR ${cost.toStringAsFixed(2)}';
  String get validityDisplay => '$validity days';
  String get typeIcon {
    switch (type) {
      case 'DATA':
        return '📱';
      case 'VOICE':
        return '📞';
      case 'SMS':
        return '💬';
      case 'COMBO':
        return '📦';
      default:
        return '🎁';
    }
  }
}