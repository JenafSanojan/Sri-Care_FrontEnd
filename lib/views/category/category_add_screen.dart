import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sri_tel_flutter_web_mob/entities/category.dart'; // Ensure this path is correct
import 'package:sri_tel_flutter_web_mob/services/firebase_services/category_service.dart'; // Ensure this path is correct
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/custom_textwidget.dart'; // Your custom text field
import 'package:sri_tel_flutter_web_mob/widget_common/drop_field.dart'; // Your custom dropdown
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../widget_common/pop_up_screens/delete_popup.dart'; // Your delete popup

// Assuming parentCatDropdownItems is defined globally or imported
// If it's part of your Category class, you might access it differently.
// For this example, I'm assuming it's available in this scope.

class AddCategoryScreen extends StatefulWidget {
  final Category? categoryToEdit;

  const AddCategoryScreen({
    Key? key,
    this.categoryToEdit,
  }) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final CategoryService _categoryService = CategoryService();

  late TextEditingController _categoryCodeController;
  late TextEditingController _categoryNameController;
  late TextEditingController _parentCategoryController;
  // Categories typically don't have description or display order like variants,
  // but you can add them if your Category entity supports them.
  // late TextEditingController _descriptionController;
  // late TextEditingController _displayOrderController;

  bool _isActive = true;
  DateTime? _createdAt;

  bool _isEditMode = false;
  bool _isLoading = false;

  String? _lastCreatedCategory;
  final FocusNode _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _categoryCodeController = TextEditingController();
    _categoryNameController = TextEditingController();
    _parentCategoryController = TextEditingController();
    // _descriptionController = TextEditingController();
    // _displayOrderController = TextEditingController();

