import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  final String? id;
  final String roleCode;
  final String roleName;
  final String? description;
  final int? hierarchyLevel;
  final List<String>? permissions; // New field for permissions
  final bool isActive;
  final Timestamp? createdAt;
  Timestamp? updatedAt = Timestamp.now();

  Role({
    this.id,
    required this.roleCode,
    required this.roleName,
    this.description,
    this.hierarchyLevel,
    this.permissions,
    this.isActive = true,
    this.createdAt,
    this.updatedAt
  });

  factory Role.fromFirestore(DocumentSnapshot<Map<String,dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return Role(
      id: snapshot.id,
      roleCode: data?['roleCode'] ?? '',
      roleName: data?['roleName'] ?? '',
      description: data?['description'] as String?,
      hierarchyLevel: data?['hierarchyLevel'] as int?,
      permissions: data?['permissions'] != null ? List<String>.from(data?['permissions']) : null, // Read permissions
      isActive: data?['isActive'] ?? true,
      createdAt: data?['createdAt'] as Timestamp?,
      updatedAt: data?['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roleCode': roleCode,
      'roleName': roleName,
      if (description != null) 'description': description,
      if (hierarchyLevel != null) 'hierarchyLevel': hierarchyLevel,
      if (permissions != null) 'permissions': permissions, // Save permissions
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Role copyWith({
    String? id,
    String? roleCode,
    String? roleName,
    String? description,
    int? hierarchyLevel,
    List<String>? permissions, // Add to copyWith
    bool? isActive,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Role(
      id: id ?? this.id,
      roleCode: roleCode ?? this.roleCode,
      roleName: roleName ?? this.roleName,
      description: description ?? this.description,
      hierarchyLevel: hierarchyLevel ?? this.hierarchyLevel,
      permissions: permissions ?? this.permissions, // Handle in copyWith
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Role(id: $id, roleCode: $roleCode, roleName: $roleName, permissions: ${permissions?.length ?? 0}, isActive: $isActive, hierarchyLevel: $hierarchyLevel)';
  }
}