import 'package:atur_dompet/core/models/debt.dart';
import 'package:atur_dompet/core/models/debt_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DebtRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all debts (DEBT-01)
  Future<List<Debt>> getDebts(String type) async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      final response = await _supabase
          .from('debts')
          .select()
          .eq('user_id', userId)
          .eq('type', type) // 'borrow' atau 'lend'
          .order('status', ascending: false) // 'unpaid' di atas 'paid'
          .order('due_date', ascending: true); // Shortest due date at top

      return response.map((data) => Debt.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data: $e');
    }
  }

  // Get repayment logs (DEBT-03)
  Future<List<DebtLog>> getDebtLogs(String debtId) async {
    try {
      final response = await _supabase
          .from('debt_logs')
          .select('*, transactions(*, wallets!transactions_wallet_id_fkey(*))')
          .eq('debt_id', debtId)
          .order('payment_date', ascending: false);

      return response.map((data) => DebtLog.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil riwayat pembayaran: $e');
    }
  }

  // Create Debt (DEBT-01, DEBT-02)
  Future<void> createDebt({
    required String type,
    required String personName,
    required double amount,
    required DateTime dueDate,
    required String walletId, // Source fund
    String? note,
  }) async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      // 1. Insert to debts table
      await _supabase.from('debts').insert({
        'user_id': userId,
        'type': type,
        'person_name': personName,
        'initial_amount': amount,
        'remaining_amount': amount,
        'due_date': dueDate.toIso8601String(),
        'note': note,
      });

      // 2. Insert to transactions table (Trigger DB will automatically update wallet balance)
      await _supabase.from('transactions').insert({
        'user_id': userId,
        'wallet_id': walletId,
        'type': type == 'borrow' ? 'debt' : 'loan',
        'amount': amount,
        'note': note,
        'transaction_date': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Gagal mencatat data: $e');
    }
  }

  // Create Repayment (DEBT-03)
  Future<void> addRepayment({
    required String debtId,
    required String type, // Tipe induknya: 'borrow' atau 'lend'
    required String walletId,
    required double amount,
    required DateTime paymentDate,
    String? note,
  }) async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      // Logics
      // If repayment ('borrow'), tipe: 'expense'
      // Jika repayment ('lend'), tipe: 'income'
      final trxType = type == 'borrow' ? 'expense' : 'income';

      // 1. Insert to tabel transactions & return ID
      final trxResponse = await _supabase
          .from('transactions')
          .insert({
            'user_id': userId,
            'wallet_id': walletId,
            'type': trxType,
            'amount': amount,
            'note': note ?? 'Pembayaran untuk $type',
            'transaction_date': paymentDate.toIso8601String(),
          })
          .select('id')
          .single();

      final transactionId = trxResponse['id'] as String;

      // 2. Insert to debt_logs table
      // (Trigger trg_update_debt_on_repayment will reduce remaining_amount & update status 'paid')
      await _supabase.from('debt_logs').insert({
        'debt_id': debtId,
        'transaction_id': transactionId,
        'amount': amount,
        'payment_date': paymentDate.toIso8601String(),
        'note': note,
      });
    } catch (e) {
      throw Exception('Gagal mencatat pembayaran: $e');
    }
  }

  // Update Debt (DEBT-04)
  Future<void> updateDebt({
    required String debtId,
    required double amount,
    required DateTime dueDate,
    String? note,
  }) async {
    try {
      await _supabase
          .from('debts')
          .update({
            'remaining_amount': amount,
            'due_date': dueDate.toIso8601String(),
            'note': note,
          })
          .eq('id', debtId);
    } catch (e) {
      throw Exception('Gagal memperbarui data: $e');
    }
  }

  // Update Repayment Log (DEBT-04)
  Future<void> updateRepaymentLog({
    required String logId,
    required double amount,
    required DateTime paymentDate,
    String? note,
  }) async {
    try {
      await _supabase
          .from('debt_logs')
          .update({
            'amount': amount,
            'payment_date': paymentDate.toIso8601String(),
            'note': note,
          })
          .eq('id', logId);
    } catch (e) {
      throw Exception('Gagal memperbarui riwayat pembayaran: $e');
    }
  }

  // Delete Debt (DEBT-05)
  Future<void> deleteDebt(String debtId) async {
    try {
      // 1. Delete debt_logs first (Trigger will update remaining_amount & status)
      await _supabase.from('debt_logs').delete().eq('debt_id', debtId); //

      // 2. Delete debts
      await _supabase.from('debts').delete().eq('id', debtId);
    } catch (e) {
      throw Exception('Gagal menghapus data: $e');
    }
  }
}
