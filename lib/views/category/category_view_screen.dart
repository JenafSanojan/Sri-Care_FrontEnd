import 'package:flutter/material.dart';
import 'package:intl_date_helper/intl_date_helper.dart';
import 'package:sri_tel_flutter_web_mob/entities/common.dart';
import 'package:sri_tel_flutter_web_mob/entities/category.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'package:sri_tel_flutter_web_mob/views/category/category_add_screen.dart';
import '../../services/firebase_services/category_service.dart';
import '../../widget_common/drop_field.dart';
import '../../widget_common/common_app_bar.dart';

class CategoryViewScreen extends StatefulWidget {
  final bool isShowAppBar;
  final bool canGoBack;
  const CategoryViewScreen(
      {super.key, this.isShowAppBar = true, this.canGoBack = true});

  @override
  State<CategoryViewScreen> createState() => _CategoryViewScreenState();
}

class _CategoryViewScreenState extends State<CategoryViewScreen> {
  final CategoryService _categoryService = CategoryService();
  bool _showActiveOnly = true;
  String _sortBy = 'categoryName';
  bool _sortAscending = true;
  int? _currentSortColumn;
  TextEditingController _parentCategoryController = TextEditingController();
  List<CustomDropdownItem> dropdownItems =
      parentCatDropdownItems.map((cat) => cat).toList();
  bool refreshFlag = true;

  List<DataColumn> _createDataColumns() {
    return [
      DataColumn(
        label: const Text('Name'),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortBy = 'categoryName';
            _sortAscending = ascending;
            _currentSortColumn = columnIndex;
          });
        },
      ),
      DataColumn(
        label: const Text('Code'),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortBy = 'categoryCode';
            _sortAscending = ascending;
            _currentSortColumn = columnIndex;
          });
        },
      ),
      const DataColumn(label: Text('Parent ID')),
      DataColumn(
        label: const Text('Status'),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortBy = 'isActive';
            _sortAscending = ascending;
            _currentSortColumn = columnIndex;
          });
        },
      ),
      DataColumn(
        label: const Text('Last Updated At'),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortBy = 'updatedAt';
            _sortAscending = ascending;
            _currentSortColumn = columnIndex;
          });
        },
      ),
      const DataColumn(label: Text('Actions')),
    ];
  }

  @override
  void initState() {
    dropdownItems.add(CustomDropdownItem(value: "", label: "  -  "));
    _parentCategoryController = TextEditingController();
    _parentCategoryController.text = parentCatIds.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isShowAppBar
          ? commonAppBar(
              title: 'Manage Product Categories',
              context: context,
              actions: [
                SizedBox(
                  width: 250,
                  child: DropDawnButton(
                    controller: _parentCategoryController,
                    customListItems: dropdownItems,
                    hintText: 'Select Category Type',
                    value: parentCatIds.first,
                    action: (value) => {
                      setState(() {
                        refreshFlag = !refreshFlag;
                      }),
                    },
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a parent category.';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _showActiveOnly ? Icons.filter_list : Icons.filter_list_off,
                    color: white,
                  ),
                  tooltip: _showActiveOnly
                      ? 'Showing Active Only (Tap to Show All)'
                      : 'Showing All (Tap to Show Active Only)',
                  onPressed: () {
                    setState(() {
                      _showActiveOnly = !_showActiveOnly;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: white),
                  tooltip: 'Add New Category',
                  onPressed: () => showAddCategoryPopup(context),
                ),
              ],
              canGoBack: widget.canGoBack,
            )
          : null,
      body: StreamBuilder<List<Category>>(
        stream: _parentCategoryController.text.isNotEmpty &&
                parentCatIds.contains(_parentCategoryController.text)
            ? _categoryService.getCategoriesStreamByParentId(
                _parentCategoryController.text,
                activeOnly: _showActiveOnly,
              )
            : _categoryService.getAllCategoriesStream(
                activeOnly: _showActiveOnly,
              ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(_showActiveOnly
                  ? 'No active categories found.'
                  : 'No categories found.'),
            );
          }

          final categories = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _sortAscending,
                  columns: _createDataColumns(),
                  rows: categories.map((category) {
                    return DataRow(
                      cells: [
                        DataCell(Text(category.categoryName)),
                        DataCell(Text(category.categoryCode)),
                        DataCell(Text(category.parentCategoryId ?? 'N/A')),
                        DataCell(Text(
                          category.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color:
                                category.isActive ? Colors.green : Colors.red,
                          ),
                        )),
                        DataCell(Text(category.updatedAt != null
                            ? IntlDateHelper.formatDate(category.updatedAt!,
                                outputFormat: "yyyy-MM-dd - (HH:mm)")
                            : 'N/A')),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_rounded,
                                  color: Colors.blue, size: 18),
                              tooltip: 'Edit Category',
                              onPressed: () => showAddCategoryPopup(context,
                                  categoryToEdit: category),
                            ),
                            if (category.isActive)
                              IconButton(
                                icon: const Icon(Icons.delete_rounded,
                                    color: Colors.red, size: 20),
                                tooltip: 'Deactivate Category',
                                onPressed: () async {
                                  bool success = await _categoryService
                                      .deactivateCategory(category.categoryId!);
                                  if (success && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${category.categoryName} deactivated successfully.')),
                                    );
                                  }
                                },
                              )
                            else
                              IconButton(
                                icon: const Icon(Icons.restore_rounded,
                                    color: Colors.green, size: 20),
                                tooltip: 'Reactivate Category',
                                onPressed: () async {
                                  bool success = await _categoryService
                                      .reactivateCategory(category.categoryId!);
                                  if (success && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${category.categoryName} reactivated successfully.')),
                                    );
                                  }
                                },
                              ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
