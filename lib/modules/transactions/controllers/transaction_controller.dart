import 'package:atur_dompet/core/models/transaction.dart';
import 'package:atur_dompet/core/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';

class TransactionController extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get Transactions (TRX-04)
  Future<void> fetchTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _repository.getTransactions();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Record Expense (TRX-02)
  Future<bool> addExpense({
    required String walletId,
    required String categoryId,
    required double amount,
    String? note,
    required DateTime date,
  }) async {
    return _executeTransaction(
      walletId: walletId,
      categoryId: categoryId,
      type: 'expense',
      amount: amount,
      note: note,
      date: date,
    );
  }

  // Record Income (TRX-01)
  Future<bool> addIncome({
    required String walletId,
    required String categoryId,
    required double amount,
    String? note,
    required DateTime date,
  }) async {
    return _executeTransaction(
      walletId: walletId,
      categoryId: categoryId,
      type: 'income',
      amount: amount,
      note: note,
      date: date,
    );
  }

  // Transfer Balance (TRX-03)
  Future<bool> addTransfer({
    required String sourceWalletId,
    required String destinationWalletId,
    required double amount,
    String? note,
    required DateTime date,
  }) async {
    if (sourceWalletId == destinationWalletId) {
      _errorMessage = "Dompet asal dan tujuan tidak boleh sama.";
      notifyListeners();
      return false;
    }

    return _executeTransaction(
      walletId: sourceWalletId,
      destinationWalletId: destinationWalletId,
      type: 'transfer',
      amount: amount,
      note: note,
      date: date,
    );
  }

  // Helper: insert transaction data
  Future<bool> _executeTransaction({
    required String walletId,
    String? destinationWalletId,
    String? categoryId,
    required String type,
    required double amount,
    String? note,
    required DateTime date,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.recordTransaction(
        walletId: walletId,
        destinationWalletId: destinationWalletId,
        categoryId: categoryId,
        type: type,
        amount: amount,
        note: note,
        date: date,
      );

      await fetchTransactions();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // Update Transaction (TRX-05)
  Future<bool> updateTransaction({
    required String transactionId,
    required String walletId,
    String? destinationWalletId,
    String? categoryId,
    required String type,
    required double amount,
    String? note,
    required DateTime date,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateTransaction(
        transactionId,
        walletId: walletId,
        destinationWalletId: destinationWalletId,
        categoryId: categoryId,
        type: type,
        amount: amount,
        note: note,
        date: date,
      );

      await fetchTransactions();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // Delete Transaction (TRX-06)
  Future<bool> deleteTransaction(String transactionId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteTransaction(transactionId);

      await fetchTransactions();
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }
}
