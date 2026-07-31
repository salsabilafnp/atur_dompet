import 'package:atur_dompet/core/models/category_transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // READ: Mengambil kategori berdasarkan tipenya (income/expense) (CAT-01, CAT-02)
  Future<List<CategoryTransaction>> getCategories(String type) async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .eq('type', type)
          .order('name', ascending: true);

      return response
          .map((data) => CategoryTransaction.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar kategori: $e');
    }
  }

  // Create Category (CAT-01, CAT-02)
  Future<void> createCategory({
    required String name,
    required String type,
    String? icon,
    String? color,
  }) async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      await _supabase.from('categories').insert({
        'user_id': userId,
        'name': name,
        'type': type,
        'icon': icon,
        'color': color,
      });
    } catch (e) {
      throw Exception('Gagal membuat kategori baru: $e');
    }
  }

  // Update Category (CAT-01, CAT-02)
  Future<void> updateCategory({
    required String categoryId,
    required String name,
    required String type,
    String? icon,
    String? color,
  }) async {
    try {
      await _supabase
          .from('categories')
          .update({
            'name': name,
            'type': type,
            'icon': icon,
            'color': color,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', categoryId);
    } catch (e) {
      throw Exception('Gagal memperbarui kategori: $e');
    }
  }

  // Delete Category (CAT-01, CAT-02)
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _supabase.from('categories').delete().eq('id', categoryId);
    } on PostgrestException catch (e) {
      // Catch specific PostgREST exception for foreign key constraint violation
      if (e.code == '23503') {
        throw Exception(
          'Kategori tidak bisa dihapus karena sedang digunakan pada transaksi.',
        );
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Gagal menghapus kategori: $e');
    }
  }
}
