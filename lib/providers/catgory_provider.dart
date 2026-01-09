import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/services/firebase_services/category_service.dart'; // Your CategoryService
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';

import '../entities/category.dart';
import '../entities/ui_entities.dart'; // For CommonLoaders

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  // Cache for all categories
  List<Category>? _allCategories;
  bool _isLoadingAll = false;

  // Cache for categories by parent ID
  // Key: parentCategoryId, Value: List of child categories
  final Map<String, List<Category>> _categoriesByParentCache = {};
  final Map<String, bool> _isLoadingByParent = {}; // Key: parentCategoryId

  // Cache for individual categories fetched by ID
  final Map<String, Category> _cachedCategoryById = {};
  bool _isLoadingSingle = false;

  String? _error;

  // --- Getters for UI ---
  // List<Category>? get allCategories => _allCategories;
  // List<Category> get activeCategories =>_allCategories?.where((c) => c.isActive).toList() ?? [];

  bool get isLoadingAll => _isLoadingAll;

  // List<Category>? getCategoriesByParentId(String parentCategoryId) =>
  //     _categoriesByParentCache[parentCategoryId];
  //
  // List<Category> getActiveCategoriesByParentId(String parentCategoryId) =>
  //     _categoriesByParentCache[parentCategoryId]
  //         ?.where((c) => c.isActive)
  //         .toList() ??
  //         [];

  bool isLoadingByParent(String parentCategoryId) =>
      _isLoadingByParent[parentCategoryId] ?? false;

  // Category? getCategoryById(String categoryId) =>
  //     _cachedCategoryById[categoryId];
  bool get isLoadingSingle => _isLoadingSingle;

  String? get error => _error;

  // --- Fetch and Cache All Categories ---
  Future<List<Category>?> fetchAllCategories({
    bool activeOnly = true, // UI might often want active ones by default
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _allCategories != null) {
      return activeOnly
          ? _allCategories?.where((c) => c.isActive).toList()
          : _allCategories;
    }

    _isLoadingAll = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch all categories (active and inactive) to build a comprehensive cache
      _allCategories =
          await _categoryService.getAllCategories(activeOnly: false);
      _cachedCategoryById.clear();
      _categoriesByParentCache.clear(); // Clear parent cache as it's rebuilt

      if (_allCategories != null) {
        for (var category in _allCategories!) {
          if (category.categoryId != null) {
            _cachedCategoryById[category.categoryId!] = category;
          }
          // Populate parent cache
          final parentId = category.parentCategoryId;
          if (parentId != null && parentId.isNotEmpty) {
            _categoriesByParentCache
                .putIfAbsent(parentId, () => [])
                .add(category);
          }
        }
        // Sort children within parent cache if needed (e.g., by name or display order)
        _categoriesByParentCache.forEach((key, value) {
          value.sort((a, b) => a.categoryName.compareTo(b.categoryName));
        });
      }
    } catch (e) {
      print('Error in CategoryProvider fetching all categories: $e');
      _error = "Failed to load all categories.";
      _allCategories = null; // Clear cache on error
    } finally {
      _isLoadingAll = false;
      notifyListeners();
    }
    return activeOnly
        ? _allCategories?.where((c) => c.isActive).toList()
        : _allCategories;
  }

  // --- Fetch and Cache Categories by Parent ID ---
  Future<List<Category>?> fetchCategoriesByParentId(
    String parentCategoryId, {
    bool activeOnly = true,
    bool forceRefresh = false,
  }) async {
    // An empty parentCategoryId often means root categories
    if (parentCategoryId.isEmpty) {
      return null;
    }

    if (!forceRefresh &&
        _categoriesByParentCache.containsKey(parentCategoryId)) {
      return activeOnly
          ? _categoriesByParentCache[parentCategoryId]
              ?.where((c) => c.isActive)
              .toList()
          : _categoriesByParentCache[parentCategoryId];
    }

    _isLoadingByParent[parentCategoryId] = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch all (active and inactive) for this parent to ensure cache completeness
      final categories = await _categoryService.getCategoriesByParentId(
        parentCategoryId,
        activeOnly: false,
      );
      categories.sort((a, b) =>
          a.categoryName.compareTo(b.categoryName)); // Sort if service doesn't
      _categoriesByParentCache[parentCategoryId] = categories;

      // Also update individual cache
      for (var category in categories) {
        if (category.categoryId != null) {
          _cachedCategoryById[category.categoryId!] = category;
        }
      }
    } catch (e) {
      print(
          'Error in CategoryProvider fetching categories for parent "$parentCategoryId": $e');
      _error = "Failed to load categories for parent $parentCategoryId.";
      _categoriesByParentCache
          .remove(parentCategoryId); // Clear on error for this parent
    } finally {
      _isLoadingByParent[parentCategoryId] = false;
      notifyListeners();
    }
    return activeOnly
        ? _categoriesByParentCache[parentCategoryId]
            ?.where((c) => c.isActive)
            .toList()
        : _categoriesByParentCache[parentCategoryId];
  }

  // --- Fetch and Cache a Single Category by ID ---
  Future<Category?> fetchCategoryById(String categoryId,
      {bool forceRefresh = false}) async {
    if (categoryId.isEmpty) return null;
    if (!forceRefresh && _cachedCategoryById.containsKey(categoryId)) {
      return _cachedCategoryById[categoryId];
    }

    _isLoadingSingle = true;
    _error = null;
    notifyListeners();

    try {
      final category = await _categoryService.getCategoryById(categoryId);
      if (category != null && category.categoryId != null) {
        _cachedCategoryById[category.categoryId!] = category;
        // Optionally update _allCategories and _categoriesByParentCache if this is a new/updated item
        // For simplicity, this example primarily updates the direct ID cache here.
        // A full refresh or more targeted update to other caches might be needed for perfect consistency
        // if this item wasn't already part of those caches.
      }
      return category;
    } catch (e) {
      print(
          'Error in CategoryProvider fetching category by ID "$categoryId": $e');
      _error = "Failed to load category $categoryId.";
      return null;
    } finally {
      _isLoadingSingle = false;
      notifyListeners();
    }
  }

  // --- Create a new category ---
  Future<String?> createCategory(Category category) async {
    _isLoadingAll = true; //Or a specific _isCreating flag
    _error = null;
    notifyListeners();
    String? newCategoryId;
    try {
      newCategoryId = await _categoryService.createCategory(category);
      if (newCategoryId != null) {
        // For immediate UI update, add to local cache.
        // A full refresh (fetchAllCategories(forceRefresh: true)) is safer for consistency
        // across all caches but less performant for a single addition.
        Category newCategoryWithId = category.copyWith(
            categoryId: newCategoryId,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        // Add to _allCategories
        _allCategories ??= [];
        _allCategories!.add(newCategoryWithId);
        _allCategories!
            .sort((a, b) => a.categoryName.compareTo(b.categoryName));

        // Add to _cachedCategoryById
        _cachedCategoryById[newCategoryId] = newCategoryWithId;

        // Add to _categoriesByParentCache
        final parentId = newCategoryWithId.parentCategoryId;
        if (parentId != null && parentId.isNotEmpty && _categoriesByParentCache.containsKey(parentId)) {
          _categoriesByParentCache
              .putIfAbsent(parentId, () => [])
              .add(newCategoryWithId);
          _categoriesByParentCache[parentId]
              ?.sort((a, b) => a.categoryName.compareTo(b.categoryName));
        }

        CommonLoaders.successSnackBar(
            title: "Success",
            message: "Category '${category.categoryName}' created.");
      }
      // Error snackbar is handled by the service if it implements it
    } catch (e) {
      print('Error in CategoryProvider creating category: $e');
      _error = "Failed to create category.";
      // CommonLoaders.errorSnackBar might be called in service, or fallback here
    } finally {
      _isLoadingAll = false;
      notifyListeners();
    }
    return newCategoryId;
  }

  // --- Update an existing category ---
  Future<bool> updateCategory(Category category) async {
    _isLoadingSingle = true; // More specific loading flag
    _error = null;
    notifyListeners();
    bool success = false;
    try {
      success = await _categoryService.updateCategory(category);
      if (success) {
        Category updatedCategory = category.copyWith(updatedAt: DateTime.now());
        // Update caches
        if (updatedCategory.categoryId != null) {
          _cachedCategoryById[updatedCategory.categoryId!] = updatedCategory;

          if (_allCategories != null) {
            final indexAll = _allCategories!
                .indexWhere((c) => c.categoryId == updatedCategory.categoryId);
            if (indexAll != -1) {
              _allCategories![indexAll] = updatedCategory;
              _allCategories!
                  .sort((a, b) => a.categoryName.compareTo(b.categoryName));
            } else {
              fetchAllCategories();
              notifyListeners();
              return success; // Refresh all categories if not found
            }
          }

          // Update in _categoriesByParentCache
          // This is more complex if the parentCategoryId changed.
          // For simplicity, if parentId changed, a full refresh of parent caches might be easier.
          // Or, remove from old parent list and add to new.
          final parentId = updatedCategory.parentCategoryId;
          if (parentId != null && parentId.isNotEmpty) {
            // Remove from all parent lists first to handle parent change
            _categoriesByParentCache.forEach((key, list) {
              list.removeWhere(
                  (c) => c.categoryId == updatedCategory.categoryId);
            });
            // Add to the correct parent list
            _categoriesByParentCache
                .putIfAbsent(parentId, () => [])
                .add(updatedCategory);
            _categoriesByParentCache[parentId]
                ?.sort((a, b) => a.categoryName.compareTo(b.categoryName));
          } else {
            // If it became a root category, ensure it's removed from any parent list it might have been in
            _categoriesByParentCache.forEach((key, list) {
              list.removeWhere(
                  (c) => c.categoryId == updatedCategory.categoryId);
            });
          }
        }
        CommonLoaders.successSnackBar(
            title: "Success",
            message: "Category '${category.categoryName}' updated.");
      }
      // Error snackbar handled by service
    } catch (e) {
      print('Error in CategoryProvider updating category: $e');
      _error = "Failed to update category.";
    } finally {
      _isLoadingSingle = false;
      notifyListeners();
    }
    return success;
  }

  // --- Deactivate a category ---
  Future<bool> deactivateCategory(String categoryId) async {
    _isLoadingSingle = true;
    _error = null;
    notifyListeners();
    bool success = false;
    try {
      success = await _categoryService.deactivateCategory(categoryId);
      if (success) {
        _updateCategoryActiveStatus(categoryId, false);
        CommonLoaders.successSnackBar(
            title: "Success", message: "Category deactivated.");
      }
    } catch (e) {
      print('Error in CategoryProvider deactivating category: $e');
      _error = "Failed to deactivate category.";
    } finally {
      _isLoadingSingle = false;
      notifyListeners();
    }
    return success;
  }

  // --- Reactivate a category ---
  Future<bool> reactivateCategory(String categoryId) async {
    _isLoadingSingle = true;
    _error = null;
    notifyListeners();
    bool success = false;
    try {
      success = await _categoryService.reactivateCategory(categoryId);
      if (success) {
        _updateCategoryActiveStatus(categoryId, true);
        CommonLoaders.successSnackBar(
            title: "Success", message: "Category reactivated.");
      }
    } catch (e) {
      print('Error in CategoryProvider reactivating category: $e');
      _error = "Failed to reactivate category.";
    } finally {
      _isLoadingSingle = false;
      notifyListeners();
    }
    return success;
  }

  // Helper to update isActive status in all relevant caches
  void _updateCategoryActiveStatus(String categoryId, bool isActive) {
    Category? updatedCategory;
    DateTime now = DateTime.now();

    // Update _cachedCategoryById
    if (_cachedCategoryById.containsKey(categoryId)) {
      updatedCategory = _cachedCategoryById[categoryId]!
          .copyWith(isActive: isActive, updatedAt: now);
      _cachedCategoryById[categoryId] = updatedCategory;
    }

    // Update _allCategories
    if (_allCategories != null) {
      final index =
          _allCategories!.indexWhere((c) => c.categoryId == categoryId);
      if (index != -1) {
        updatedCategory ??=
            _allCategories![index].copyWith(isActive: isActive, updatedAt: now);
        _allCategories![index] = updatedCategory;
        // No re-sorting needed for just active status change
      }
    }

    // Update _categoriesByParentCache
    _categoriesByParentCache.forEach((parentId, categoryList) {
      final index = categoryList.indexWhere((c) => c.categoryId == categoryId);
      if (index != -1) {
        updatedCategory ??=
            categoryList[index].copyWith(isActive: isActive, updatedAt: now);
        categoryList[index] =
            updatedCategory!; // Non-null assertion as it's found
        // No re-sorting needed for just active status change
      }
    });
    // notifyListeners() will be called by the public methods
  }

  // Method to clear all caches
  void clearAllCategoryCaches() {
    _allCategories = null;
    _categoriesByParentCache.clear();
    _cachedCategoryById.clear();
    _isLoadingAll = false;
    _isLoadingByParent.clear();
    _isLoadingSingle = false;
    _error = null;
    notifyListeners();
  }

  // Method to clear cache for a specific parent
  void clearCategoriesByParentCache(String parentCategoryId) {
    _categoriesByParentCache.remove(parentCategoryId);
    _isLoadingByParent.remove(parentCategoryId);
    notifyListeners();
  }

  // Get a list of CustomDropdownItem for active categories
  // List<CustomDropdownItem> getActiveCategoriesForDropdown() {
  //   if (_allCategories == null) {
  //     // Optionally, trigger a fetch if data isn't available yet
  //     // fetchAllCategories(); // Be careful with calling async methods in getters directly
  //     return [];
  //   }
  //   final activeCats = _allCategories!
  //       .where((category) => category.isActive && category.categoryId != null)
  //       .toList();
  //   // Sort them alphabetically by name for the dropdown
  //   activeCats.sort((a, b) =>
  //       a.categoryName.toLowerCase().compareTo(b.categoryName.toLowerCase()));
  //
  //   return activeCats
  //       .map((category) => CustomDropdownItem(
  //             value: category.categoryId!,
  //             label: category.categoryCode != null &&
  //                     category.categoryCode!.isNotEmpty
  //                 ? "${category.categoryName} (${category.categoryCode})"
  //                 : category.categoryName,
  //           ))
  //       .toList();
  // }

  // Geta list of CustomDropdownItem for active child categories of a given parent
  Future<List<CustomDropdownItem>> getActiveChildCategoriesForDropdown(
      String parentCategoryId) async {
    final childCategories = _categoriesByParentCache[parentCategoryId];
    if (childCategories == null) {
      // Optionally, trigger a fetch for this parent if data isn't available
      await fetchCategoriesByParentId(parentCategoryId);
      return [];
    }
    final activeChildCats = childCategories
        .where((category) => category.isActive && category.categoryId != null)
        .toList();
    // Sort them alphabetically by name
    activeChildCats.sort((a, b) =>
        a.categoryName.toLowerCase().compareTo(b.categoryName.toLowerCase()));

    return activeChildCats
        .map((category) => CustomDropdownItem(
              value: category.categoryId!,
              label: category.categoryCode != null &&
                      category.categoryCode!.isNotEmpty
                  ? "${category.categoryName} (${category.categoryCode})"
                  : category.categoryName,
            ))
        .toList();
  }

  // Get a category name by its ID from cache
  String? getCategoryNameById(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return null;
    return _cachedCategoryById[categoryId]?.categoryName;
  }

  // Method to clear the cache and force a full refresh on next get
  void clearCache() {
    _allCategories = null;
    _categoriesByParentCache.clear();
    _cachedCategoryById.clear();
    _error = null;
    notifyListeners(); // Notify if UI depends on the cleared state
  }
}
