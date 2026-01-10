import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sri_tel_flutter_web_mob/entities/ui_entities.dart';

const parentCatIds = ['ProductCat1', 'ProductCat2', 'ProductCat3'];

final parentCatDropdownItems = [
  CustomDropdownItem(value: 'ProductCat1', label: 'Category Type 1'),
  CustomDropdownItem(value: 'ProductCat2', label: 'Category Type 2'),
  CustomDropdownItem(value: 'ProductCat3', label: 'Category Type 3'),
];

class Category {
  final String? categoryId;
  String? companyId;
  String categoryCode;
  String categoryName;
  String? parentCategoryId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    this.categoryId,
    this.companyId,
    required this.categoryCode,
    required this.categoryName,
    this.parentCategoryId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Category(
      categoryId: snapshot.id,
      companyId: data?['companyId'] as String?,
      categoryCode: data?['categoryCode'] ?? '',
      categoryName: data?['categoryName'] ?? '',
      parentCategoryId: data?['parentCategoryId'] as String?,
      isActive: data?['isActive'] ?? true,
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data?['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Category.fromMap(Map<String, dynamic> data, {String? id}) {
    return Category(
      categoryId: id,
      companyId: data['companyId'] as String?,
      categoryCode: data['categoryCode'] ?? '',
      categoryName: data['categoryName'] ?? '',
      parentCategoryId: data['parentCategoryId'] as String?,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (companyId != null) 'companyId': companyId,
      'categoryCode': categoryCode,
      'categoryName': categoryName,
      if (parentCategoryId != null) 'parentCategoryId': parentCategoryId,
      'isActive': isActive,
      'createdAt': createdAt == null && categoryId == null
          ? FieldValue.serverTimestamp()
          : (createdAt != null ? Timestamp.fromDate(createdAt!) : null),
      'updatedAt': FieldValue.serverTimestamp(),
    }..removeWhere((key, value) =>
        value == null && key != 'createdAt' && key != 'updatedAt');
  }

  Category copyWith({
    String? categoryId,
    String? companyId,
    String? categoryCode,
    String? categoryName,
    String? parentCategoryId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      companyId: companyId ?? this.companyId,
      categoryCode: categoryCode ?? this.categoryCode,
      categoryName: categoryName ?? this.categoryName,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // static List<String> toNameCodeList(List<Category>? categoryList) {
  //   if (categoryList == null || categoryList.isEmpty) {
  //     return [];
  //   }
  //   return categoryList.map((category) => "${category.categoryName} (${category.categoryCode})").toList();
  // }
  static List<CustomDropdownItem> toDropdownList(List<Category>? categoryList) {
    if (categoryList == null || categoryList.isEmpty) {
      return [];
    }
    return categoryList
    .where((category) => category.categoryId != null)
        .map((category) => CustomDropdownItem(
            value: category.categoryId!,
            label: "${category.categoryName} (${category.categoryCode})"))
        .toList();
  }
}
