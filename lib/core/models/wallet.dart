class Wallet {
  final String id;
  final String userId;
  final String name;
  final String type;
  final double balance;

  Wallet({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.balance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'type': type, 'balance': balance};
  }
}
