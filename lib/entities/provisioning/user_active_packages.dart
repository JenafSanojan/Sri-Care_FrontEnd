import 'active_package.dart';

class UserActivePackages {
  final List<ActivePackage> data;
  final List<ActivePackage> voice;
  final List<ActivePackage> services;

  UserActivePackages({
    this.data = const [],
    this.voice = const [],
    this.services = const [],
  });

  factory UserActivePackages.fromJson(Map<String, dynamic> json) {
    return UserActivePackages(
      data: json['data'] != null
          ? (json['data'] as List).map((e) => ActivePackage.fromJson(e)).toList()
          : [],
      voice: json['voice'] != null
          ? (json['voice'] as List).map((e) => ActivePackage.fromJson(e)).toList()
          : [],
      services: json['services'] != null
          ? (json['services'] as List).map((e) => ActivePackage.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'voice': voice.map((e) => e.toJson()).toList(),
      'services': services.map((e) => e.toJson()).toList(),
    };
  }

  // Helpers
  int get totalActivePackages => data.length + voice.length + services.length;
  bool get hasActivePackages => totalActivePackages > 0;

  List<ActivePackage> get allPackages => [...data, ...voice, ...services];
  List<ActivePackage> get activePackages => allPackages.where((p) => p.isActive).toList();
  List<ActivePackage> get expiredPackages => allPackages.where((p) => p.isExpired).toList();
}