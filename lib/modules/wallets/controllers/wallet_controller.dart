import 'package:atur_dompet/core/models/wallet.dart';
import 'package:atur_dompet/core/repositories/wallet_repository.dart';
import 'package:flutter/material.dart';

class WalletController extends ChangeNotifier {
  final WalletRepository _repository = WalletRepository();

  List<Wallet> _wallets = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Wallet> get wallets => _wallets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Update Total Balance (DASH-01)
  double get totalBalance {
    return _wallets.fold(0, (sum, wallet) => sum + wallet.balance);
  }

  // Fetch Wallets
  Future<void> fetchWallets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wallets = await _repository.getWallets();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add Wallet
  Future<bool> addWallet(String name, String type) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.createWallet(name: name, type: type);

      await fetchWallets();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update Wallet
  Future<bool> updateWallet(String walletId, String name, String type) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateWallet(walletId, name: name, type: type);

      await fetchWallets();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete Wallet
  Future<bool> removeWallet(String walletId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteWallet(walletId);

      await fetchWallets();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
