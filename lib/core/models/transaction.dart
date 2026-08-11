class Transaction {
  final String id;
  final String userId;
  final String walletId;
  final String? destinationWalletId; // for transfer only
  final String? categoryId; // Nullable for transfer
  final String title;
  final String
  type; // TransactionType.income, TransactionType.expense, TransactionType.transfer, 'debt', 'loan'
  final double amount;
  final String? note;
  final DateTime transactionDate;

  // Fields from JOIN with Category table
  final String? categoryName;
  final String? categoryIcon;
  final String? categoryColor;

  Transaction({
    required this.id,
    required this.userId,
    required this.walletId,
    this.destinationWalletId,
    this.categoryId,
    required this.title,
    required this.type,
    required this.amount,
    this.note,
    required this.transactionDate,
    this.categoryName,
    this.categoryIcon,
    this.categoryColor,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final categoryData = json['categories'] as Map<String, dynamic>?;

    return Transaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      walletId: json['wallet_id'] as String,
      destinationWalletId: json['destination_wallet_id'] as String?,
      categoryId: json['category_id'] as String?,
      title: json['title'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String?,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      categoryName: categoryData?['name'] as String?,
      categoryIcon: categoryData?['icon'] as String?,
      categoryColor: categoryData?['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_id': walletId,
      'destination_wallet_id': destinationWalletId,
      'category_id': categoryId,
      'title': title,
      'type': type,
      'amount': amount,
      'note': note,
      'transaction_date': transactionDate.toIso8601String().split('T')[0],
    };
  }
}
