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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar.standard(title: Dictionary.category),
        body: Column(
          children: [
            // TAB BAR
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 3),
                ),
              ),
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(color: Colors.black),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                tabs: [
                  Tab(text: Dictionary.income),
                  Tab(text: Dictionary.expense),
                ],
              ),
            ),

            // TAB VIEWS
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.incomeCategories.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }
                return TabBarView(
                  children: [
                    _buildCategoryList(
                      controller.incomeCategories,
                      Dictionary.income,
                    ),
                    _buildCategoryList(
                      controller.expenseCategories,
                      Dictionary.expense,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),

        // FAB
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.grey, offset: Offset(4, 4)),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () => _showCategoryDialog(context),
          ),
        ),
      ),
    );
  }

  // BUILD LIST Category
  Widget _buildCategoryList(List<CategoryTransaction> categories, String type) {
    if (categories.isEmpty) {
      return const Center(child: Text(Dictionary.noCategory));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final iconData = CategoryHelper.getIconData(category.icon);
        final color = CategoryHelper.hexToColor(category.color);

        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color.withAlpha(100),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Icon(iconData, color: color),
              ),
              title: Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(category),
              ),
              onTap: () => _showCategoryDialog(context, category: category),
            ),
          ),
        );
      },
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
                const SizedBox(height: 16),

                // Input Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: Dictionary.categoryName,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

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
                const SizedBox(height: 16),

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
                const SizedBox(height: 16),

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
      isScrollControlled: true, // Agar bottom sheet tidak terpotong keyboard
    );
  }

  // DIALOG KONFIRMASI HAPUS (RawBlock Design)
  void _confirmDelete(CategoryTransaction category) {
    Get.defaultDialog(
      title: 'Hapus Kategori?',
      middleText: '${Dictionary.deleteCategoryDialog} - ${category.name}',
      textConfirm: Dictionary.deleteCategoryBtn,
      textCancel: Dictionary.cancelBtn,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back(); // Tutup dialog
        controller.removeCategory(category);
      },
    );
  }
}