    if (widget.categoryToEdit != null) {
      _isEditMode = true;
      final category = widget.categoryToEdit!;
      _categoryCodeController.text = category.categoryCode;
      _categoryNameController.text = category.categoryName;
      _parentCategoryController.text = category.parentCategoryId ?? '';
      // _descriptionController.text = category.description ?? ''; // If you add description
      //_displayOrderController.text = category.displayOrder?.toString() ?? ''; // If you add displayOrder
      _isActive = category.isActive;
      _createdAt = category.createdAt;
    } else {
      // Default parent category if creating a new one and parentCatDropdownItems is not empty
      if (parentCatDropdownItems.isNotEmpty) {
        _parentCategoryController.text = parentCatDropdownItems.first.value;
      }
    }
  }

  @override
  void dispose() {
    _categoryCodeController.dispose();
    _categoryNameController.dispose();
    _parentCategoryController.dispose();
    // _descriptionController.dispose();
    // _displayOrderController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      CommonLoaders.errorSnackBar(
          title: "Validation Error", message: "Please check the fields.");
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final categoryCode = _categoryCodeController.text.trim().toUpperCase();
    bool isCodeTaken = false;

    // Check if code is taken only if it's a new category or the code has changed in edit mode
    if (!_isEditMode ||
        (_isEditMode && categoryCode != widget.categoryToEdit!.categoryCode)) {
      isCodeTaken = await _categoryService.isCategoryCodeTaken(
        categoryCode,
        excludeCategoryId:
            _isEditMode ? widget.categoryToEdit!.categoryId : null,
      );
    }

    if (isCodeTaken) {
      CommonLoaders.errorSnackBar(
          title: "Duplicate Code",
          message: "This category code is already in use.");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    // Assuming companyId will be handled by the service or taken from a global scope
    final categoryData = Category(
      categoryId: _isEditMode ? widget.categoryToEdit!.categoryId : null,
      // companyId will be set by the service or fromGlobalAuthData
      companyId: '', // Placeholder, service should handle this
      categoryCode: categoryCode,
      categoryName: _categoryNameController.text.trim(),
      parentCategoryId: _parentCategoryController.text.trim().isNotEmpty
          ? _parentCategoryController.text.trim()
          : null,
      isActive: _isActive,
      createdAt:
          _isEditMode ? _createdAt : null, // Service handles createdAt on new
      // description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null, // If added
      // displayOrder: _displayOrderController.text.trim().isNotEmpty ? int.tryParse(_displayOrderController.text.trim()) : null, // If added
    );

    bool success = false;
    String message = '';

    try {
      _lastCreatedCategory =
          '${categoryData.categoryName} (${categoryData.categoryCode})';
      if (_isEditMode) {
        success = await _categoryService.updateCategory(categoryData);
        message = success
            ? 'Category updated successfully! [$_lastCreatedCategory]'
            : 'Failed to update category.';
      } else {
        String? newCategoryId =
            await _categoryService.createCategory(categoryData);
        success = newCategoryId != null;
        message = success
            ? 'Category created successfully! [$_lastCreatedCategory]'
            : 'Failed to create category.';
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );
        if (_isEditMode) {
          Navigator.pop(context, true); // Pop if editing and successful
        } else {
          //Clear fields for next entry if creating new and successful
          _categoryCodeController.clear();
          _categoryNameController.clear();
          // _descriptionController.clear(); // Uncomment if you add this field
          // _displayOrderController.clear(); // Uncomment if you add this field

          // Resetparent category to the default or clear it
          if (parentCatDropdownItems.isNotEmpty) {
            // Check if the controller is already bound to a DropDawnButton that updates it
            // If DropDawnButton updates the controller directly, this might be redundant
            // or you might want to ensure the visual selection in DropDawnButton also resets.
            // For simplicity, just setting the controller's text.
            _parentCategoryController.text = parentCatDropdownItems.first.value;
          } else {
            _parentCategoryController.clear();
          }
          // Trigger a rebuild ifthe DropDawnButton's displayed value needs to update
          // based on _parentCategoryController.text and doesn't do so automatically.
          // However, if DropDawnButton correctly uses the controller's value, this setState
          // might not be strictly necessary for the dropdown itself, but good for other UI elements.
          setState(() {});

          FocusScope.of(context).requestFocus(
              _codeFocusNode); // Focus on code field for next entry
        }
      } else if (mounted && !success) {
        // Ensure widget is still mounted and operation failed
        CommonLoaders.errorSnackBar(title: "Error", message: message);
      }
    } catch (e) {
      if (mounted) {
        CommonLoaders.errorSnackBar(
            title: "Operation Failed",
            message: "An error occurred: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteCategory() async {
    // if (!_isEditMode || widget.categoryToEdit?.categoryId == null){
    //   CommonLoaders.errorSnackBar(title: "Error", message: "No category selected for deletion.");
    //   return;
    // }
    //
    // final confirmDelete = await Get.dialog<bool>( // Using Get.dialog for confirmation
    //   DeletePopScreen( // Assuming DeletePopScreen returns true if confirmed
    //     title: 'Delete Category?',
    //     message: 'Are you sure you want to delete "${widget.categoryToEdit!.categoryName}"? This action might be irreversible depending on system setup (soft vs hard delete).',
    //   ),
    // );
    //
    // if (confirmDelete == true) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   // Decide on soft delete (deactivate) or hard delete
    //   // Using deactivate as it's generally safer and often preferred
    //   bool deleted = await _categoryService.deactivateCategory(widget.categoryToEdit!.categoryId!);
    //   // If you want hard delete:
    //   // bool deleted = await _categoryService.deleteCategoryPermanently(widget.categoryToEdit!.categoryId!);
    //
    //   if (deleted && mounted) {
    //     CommonLoaders.successSnackBar(
    //         title: "Success",
    //         message: "Category '${widget.categoryToEdit!.categoryName}' ${ _categoryService.deleteCategoryPermanently == null ? "deactivated" : "deleted" } successfully."); // Adjust message based on delete type
    //     Navigator.pop(context, true); // Pop screen after delete
    //   } else if (mounted) {
    //     CommonLoaders.errorSnackBar(
    //         title: "Error",
    //         message: "Failed to delete category.");
    //   }
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
        ),
        title: Text(
          _isEditMode ? 'Edit Category' : 'Add New Category',
          style: const TextStyle(color: Colors.white, fontSize: 21),
        ),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: _isLoading ? null : _deleteCategory,
              tooltip: 'Delete Category',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // DropDawnButton for Parent Category
              DropDawnButton(
                controller: _parentCategoryController,
                customListItems: parentCatDropdownItems, // Use the global list
                hintText: 'Select Parent Category (Optional)',
                isEmphasis: true, // Or true if this is a very important field
                value: _parentCategoryController.text.isNotEmpty
                    ? _parentCategoryController.text
                    : (parentCatDropdownItems.isNotEmpty && !_isEditMode
                        ? parentCatDropdownItems.first.value
                        : null),
                validation: (value) {
                  // Example: if you want to make it mandatory for sub-categories
                  if (value == null || value.isEmpty) {
                    return 'Please select a parent category.';
                  }
                  return null; // Allow no parent (top-level category)
                },
                // Optional: Add an action if needed when dropdown changes
                action: (selectedValue) {
                  setState(() {

                  });
                },
              ),
              const SizedBox(height: 16),
              customTextField(
                controller: _categoryCodeController,
                hint: 'Category Code (e.g., ELEC, BOOK) *',
                isPass: false,
                focusNode: _codeFocusNode,
                validation: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category code is required.';
                  }
                  if (value.trim().length > 10) {
                    return 'Code is too long (max 10 chars).';
                  }
                  // Basic regex for typical codes (alphanumeric, possibly hyphens)
                  if (!RegExp(r"^[A-Z0-9-]+$").hasMatch(value.trim())) {
                    return 'Invalid code format (A-Z, 0-9, -).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              customTextField(
                controller: _categoryNameController,
                hint: 'Category Name (e.g., Electronics, Books) *',
                isPass: false,
                validation: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category name is required.';
                  }
                  if (value.trim().length > 50) {
                    return 'Name is too long (max 50 chars).';
                  }
                  return null;
                },
              ),
              // Add other fields like description or displayOrder if your Category entity has them
              // const SizedBox(height: 16),
              // customTextField(
              //   controller: _descriptionController,
              //   hint: 'Description (Optional)',
              //   isPass: false,
              //   maxLines: 3,
              // ),
              // const SizedBox(height: 16),
              // SwitchListTile(
              //   title: const Text('Category is Active'),
              //   value: _isActive,
              //   onChanged: (bool value) {
              //     setState(() {
              //       _isActive = value;
              //     });
              //   },
              //   tileColor: Colors.grey[100],
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8)),
              //   activeThumbColor: darkGreen, // Use activeColor for the switch itself
              //   activeTrackColor: darkGreen,
              // ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  darkGreen, // From your utils/colors.dart
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _submitForm,
                            child: Text(
                              _isEditMode ? 'Save Changes' : 'Create Category',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                  color: orangeColor,
                                  width: 1.5), // From your utils/colors.dart
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Cancel',
                              style:
                                  TextStyle(color: orangeColor, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 10),
              if (_lastCreatedCategory != null &&
                  !_isEditMode) // Show only when creating new ones
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Last Created: $_lastCreatedCategory',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper function to show the AddCategoryScreenas a dialog/popup
void showAddCategoryPopup(BuildContext context, {Category? categoryToEdit}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) =>
        const SizedBox.shrink(), // Should not be built directly
    transitionBuilder: (ctx, anim1, anim2, child) {
      final size = MediaQuery.of(context).size;
      return Transform.scale(
        scale: anim1.value,
        child: Opacity(
          opacity: anim1.value,
          child: Center(
            child: Container(
              width: size.width * 0.9, // Adjust width as needed
              height: size.height *
                  0.75, // Adjust height as needed, categories might need less space
              padding: const EdgeInsets.all(
                  1.0), // Minimal padding for the outer container
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]),
              child: ClipRRect(
                // Ensures content respects border radius
                borderRadius: BorderRadius.circular(
                    11), // Slightly less than container for clean look
                child: Material(
                  // Material widget for theming and ink effects
                  type: MaterialType.transparency,
                  child: AddCategoryScreen(categoryToEdit: categoryToEdit),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
