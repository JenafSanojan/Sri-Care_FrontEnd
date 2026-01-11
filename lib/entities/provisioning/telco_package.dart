class TelcoPackage {
  final String id;
  final String name;
  final String type;
  final double cost;
  final String description;
  final int validity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TelcoPackage({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
    required this.description,
    required this.validity,
    this.createdAt,
    this.updatedAt,
  });

  factory TelcoPackage.fromJson(Map<String, dynamic> json) {
    return TelcoPackage(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      type: json['type'],
      cost: (json['cost'] as num).toDouble(),
      description: json['description'],
      validity: json['validity'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'cost': cost,
      'description': description,
      'validity': validity,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Type helpers
  bool get isData => type == 'data';
  bool get isVoice => type == 'voice';
  bool get isVAS => type == 'VAS';

  // Display helpers
  String get costDisplay => 'LKR ${cost.toStringAsFixed(2)}';
  String get validityDisplay => '$validity ${validity == 1 ? 'day' : 'days'}';
  String get typeDisplay {
    switch (type) {
      case 'data':
        return 'Data Package';
      case 'voice':
        return 'Voice Package';
      case 'VAS':
        return 'Value Added Service';
      default:
        return type;
    }
  }

  String get typeIcon {
    switch (type) {
      case 'data':
        return '📱';
      case 'voice':
        return '📞';
      case 'VAS':
        return '⭐';
      default:
        return '📦';
    }
  }
}