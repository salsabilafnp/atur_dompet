import 'package:atur_dompet/config/utils/category_helper.dart';
import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/core/models/category_transaction.dart';
import 'package:atur_dompet/modules/categories/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.standard(title: Dictionary.category),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.incomeCategories.isEmpty &&
            controller.expenseCategories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CREATE BUTTON
              SizedBox(
                width: .infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  iconAlignment: IconAlignment.end,
                  label: Text(Dictionary.addCategoryBtn),
                  onPressed: () => _showCategoryDialog(context),
                ),
              ),
              const SizedBox(height: 40),

              // INCOME CATEGORIES
              Text(
                Dictionary.incomeCategory.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 15),
              _buildCategoryList(
                context,
                categories: controller.incomeCategories,
                hasShadow: true,
              ),
              const SizedBox(height: 40),

              // EXPENSE CATEGORIES
              Text(
                Dictionary.expenseCategory.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 15),
              _buildCategoryList(
                context,
                categories: controller.expenseCategories,
                hasShadow: false,
              ),
            ],
          ),
        );
      }),
    );
  }

  // BUILD LIST Category
  Widget _buildCategoryList(
    BuildContext context, {
    required List<CategoryTransaction> categories,
    required bool hasShadow,
  }) {
    if (categories.isEmpty) {
      return const Center(child: Text(Dictionary.noCategory));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: hasShadow
            ? const [BoxShadow(color: Colors.grey, offset: Offset(4, 4))]
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: categories.map((category) {
          final iconData = CategoryHelper.getIconData(category.icon);
          final color = CategoryHelper.hexToColor(category.color);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Icon(iconData, color: color),
                const SizedBox(width: 15),
                Expanded(child: Text(category.name.toUpperCase())),
                // POPUP MENU (MORE VERTICAL)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  onSelected: (String value) {
                    if (value == 'edit') {
                      _showCategoryDialog(context, category: category);
                    } else if (value == 'delete') {
                      _confirmDelete(category);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, color: Colors.black, size: 20),
                          const SizedBox(width: 10),
                          Text(Dictionary.editBtn),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            Dictionary.deleteBtn,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // DIALOG Create/Update
  void _showCategoryDialog(
    BuildContext context, {
    CategoryTransaction? category,
  }) {
    final isEdit = category != null;

    final nameController = TextEditingController(
      text: isEdit ? category.name : '',
    );
    var selectedType = (isEdit ? category.type : 'expense').obs;
    var selectedIcon =
        (isEdit && category.icon != null ? category.icon! : 'others').obs;
    var selectedColor =
        (isEdit
                ? CategoryHelper.hexToColor(category.color)
                : CategoryHelper.availableColors.first)
            .obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? Dictionary.editCategory : Dictionary.addCategory,
                  style: Get.textTheme.headlineSmall,
                ),
                const SizedBox(height: 15),

                // Input Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: Dictionary.categoryName,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Tipe (Income / Expense)
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'income',
                      label: Text(Dictionary.income),
                    ),
                    ButtonSegment(
                      value: 'expense',
                      label: Text(Dictionary.expense),
                    ),
                  ],
                  selected: {selectedType.value},
                  onSelectionChanged: (Set<String> newSelection) {
                    selectedType.value = newSelection.first;
                  },
                ),
                const SizedBox(height: 15),

                //  Icon
                const Text(
                  Dictionary.categoryIcon,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: CategoryHelper.availableIcons.keys.map((iconKey) {
                    final isSelected = selectedIcon.value == iconKey;
                    return InkWell(
                      onTap: () => selectedIcon.value = iconKey,
                      child: CircleAvatar(
                        backgroundColor: isSelected
                            ? Colors.black
                            : Colors.grey.shade200,
                        child: Icon(
                          CategoryHelper.availableIcons[iconKey],
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),

                // Color
                const Text(
                  'Select Color',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: CategoryHelper.availableColors.map((color) {
                    final isSelected = selectedColor.value == color;
                    return InkWell(
                      onTap: () => selectedColor.value = color,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (nameController.text.isEmpty ||
                                selectedIcon.value.isEmpty) {
                              CustomNotification.showError(
                                Dictionary.formIsRequired,
                              );
                              return;
                            }
                            // Convert to hext
                            final hexColor = CategoryHelper.colorToHex(
                              selectedColor.value,
                            );

                            if (isEdit) {
                              // EDIT
                              controller.editCategory(
                                category,
                                newName: nameController.text.trim(),
                                type: selectedType.value,
                                newIcon: selectedIcon.value,
                                newColor: hexColor,
                              );
                            } else {
                              // CREATE
                              controller.addCategory(
                                name: nameController.text.trim(),
                                type: selectedType.value,
                                icon: selectedIcon.value,
                                color: hexColor,
                              );
                            }
                          },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isEdit ? Dictionary.updateBtn : Dictionary.saveBtn,
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // DIALOG DELETE
  void _confirmDelete(CategoryTransaction category) {
    Get.defaultDialog(
      title: Dictionary.deleteCategory,
      middleText: '${Dictionary.deleteCategoryDialog} - ${category.name}',
      textConfirm: Dictionary.deleteBtn,
      textCancel: Dictionary.cancelBtn,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.removeCategory(category);
      },
    );
  }
}
