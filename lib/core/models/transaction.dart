class Transaction {
  final String id;
  final String userId;
  final String walletId;
  final String? destinationWalletId; // for transfer only
  final String? categoryId; // Nullable for transfer
  final String type; // 'income', 'expense', 'transfer', 'debt', 'loan'
  final double amount;
  final String? note;
  final DateTime transactionDate;

  Transaction({
    required this.id,
    required this.userId,
    required this.walletId,
    this.destinationWalletId,
    this.categoryId,
    required this.type,
    required this.amount,
    this.note,
    required this.transactionDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      walletId: json['wallet_id'] as String,
      destinationWalletId: json['destination_wallet_id'] as String?,
      categoryId: json['category_id'] as String?,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String?,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_id': walletId,
      'destination_wallet_id': destinationWalletId,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'note': note,
      'transaction_date': transactionDate.toIso8601String(),
    };
  }
}
