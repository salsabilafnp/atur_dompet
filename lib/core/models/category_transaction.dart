class CategoryTransaction {
  final String id;
  final String userId;
  final String name;
  final String type; // 'income' atau 'expense'
  final String? icon;
  final String? color;

  CategoryTransaction({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.icon,
    this.color,
  });

  factory CategoryTransaction.fromJson(Map<String, dynamic> json) {
    return CategoryTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'type': type, 'icon': icon, 'color': color};
  }
}
