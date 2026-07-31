// file: debt_model.dart
class Debt {
  final String id;
  final String userId;
  final String type; // 'borrow' (Hutang) atau 'lend' (Piutang)
  final String personName;
  final double initialAmount;
  final double remainingAmount;
  final DateTime dueDate;
  final String status; // 'unpaid' atau 'paid'
  final String? note;

  Debt({
    required this.id,
    required this.userId,
    required this.type,
    required this.personName,
    required this.initialAmount,
    required this.remainingAmount,
    required this.dueDate,
    required this.status,
    this.note,
  });

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      personName: json['person_name'] as String,
      initialAmount: (json['initial_amount'] as num).toDouble(),
      remainingAmount: (json['remaining_amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['due_date'] as String),
      status: json['status'] as String,
      note: json['note'] as String?,
    );
  }
}
