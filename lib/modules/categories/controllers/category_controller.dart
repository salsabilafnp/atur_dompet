import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/core/models/category_transaction.dart';
import 'package:atur_dompet/core/repositories/category_repository.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository = CategoryRepository();

  var incomeCategories = <CategoryTransaction>[].obs;
  var expenseCategories = <CategoryTransaction>[].obs;
  var isLoading = false.obs;

  // Tab State (0 = Income, 1 = Expense)
  var selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Fetch Categories
  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repository.getCategories('income'),
        _repository.getCategories('expense'),
      ]);

      incomeCategories.assignAll(results[0]);
      expenseCategories.assignAll(results[1]);
    } catch (e) {
      CustomNotification.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Add Category
  Future<void> addCategory({
    required String name,
    required String type,
    String? icon,
    String? color,
  }) async {
    if (name.trim().isEmpty) {
      CustomNotification.showError(Dictionary.formIsRequired);
      return;
    }

    try {
      isLoading.value = true;

      await _repository.createCategory(
        name: name.trim(),
        type: type,
        icon: icon,
        color: color,
      );

      await fetchCategories();
      Get.back();

      CustomNotification.showSuccess(Dictionary.succAddCategory);
    } catch (e) {
      CustomNotification.showError(Dictionary.failAddCategory);
    } finally {
      isLoading.value = false;
    }
  }

  // Update Category
  Future<bool> editCategory(
    CategoryTransaction category, {
    required String newName,
    required String type,
    String? newIcon,
    String? newColor,
  }) async {
    isLoading.value = true;
    try {
      await _repository.updateCategory(
        categoryId: category.id,
        name: newName,
        type: type,
        icon: newIcon,
        color: newColor,
      );

      await fetchCategories();
      Get.back();

      CustomNotification.showSuccess(Dictionary.succUpdateCategory);
      return true;
    } catch (e) {
      CustomNotification.showError(Dictionary.failUpdateCategory);

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Category
  Future<bool> removeCategory(CategoryTransaction category) async {
    isLoading.value = true;
    try {
      await _repository.deleteCategory(category.id);

      await fetchCategories();

      CustomNotification.showSuccess(Dictionary.succDelCategory);
      return true;
    } catch (e) {
      CustomNotification.showError(Dictionary.failDelCategory);

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
