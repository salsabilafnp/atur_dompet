class WalletType {
  static const String main = 'main';
  static const String savings = 'savings';
}

class TransactionType {
  static const String income = 'income';
  static const String expense = 'expense';
  static const String transfer = 'transfer';
  static const String loan = 'loan';
  static const String debt = 'debt';
}

class DebtType {
  static const String borrow = 'borrow';
  static const String lend = 'lend';
}

class FilterRange {
  static const String today = 'today';
  static const String thisWeek = 'thisWeek';
  static const String thisMonth = 'thisMonth';
  static const String allTime = 'allTime';
  static const String custom = 'custom';
}
