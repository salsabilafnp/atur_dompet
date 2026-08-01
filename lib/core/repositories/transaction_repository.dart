import 'package:atur_dompet/core/models/transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get All Transactions (TRX-04)
  Future<List<Transaction>> getTransactions() async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      final response = await _supabase
          .from('transactions')
          .select('''
*,
categories(id, name, icon, color),
wallet:wallets!transactions_wallet_id_fkey (*),
destination_wallet:wallets!transactions_destination_wallet_id_fkey (*)
            ''')
          .eq('user_id', userId)
          .order('transaction_date', ascending: false);

      return response.map((data) => Transaction.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil riwayat transaksi: $e');
    }
  }

  // Create Transaction - Income, Expense, Transfer (TRX-01, TRX-02, TRX-03)
  Future<void> recordTransaction({
    required String walletId,
    String? destinationWalletId,
    String? categoryId,
    required String type,
    required double amount,
    String? note,
    String? title,
    required DateTime date,
  }) async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      await _supabase.from('transactions').insert({
        'user_id': userId,
        'wallet_id': walletId,
        'destination_wallet_id': destinationWalletId,
        'category_id': categoryId,
        'type': type,
        'amount': amount,
        'note': note,
        'title': title,
        'transaction_date': date.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Gagal mencatat transaksi: $e');
    }
  }

  //  Update Transaction (TRX-05)
  Future<void> updateTransaction(
    String transactionId, {
    required String walletId,
    String? destinationWalletId,
    String? categoryId,
    required String type,
    required double amount,
    String? note,
    String? title,
    required DateTime date,
  }) async {
    try {
      await _supabase
          .from('transactions')
          .update({
            'wallet_id': walletId,
            'destination_wallet_id': destinationWalletId,
            'category_id': categoryId,
            'type': type,
            'amount': amount,
            'note': note,
            'title': title,
            'transaction_date': date.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', transactionId);
    } catch (e) {
      throw Exception('Gagal memperbarui transaksi: $e');
    }
  }

  // Delete Transaction (TRX-06)
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _supabase.from('transactions').delete().eq('id', transactionId);
    } catch (e) {
      throw Exception('Gagal menghapus transaksi: $e');
    }
  }
}
