import 'package:atur_dompet/core/models/debt.dart';
import 'package:atur_dompet/core/models/debt_log.dart';
import 'package:atur_dompet/core/repositories/debt_repository.dart';
import 'package:flutter/material.dart';

class DebtController extends ChangeNotifier {
  final DebtRepository _repository = DebtRepository();

  List<Debt> _borrowDebts = [];
  List<Debt> _lendLoans = [];
  List<DebtLog> _currentDebtLogs = [];

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Debt> get borrowDebts => _borrowDebts;
  List<Debt> get lendLoans => _lendLoans;
  List<DebtLog> get currentDebtLogs => _currentDebtLogs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch Debts & Loans (DEBT-01)
  Future<void> fetchAllDebts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getDebts('borrow'),
        _repository.getDebts('lend'),
      ]);

      _borrowDebts = results[0];
      _lendLoans = results[1];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch repayment logs (DEBT-03)
  Future<void> fetchDebtLogs(String debtId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentDebtLogs = await _repository.getDebtLogs(debtId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create Borrow (Debt) / Lend (Loan) (DEBT-01)
  Future<bool> addDebtRecord({
    required String type, // 'borrow' atau 'lend'
    required String personName,
    required double amount,
    required DateTime dueDate,
    required String walletId,
    String? note,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.createDebt(
        type: type,
        personName: personName,
        amount: amount,
        dueDate: dueDate,
        walletId: walletId,
        note: note,
      );

      await fetchAllDebts();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // Create Repayment Log (DEBT-03)
  Future<bool> payDebt({
    required Debt debt,
    required String walletId,
    required double amount,
    required DateTime paymentDate,
    String? note,
  }) async {
    // Validation: Check if the repayment amount exceeds the remaining debt
    if (amount > debt.remainingAmount) {
      _errorMessage =
          "Nominal pembayaran melebihi sisa tagihan (Sisa: Rp ${debt.remainingAmount})";
      notifyListeners();

      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.addRepayment(
        debtId: debt.id,
        type: debt.type,
        walletId: walletId,
        amount: amount,
        paymentDate: paymentDate,
        note: note,
      );

      await fetchAllDebts();
      await fetchDebtLogs(debt.id);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // Update Debt (DEBT-04)
  Future<bool> updateDebt({
    required Debt debt,
    required String personName,
    required double amount,
    required DateTime dueDate,
    String? note,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateDebt(
        debtId: debt.id,
        amount: amount,
        dueDate: dueDate,
        note: note,
      );

      await fetchAllDebts();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // Update Repayment Log (DEBT-05)
  Future<bool> updateRepayment({
    required DebtLog repayment,
    required double amount,
    required DateTime paymentDate,
    String? note,
  }) async {
    // Validation: Check if the updated repayment amount exceeds the remaining debt
    final debt = _borrowDebts.firstWhere(
      (d) => d.id == repayment.debtId,
      orElse: () => _lendLoans.firstWhere((d) => d.id == repayment.debtId),
    );
    final totalPaidExcludingCurrent =
        debt.initialAmount - debt.remainingAmount - repayment.amount;
    if (totalPaidExcludingCurrent + amount > debt.initialAmount) {
      _errorMessage =
          "Nominal pembayaran melebihi sisa tagihan (Sisa: Rp ${debt.initialAmount - totalPaidExcludingCurrent})";
      notifyListeners();

      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateRepaymentLog(
        logId: repayment.id,
        amount: amount,
        paymentDate: paymentDate,
        note: note,
      );

      await fetchAllDebts();
      await fetchDebtLogs(repayment.debtId);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // Delete Debt (DEBT-06)
  Future<bool> deleteDebt(String debtId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteDebt(debtId);

      await fetchAllDebts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }
}
