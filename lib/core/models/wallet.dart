class Wallet {
  final String id;
  final String userId;
  final String name;
  final String type;
  final double balance;
  final double? pos;
  final String? color;

  Wallet({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.balance,
    this.pos = 0.0,
    this.color,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      balance: (json['balance'] as num).toDouble(),
      pos: (json['pos'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'balance': balance,
      'pos': pos,
      'color': color,
    };
  }
}
