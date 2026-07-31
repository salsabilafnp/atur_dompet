class DebtLog {
  final String id;
  final String debtId;
  final String transactionId;
  final double amount;
  final DateTime paymentDate;
  final String? note;

  DebtLog({
    required this.id,
    required this.debtId,
    required this.transactionId,
    required this.amount,
    required this.paymentDate,
    this.note,
  });

  factory DebtLog.fromJson(Map<String, dynamic> json) {
    return DebtLog(
      id: json['id'] as String,
      debtId: json['debt_id'] as String,
      transactionId: json['transaction_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['payment_date'] as String),
      note: json['note'] as String?,
    );
  }
}
