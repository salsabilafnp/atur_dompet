import 'package:atur_dompet/core/models/wallet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WalletRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get Wallets (WAL-01)
  Future<List<Wallet>> getWallets(String type) async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      final response = await _supabase
          .from('wallets')
          .select()
          .eq('user_id', userId)
          .eq('type', type)
          .order('name', ascending: true);

      return response.map((data) => Wallet.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data dompet: $e');
    }
  }

  // Create Wallet (WAL-01)
  Future<void> createWallet({
    required String name,
    required String type,
    double? balance,
    String? color,
  }) async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      await _supabase.from('wallets').insert({
        'user_id': userId,
        'name': name,
        'type': type,
        'balance': balance ?? 0.0,
        'color': color ?? '',
      });
    } catch (e) {
      throw Exception('Gagal membuat dompet baru: $e');
    }
  }

  // Update Wallet (WAL-01)
  Future<void> updateWallet(
    String walletId, {
    required String name,
    required String type,
    double? balance,
    String? color,
  }) async {
    try {
      await _supabase
          .from('wallets')
          .update({
            'name': name,
            'type': type,
            'balance': balance ?? 0.0,
            'color': color ?? '',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', walletId);
    } catch (e) {
      throw Exception('Gagal memperbarui dompet: $e');
    }
  }

  // Delete Wallet (WAL-01)
  Future<void> deleteWallet(String walletId) async {
    try {
      await _supabase.from('wallets').delete().eq('id', walletId);
    } on PostgrestException catch (e) {
      // Menangkap error ON DELETE RESTRICT dari database jika ada transaksi
      if (e.code == '23503') {
        throw Exception(
          'Dompet tidak bisa dihapus karena masih memiliki riwayat transaksi.',
        );
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Gagal menghapus dompet: $e');
    }
  }
}
