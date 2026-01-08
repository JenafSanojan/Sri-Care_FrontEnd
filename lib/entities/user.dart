import 'package:cloud_firestore/cloud_firestore.dart';

// Assuming Role class is in 'role_model.dart' or similar
// import 'role_model.dart';

/// Represents a user in the application.
class User {
  /// Unique identifier for the user (Typically the Firebase Auth UID).
  final String? uid;
  final String email;
  final String? password;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final String? roleId;
  final Timestamp? createdAt;
  final Timestamp? lastSignInAt;
  final bool? isProfileComplete; // tells if the user has completed their profile (email, phone) verification
  final bool isActive;

  User({
    this.uid,
    required this.email,
    this.password,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.roleId,
    this.createdAt,
    this.lastSignInAt,
    this.isProfileComplete,
    this.isActive = true,
  });

  /// Creates a User instance from a Firebase Firestore document snapshot.
  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return User(
      uid: snapshot.id,
      email: data?['email'] as String,
      password: data?['password'] as String?,
      displayName: data?['displayName'] as String?,
      photoURL: data?['photoURL'] as String?,
      phoneNumber: data?['phoneNumber'] as String?,
      roleId: data?['roleId'] as String?, // << CHANGED: Read the role ID
      createdAt: data?['createdAt'] as Timestamp?,
      lastSignInAt: data?['lastSignInAt'] as Timestamp?,
      isProfileComplete: data?['isProfileComplete'] as bool?,
      isActive: data?['isActive'] ?? true,
    );
  }

  /// Converts a User instance to a Map suitable for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'password': password, // Note: Storing passwords in Firestore is not recommended // to-do: Hash passwords before storing
      if (displayName != null) 'displayName': displayName,
      if (photoURL != null) 'photoURL': photoURL,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (roleId != null) 'roleId': roleId, // << CHANGED: Save the role ID
      if (createdAt != null) 'createdAt': createdAt else 'createdAt': FieldValue.serverTimestamp(),
      if (lastSignInAt != null) 'lastSignInAt': lastSignInAt,
      if (isProfileComplete != null) 'isProfileComplete': isProfileComplete,
      'isActive': isActive,
    };
  }

  /// Converts a User instance to a JSON-compatible Map (for APIs, etc).
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'password': password, // Note: Storing passwords in JSON is not recommended
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'roleId': roleId,
      'createdAt': createdAt?.toDate().toIso8601String(),
      'lastSignInAt': lastSignInAt?.toDate().toIso8601String(),
      'isProfileComplete': isProfileComplete,
      'isActive': isActive,
    };
  }

  /// Creates a User instance from a generic Map.
  factory User.fromMap(Map<String, dynamic> map) {
    if (map['uid'] == null) {
      throw ArgumentError("The 'uid' field is required in the map for User.fromMap");
    }
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      password: map['password'] as String?, // Note: Storing passwords in Firestore is not recommended // to-do: Hash passwords before storing
      displayName: map['displayName'] as String?,
      photoURL: map['photoURL'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      roleId: map['roleId'] as String?, // << CHANGED
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp? : (map['createdAt'] != null ? Timestamp.fromDate(DateTime.parse(map['createdAt'] as String)) : null),
      lastSignInAt: map['lastSignInAt'] is Timestamp ? map['lastSignInAt'] as Timestamp? : (map['lastSignInAt'] != null ? Timestamp.fromDate(DateTime.parse(map['lastSignInAt'] as String)) : null),
      isProfileComplete: map['isProfileComplete'] as bool?,
      isActive: map['isActive'] ?? true,
    );
  }

  /// Creates a User instance directly from a Firebase Auth `User` object.
  factory User.fromFirebaseAuth(User firebaseUser, {String? defaultRoleId}) {
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '', // Email is required, so default to empty string if null
      password: null, // Password is not available from Firebase Auth
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      phoneNumber: firebaseUser.phoneNumber,
      roleId: defaultRoleId, // Assign a default role ID on creation if needed
      // createdAt: firebaseUser.metadata.creationTime != null
      //     ? Timestamp.fromDate(firebaseUser.metadata.creationTime!)
      //     : null,
      // lastSignInAt: firebaseUser.metadata.lastSignInTime != null
      //     ? Timestamp.fromDate(firebaseUser.metadata.lastSignInTime!)
      //     : null,
      isProfileComplete: false, // Default or fetch
      isActive: true,
    );
  }

  /// Creates a copy of the User with updated values.
  User copyWith({
    String? uid,
    String? email,
    String? password,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    String? roleId, // << CHANGED
    Timestamp? createdAt,
    Timestamp? lastSignInAt,
    bool? isProfileComplete,
    bool? isActive,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password, // Note: Storing passwords in Firestore is not recommended // to-do: Hash passwords before storing
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      roleId: roleId ?? this.roleId, // << CHANGED
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, displayName: $displayName, roleId: $roleId, isActive: $isActive, isProfileComplete: $isProfileComplete)';
  }
}