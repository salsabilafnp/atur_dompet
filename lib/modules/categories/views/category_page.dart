import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
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
                      controller,
                      controller.incomeCategories,
                      Dictionary.income,
                    ),
                    _buildCategoryList(
                      controller,
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
            onPressed: () {
              Get.snackbar(
                "FEATURE",
                "Add Category BottomSheet goes here",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black,
                colorText: Colors.white,
                borderRadius: 0,
              );
            },
          ),
        ),
      ),
    );
  }

  // BUILD LIST Category
  Widget _buildCategoryList(
    CategoryController controller,
    List<CategoryTransaction> categories,
    String type,
  ) {
    return Column(
      children: [
        // Add Category
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCategoryDialog(controller, type: type),
              child: Text(Dictionary.addCategory),
            ),
          ),
        ),

        // Category List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: ListTile(
                  title: Text(
                    cat.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: cat.isDefault
                      ? _buildStatusChip("DEFAULT")
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black),
                              onPressed: () => _showCategoryDialog(
                                controller,
                                type: type,
                                category: cat,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color(0xFFFF0000),
                              ),
                              onPressed: () =>
                                  _confirmDeleteDialog(controller, cat),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Label
  Widget _buildStatusChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // DIALOG Create/Update
  void _showCategoryDialog(
    CategoryController controller, {
    required String type,
    CategoryTransaction? category,
  }) {
    final nameCtrl = TextEditingController(text: category?.name ?? '');
    final isEdit = category != null;

    Get.dialog(
      Dialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 5),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEdit ? Dictionary.editCategory : Dictionary.addCategory,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(color: Colors.black, thickness: 3, height: 30),

              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: Dictionary.categoryName,
                ),
              ),
              const SizedBox(height: 24),

              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (nameCtrl.text.trim().isEmpty) return;
                          if (isEdit) {
                            controller.editCategory(
                              category,
                              newName: nameCtrl.text.trim(),
                            );
                          } else {
                            controller.addCategory(name: nameCtrl.text.trim());
                          }
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text("SIMPAN"),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text("BATAL"),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // DIALOG KONFIRMASI HAPUS (RawBlock Design)
  void _confirmDeleteDialog(
    CategoryController controller,
    CategoryTransaction category,
  ) {
    Get.dialog(
      Dialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 5),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "HAPUS Category?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Text(
                "Yakin ingin menghapus Category '${category.name}'?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text("BATAL"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFFF0000,
                        ), // RawBlock Destructive
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        controller.removeCategory(category);
                        Get.back();
                      },
                      child: const Text("HAPUS"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
