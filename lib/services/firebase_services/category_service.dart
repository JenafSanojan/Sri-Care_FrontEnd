import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sri_tel_flutter_web_mob/entities/category.dart'; // Your Category entity path
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart'; // Assuming GlobalAuthData is here
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart'; // For CommonLoaders
// Assuming parentCatIds is defined in your category.dart or accessible here
// If not, you might need to import it or define it within this service if relevant.
// import 'package:sri_tel_flutter_web_mob/entities/category.dart' show parentCatIds;

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Category> _categoriesCollection;
  static const String _collectionName =
      'categories'; // Collection name for categories

  CategoryService() {
    _categoriesCollection =
        _firestore.collection(_collectionName).withConverter<Category>(
              fromFirestore: Category.fromFirestore,
              toFirestore: (Category category, _) => category.toFirestore(),
            );
  }

  String _getCompanyIdOrFail({String? providedCompanyId}) {
    final companyId = null;
    if (companyId == null || companyId.isEmpty) {
      CommonLoaders.errorSnackBar(
          title: "Operation Failed",
          message:
              "Company information is missing. Please ensure you are logged in correctly. (Error Code: CATCOMID_FAIL)");
      throw Exception(
          'Company ID is not available. Ensure user is logged in and associated with a company.');
    }
    return companyId;
  }

  /// Checks if a category code is already taken for the current company.
  Future<bool> isCategoryCodeTaken(String categoryCode,
      {String? excludeCategoryId, String? parentId}) async {
    if (categoryCode.isEmpty) {
      CommonLoaders.errorSnackBar(
          title: "Category code cannot be empty for 'isTaken' check.");
      return false; // Or true, depending on how you want to handle empty codes
    }
    try {
      final companyId = _getCompanyIdOrFail();
      Query<Category> query = _categoriesCollection
          .where('companyId', isEqualTo: companyId)
          .where('categoryCode', isEqualTo: categoryCode);
      if(parentId != null && parentId.isNotEmpty) {
        query = query.where('parentCategoryId', isEqualTo: parentId);
      }
      QuerySnapshot<Category> querySnap = await query.limit(1).get();
      if (querySnap.docs.isEmpty) {
        return false; // Code not found for this company, so it's not taken
      }
      // If we are excluding an ID (e.g., during an update),
      // and the found category is that excluded ID, then the code is not "taken" by another category.
      if (excludeCategoryId != null &&
          querySnap.docs.first.id == excludeCategoryId) {
        return false;
      }
      return true; // A category with this code (and not the excluded one) exists
    } catch (e) {
      print('Error checking if category code "$categoryCode" is taken: $e');
      // Consider if returning true on error is the safest default (prevents duplicates if check fails)
      // Or if you should rethrow or return a specific error state.
      CommonLoaders.errorSnackBar(
          title: "Validation Error",
          message: "Could not verify category code uniqueness.");
      return true; // Default to taken on error to be safe
    }
  }

  /// Create - done
  Future<String?> createCategory(Category category) async {
    category.companyId =
        _getCompanyIdOrFail(providedCompanyId: category.companyId);
    try {
      bool isCodeTaken = await isCategoryCodeTaken(category.categoryCode, parentId: category.parentCategoryId);
      if (isCodeTaken) {
        CommonLoaders.errorSnackBar(
            title: "Duplicate Code",
            message:
                'Category code "${category.categoryCode}" is already in use.');
        return null; // Indicate failure due to duplicate code
      }

      DocumentReference<Category> docRef =
          await _categoriesCollection.add(category);
      return docRef.id;
    } catch (e) {
      print('Error creating product category: $e');
      CommonLoaders.errorSnackBar(
          title:
              "Something went wrong. Check your connection and try again (Error Code: EXC_CRCAT).");
      return null;
    }
  }

  /// Retrieves a specific category by its ID.
  Future<Category?> getCategoryById(String categoryId) async {
    if (categoryId.isEmpty) {
      CommonLoaders.warningSnackBar(
          title: "Input Error", message: "Category ID cannot be empty.");
      return null;
    }
    try {
      final companyId = _getCompanyIdOrFail();
      DocumentSnapshot<Category> docSnap =
          await _categoriesCollection.doc(categoryId).get();

      if (docSnap.exists && docSnap.data()?.companyId == companyId) {
        return docSnap.data();
      } else {
        // CommonLoaders.warningSnackBar(title: "Not Found", message: "Category not found or access denied.");
        return null; // Not found or doesn't belong to the company
      }
    } catch (e) {
      print('Error getting product category by ID "$categoryId": $e');
      CommonLoaders.errorSnackBar(
          title: "Fetch Error",
          message: "Could not retrieve category details.");
      return null;
    }
  }

  /// Retrieves a specific category by its code forthe current company.
  Future<Category?> getCategoryByCode(String categoryCode) async {
    if (categoryCode.isEmpty) {
      CommonLoaders.warningSnackBar(
          title: "Input Error", message: "Category code cannot be empty.");
      return null;
    }
    try {
      final companyId = _getCompanyIdOrFail();
      QuerySnapshot<Category> querySnap = await _categoriesCollection
          .where('companyId', isEqualTo: companyId)
          .where('categoryCode', isEqualTo: categoryCode)
          .limit(1)
          .get();

      if (querySnap.docs.isNotEmpty) {
        return querySnap.docs.first.data();
      }
      return null;
    } catch (e) {
      print('Error getting category by code "$categoryCode": $e');
      CommonLoaders.errorSnackBar(
          title: "Fetch Error",
          message: "Could not retrieve category by code.");
      return null;
    }
  }

  /// Provides a stream for a single category by its ID.
  Stream<Category?> getCategoryStreamById(String categoryId) {
    if (categoryId.isEmpty) {
      // Optionally show a snackbar or log, but returning Stream.value(null) is often sufficient
      // CommonLoaders.warningSnackBar(title: "Input Error", message: "Category ID cannot be empty for stream.");
      return Stream.value(null);
    }
    try {
      // It's important to get companyId here if your stream's map function depends on it
      // for filtering, to avoid issues if GlobalAuthData.instance.companyId changes
      // during the stream's lifetime without the stream being re-initialized.
      // However, for a single document stream, the main check is on the document's content.
      // The _getCompanyIdOrFail() call here is more for consistency or if there was
      // a pre-flight check needed before even attempting to listen.
      // String companyId = _getCompanyIdOrFail(); // Can be removed if not strictly needed before snapshot listener

      return _categoriesCollection.doc(categoryId).snapshots().map((snapshot) {
        // Perform companyId check within the map to ensure data integrity for each emission
        final String currentCompanyIdForCheck = _getCompanyIdOrFail();
        if (snapshot.exists &&
            snapshot.data()?.companyId == currentCompanyIdForCheck) {
          return snapshot.data();
        }
        return null; // Document doesn't exist or doesn't belong to the company
      }).handleError((error, stackTrace) {
        print(
            "Error in product category stream for ID $categoryId: $error\n$stackTrace");
        // Avoid showing snackbar directly in stream error handlers if this stream
        // is used in UI that might rebuild frequently, could lead to snackbar spam.
        // Logging is usually safer here. UI can handle showing user-facing errors.
        return null; // Emit null or an error state object on error
      });
    } catch (e, stackTrace) {
      // Catch synchronous errors during stream setup
      print(
          'Synchronous error setting up category stream by ID $categoryId:$e\n$stackTrace');
      CommonLoaders.errorSnackBar(
          title: "Stream Setup Error",
          message:
              "Failed to initialize category stream. (Code: CATSTRM_ID_INIT)");
      return Stream.value(null); // Return an empty stream or stream with error
    }
  }

  /// Retrieves all categories for the current company, with optional filtering and ordering.
  /// Note: For multiple orderBy clauses or complex queries, ensure Firestore indexes are set up.
  Stream<List<Category>> getAllCategoriesStream({
    bool activeOnly = true,
    String orderByField = 'categoryName', // Default sort field
    bool descending = false,
  }) {
    try {
      final companyId = _getCompanyIdOrFail();
      Query<Category> query =
          _categoriesCollection.where('companyId', isEqualTo: companyId);

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      // Basic ordering
      query = query.orderBy(orderByField, descending: descending);
      // If 'categoryName' is not the primary sort, and you also want to sort by it:
      // if (orderByField != 'categoryName') {
      //   query = query.orderBy('categoryName', descending: false); // Add secondary sort
      // }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      }).handleError((error, stackTrace) {
        print('Error streaming all product categories: $error\n$stackTrace');
        // CommonLoaders.errorSnackBar(title: "Stream Error", message: "Could not retrieve categories.");
        return <Category>[]; // Emit empty list on error
      });
    } catch (e, stackTrace) {
      print(
          'Synchronous error setting up all categories stream: $e\n$stackTrace');
      CommonLoaders.errorSnackBar(
          title: "Stream Setup Error",
          message:
              "Could not set up categories stream. (Code: CATSTRM_ALL_INIT)");
      return Stream.value([]);
    }
  }

  /// Retrieves all categories for the current company, with optional filtering and ordering.
  Future<List<Category>> getAllCategories({
    bool activeOnly = true,
    String orderByField = 'categoryName', // Default sort field
    bool descending = false,
  }) async {
    try {
      final companyId = _getCompanyIdOrFail();
      Query<Category> query =
          _categoriesCollection.where('companyId', isEqualTo: companyId);

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      // Basic ordering
      query = query.orderBy(orderByField, descending: descending);
      // If 'categoryName' is not the primary sort, and you also want to sort by it:
      // if (orderByField != 'categoryName') {
      //   query = query.orderBy('categoryName', descending: false); // Add secondary sort
      // }

      QuerySnapshot<Category> snapshot = await query.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      print(
          'Synchronous error setting up all categories stream: $e\n$stackTrace');
      CommonLoaders.errorSnackBar(
          title: "Stream Setup Error",
          message:
              "Could not set up categories stream. (Code: CATSTRM_ALL_INIT)");
      return [];
    }
  }

  /// Retrieves categories that are children of a specific parentCategoryId.
  Stream<List<Category>> getCategoriesStreamByParentId(
    String parentCategoryId, {
    bool activeOnly = true,
    String orderByField = 'categoryName',
    bool descending = false,
  }) {
    if (parentCategoryId.isEmpty) {
      // CommonLoaders.warningSnackBar(title: "Input Error", message: "Parent Category ID is required for stream.");
      return Stream.value([]);
    }
    // Optional: Validate against parentCatIds if that list is meant to be exhaustive for valid parent IDs
    // if (!parentCatIds.contains(parentCategoryId)) {
    //   CommonLoaders.warningSnackBar(title: "Invalid Parent", message: "The provided Parent Category ID is not valid.");
    //   return Stream.value([]);
    // }

    try {
      final companyId = _getCompanyIdOrFail();
      Query<Category> query = _categoriesCollection
          .where('companyId', isEqualTo: companyId)
          .where('parentCategoryId', isEqualTo: parentCategoryId);

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }
      query = query.orderBy(orderByField, descending: descending);

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      }).handleError((error, stackTrace) {
        print(
            'Error streaming categories by parent ID "$parentCategoryId": $error\n$stackTrace');
        return <Category>[];
      });
    } catch (e, stackTrace) {
      print(
          'Synchronous error setting up categories stream by parent ID: $e\n$stackTrace');
      CommonLoaders.errorSnackBar(
          title: "Stream Setup Error",
          message:
              "Could not set up child category stream. (Code: CATSTRM_PARENT_INIT)");
      return Stream.value([]);
    }
  }

  /// getCategoriesByParentId (Future-based)
  Future<List<Category>> getCategoriesByParentId(
    String parentCategoryId, {
    bool activeOnly = true,
    String orderByField = 'categoryName',
    bool descending = false,
  }) async {
    if (parentCategoryId.isEmpty) {
      CommonLoaders.warningSnackBar(
          title: "Error",
          message: "Getting categories failed. Error code: CATFET_PARENT_NOID");
      return [];
    }
    // Optional: Validate against parentCatIds if that list is meant to be exhaustive for valid parent IDs
    if (!parentCatIds.contains(parentCategoryId)) {
      CommonLoaders.warningSnackBar(
          title: "Error: Invalid Parent Input",
          message: "Getting categories failed. Error code: CATFET_PARENT_INVALID");
      return [];
    }
    try {
      final companyId = _getCompanyIdOrFail();
      Query<Category> query = _categoriesCollection
          .where('companyId', isEqualTo: companyId)
          .where('parentCategoryId', isEqualTo: parentCategoryId);
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }
      query = query.orderBy(orderByField, descending: descending);
      QuerySnapshot<Category> snapshot = await query.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print(
          'Error retrieving categories by parent ID "$parentCategoryId": $e');
      CommonLoaders.errorSnackBar(
          title: "Fetch Error",
          message:
              "Could not retrieve child categories. (Code: CATFET_PARENT_FAIL)");
      return [];
    }
  }

  /// Updates an existing category in Firestore.
  Future<bool> updateCategory(Category category) async {
    if (category.categoryId == null || category.categoryId!.isEmpty) {
      CommonLoaders.errorSnackBar(
          title: "Update Error",
          message: "Category ID is required for updating. (Code: CATUPD_NOID)");
      return false;
    }

    // Ensure companyId is correctly set and matchesthe global context
    final companyId =
        _getCompanyIdOrFail(providedCompanyId: category.companyId);
    if (category.companyId != companyId) {
      CommonLoaders.errorSnackBar(
          title: "Update Error",
          message: "Category company mismatch. (Code: CATUPD_COMPMISMATCH)");
      return false; // Or handle as a critical error
    }

    Category categoryToUpdate = category.copyWith(
      companyId: companyId, // Ensure it's the validated one
      updatedAt:
          DateTime.now(), // Explicitly set updatedAt for the update operation
    );

    try {
      // Check if the category exists and belongs to the company before updating
      DocumentSnapshot<Category> currentDoc =
          await _categoriesCollection.doc(categoryToUpdate.categoryId).get();
      if (!currentDoc.exists || currentDoc.data()?.companyId != companyId) {
        CommonLoaders.errorSnackBar(
            title: "Update Error",
            message:
                "Category not found or access denied for update. (Code: CATUPD_NOEXIST)");
        return false;
      }

      // Check for duplicate category code, excluding the current category
      bool isCodeTaken = await isCategoryCodeTaken(
        categoryToUpdate.categoryCode,
        excludeCategoryId: categoryToUpdate.categoryId,
        parentId: categoryToUpdate.parentCategoryId,
      );
      if (isCodeTaken) {
        CommonLoaders.errorSnackBar(
            title: "Duplicate Category Code",
            message:
                'Category code "${categoryToUpdate.categoryCode}" is already in use. (Code: CATUPD_DUPCODE)');
        return false;
      }

      await _categoriesCollection.doc(categoryToUpdate.categoryId).set(
          categoryToUpdate,
          SetOptions(merge: true)); // Use set with merge or update
      CommonLoaders.successSnackBar(
          title: "Success",
          message: "${categoryToUpdate.categoryName} updated successfully.");
      return true;
    } catch (e) {
      print(
          'Error updating product category "${categoryToUpdate.categoryId}": $e');
      CommonLoaders.errorSnackBar(
          title: "Update Failed",
          message:
              "Could not update category. ${e.toString()} (Code: CATUPD_FAIL)");
      return false;
    }
  }

  /// Deactivates a product category (soft delete).
  Future<bool> deactivateCategory(String categoryId) async {
    if (categoryId.isEmpty) {
      CommonLoaders.warningSnackBar(
          title: "Input Error",
          message: "Category ID cannot be empty for deactivation.");
      return false;
    }
    try {
      final companyId = _getCompanyIdOrFail();
      // Optional: Check if category exists and belongsto company before attempting update
      DocumentSnapshot<Category> currentDoc =
          await _categoriesCollection.doc(categoryId).get();
      if (!currentDoc.exists || currentDoc.data()?.companyId != companyId) {
        CommonLoaders.errorSnackBar(
            title: "Deactivation Failed",
            message:
                "Category not found or access denied. (Code: CATDEACT_NOEXIST)");
        return false;
      }

      await _categoriesCollection.doc(categoryId).update({
        'isActive': false,
        'updatedAt':
            FieldValue.serverTimestamp(), // Useserver timestamp for consistency
      });
      CommonLoaders.successSnackBar(
          title: "Deactivation Successful",
          message: "Category deactivated successfully.");
      return true;
    } catch (e) {
      print('Error deactivating product category "$categoryId": $e');
      CommonLoaders.errorSnackBar(
          title: "Deactivation Failed",
          message:
              "Could not deactivate category. ${e.toString()} (Code: CATDEACT_FAIL)");
      return false;
    }
  }

  /// Reactivates a product category.
  Future<bool> reactivateCategory(String categoryId) async {
    if (categoryId.isEmpty) {
      CommonLoaders.warningSnackBar(
          title: "Input Error",
          message: "Category ID cannot be empty for reactivation.");
      return false;
    }
    try {
      final companyId = _getCompanyIdOrFail();
      // Optional: Check if category exists and belongs to company
      DocumentSnapshot<Category> currentDoc =
          await _categoriesCollection.doc(categoryId).get();
      if (!currentDoc.exists || currentDoc.data()?.companyId != companyId) {
        CommonLoaders.errorSnackBar(
            title: "Reactivation Failed",
            message:
                "Category not found or access denied. (Code: CATREACT_NOEXIST)");
        return false;
      }

      await _categoriesCollection.doc(categoryId).update({
        'isActive': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      CommonLoaders.successSnackBar(
          title: "Reactivation Successful",
          message: "Category reactivated successfully.");
      return true;
    } catch (e) {
      print('Error reactivating product category "$categoryId": $e');
      CommonLoaders.errorSnackBar(
          title: "Reactivation Failed",
          message:
              "Could not reactivate category. ${e.toString()} (Code: CATREACT_FAIL)");
      return false;
    }
  }

  /// Permanently deletes a product category from Firestore.
  /// CAUTION: This is a hard delete. Ensure this category is not actively referenced
  /// by products or other entities, or implement cascading delete logic if necessary.
  Future<bool> deleteCategoryPermanently(String categoryId) async {
    if (categoryId.isEmpty) {
      CommonLoaders.errorSnackBar(
          title: "Deletion Failed",
          message: "Category ID cannot be empty. (Code: CATDEL_NOID)");
      return false;
    }

    try {
      final companyId = _getCompanyIdOrFail();
      DocumentSnapshot<Category> currentDoc =
          await _categoriesCollection.doc(categoryId).get();

      if (!currentDoc.exists || currentDoc.data()?.companyId != companyId) {
        CommonLoaders.errorSnackBar(
            title: "Deletion Failed",
            message:
                "Category not found or access denied. (Code: CATDEL_NOEXIST)");
        return false;
      }

      // **IMPORTANT CONSIDERATION FOR DELETION:**
      // Before deleting, you might want to check if this category is being used.
      // For example, if products have a `categoryId` field:
      // QuerySnapshot productsUsingCategory = await _firestore.collection('products')
      //   .where('companyId', isEqualTo: companyId)
      //   .where('categoryId', isEqualTo: categoryId)
      //   .limit(1)
      //   .get();
      // if (productsUsingCategory.docs.isNotEmpty) {
      //   CommonLoaders.errorSnackBar(
      //       title: "Deletion Failed",
      //       message: "Category is currently in use by products and cannot be deleted. Please reassign products first. (Code: CATDEL_INUSE)");
      //   return false;
      // }
      //
      // Also, consider child categories. If a category has children, you might want to:
      // 1. Prevent deletion.
      // 2. Delete children recursively (can be complex and resource-intensive).
      // 3. Set child categories' parentCategoryId to null or a default parent.
      // For simplicity, this example does not implement these checks.

      await _categoriesCollection.doc(categoryId).delete();
      CommonLoaders.successSnackBar(
          title: "Deletion Successful",
          message: 'Category "$categoryId" permanently deleted.');
      print(
          'Product category "$categoryId" from company "$companyId" permanently deleted.');
      return true;
    } catch (e) {
      print('Error permanently deleting product category "$categoryId": $e');
      CommonLoaders.errorSnackBar(
          title: "Deletion Failed",
          message:
              "Could not delete category. ${e.toString()} (Code: CATDEL_FAIL)");
      return false;
    }
  }

// Potential future methods (similar to ProductVariantService):
// - searchCategories(String searchTerm, {bool activeOnly = true})
// - getAllCategories (Future-based, if needed alongside the stream)
}
