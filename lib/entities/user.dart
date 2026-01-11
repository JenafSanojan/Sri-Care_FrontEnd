import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a user in the application.
class User {
  final String? uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? mobileNumber;
  final String? token;
  final Timestamp? createdAt;
  final Timestamp? lastSignInAt;
  final bool? isProfileComplete;
  final bool isActive;
  final double voice;
  final double walletBalance;

  User({
    this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.mobileNumber,
    this.token,
    this.createdAt,
    this.lastSignInAt,
    this.isProfileComplete,
    this.isActive = true,
    // Default to 0.0 if not provided
    this.voice = 0.0,
    this.walletBalance = 0.0,
  });

  /// Converts a User instance to a JSON-compatible Map.
  Map<String, dynamic> toJson() {
    return {
      '_id': uid,
      'email': email,
      'name': displayName,
      'photoURL': photoURL,
      'mobileNumber': mobileNumber,
      'token': token,
      'createdAt': createdAt?.toDate().toIso8601String(),
      'lastSignInAt': lastSignInAt?.toDate().toIso8601String(),
      'isProfileComplete': isProfileComplete,
      'isActive': isActive,
      'voice': voice ?? 0.0,
      'walletBalance': walletBalance ?? 0.0,
    };
  }

  /// Creates a User instance from a Json.
  factory User.fromJson(Map<String, dynamic> map) {
    if (map['_id'] == null) {
      throw ArgumentError("The 'uid' field is required in the map for User.fromMap");
    }
    return User(
      uid: map['_id'] as String,
      email: map['email'] as String,
      displayName: map['name'] as String?,
      photoURL: map['photoURL'] as String?,
      mobileNumber: map['mobileNumber'] as String?,
      token: map['token'] as String?,
      createdAt: map['createdAt'] is Timestamp
          ? map['createdAt'] as Timestamp?
          : (map['createdAt'] != null ? Timestamp.fromDate(DateTime.parse(map['createdAt'] as String)) : null),
      lastSignInAt: map['lastSignInAt'] is Timestamp
          ? map['lastSignInAt'] as Timestamp?
          : (map['lastSignInAt'] != null ? Timestamp.fromDate(DateTime.parse(map['lastSignInAt'] as String)) : null),
      isProfileComplete: map['isProfileComplete'] as bool?,
      isActive: map['isActive'] ?? true,
      // Handle nulls by defaulting to 0.0.
      // (map['key'] as num?) ensures it handles both int and double from JSON safeley.
      voice: map['voice'] != null ? (map['voice'] as num).toDouble() : 0.0,
      walletBalance: map['voice'] != null ? (map['walletBalance'] as num).toDouble() : 0.0,
    );
  }

  /// Creates a copy of the User with updated values.
  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? mobileNumber,
    String? token,
    Timestamp? createdAt,
    Timestamp? lastSignInAt,
    bool? isProfileComplete,
    bool? isActive,
    double? voice,
    double? walletBalance,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isActive: isActive ?? this.isActive,
      voice: voice ?? this.voice,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, voice: $voice, walletBalance: $walletBalance)';
  }
}