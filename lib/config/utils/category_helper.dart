import 'package:atur_dompet/config/utils/format_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryHelper {
  // 1. Icon Picker
  static final Map<String, IconData> availableIcons = {
    'others': Icons.category,
    // Expense
    'food': Icons.restaurant,
    'groceries': Icons.local_grocery_store,
    'transportation': Icons.directions_car,
    'shopping': Icons.shopping_bag,
    'home appliances': Icons.kitchen,
    'activity': Icons.local_activity,
    'bills': Icons.receipt,
    // Income
    'salary': Icons.attach_money,
    'freelance': Icons.work,
    'investment': Icons.trending_up,
    'gift': Icons.card_giftcard,
    // Transfer
    'money_off': Icons.money_off,
    'swap_horiz': Icons.swap_horiz,
    'savings': Icons.savings,
  };

  // 2. Predefined Color Picker
  static final List<Color> availableColors = [
    const Color.fromARGB(255, 244, 67, 54), // Red
    const Color.fromARGB(255, 255, 152, 0), // Orange
    const Color.fromARGB(255, 255, 235, 59), // Yellow
    const Color.fromARGB(255, 25, 179, 30), // Green
    const Color.fromARGB(255, 0, 150, 136), // Teal
    const Color.fromARGB(255, 33, 150, 243), // Blue
    const Color.fromARGB(255, 156, 39, 176), // Purple
    const Color.fromARGB(255, 121, 85, 72), // Brown
    const Color.fromARGB(255, 158, 158, 158), // Grey
    const Color.fromARGB(255, 0, 0, 0), // Black
    const Color.fromARGB(255, 255, 255, 255), // White
  ];

  // 3. Convert to Hex
  static String colorToHex(Color color) {
    // toARGB32() (AARRGGBB)
    final int argb = color.toARGB32();
    // RGB (hilangkan Alpha)
    final int rgb = argb & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  // 4. Convert Hex to Color
  static Color hexToColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return Colors.grey;

    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('FF'); // Tambahkan Alpha 255 (Opaque)
      buffer.write(hexString.replaceFirst('#', ''));
    }

    int val = int.parse(buffer.toString(), radix: 16);

    // bitwise
    return Color.fromARGB(
      (val >> 24) & 0xFF, // Alpha
      (val >> 16) & 0xFF, // Red
      (val >> 8) & 0xFF, // Green
      val & 0xFF, // Blue
    );
  }

  static IconData getIconData(String? iconName) {
    return availableIcons[iconName] ?? Icons.category;
  }
}

// Graphic Item
class CategoryChartItem {
  final String categoryName;
  final int percentage; // Dalam persen, misal 50
  double amount;
  final Color segmentColor;

  CategoryChartItem({
    required this.categoryName,
    required this.percentage,
    this.amount = 0.0,
    required this.segmentColor,
  });
}

// Show Detail Data
void showChartDetailSheet(CategoryChartItem data) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: data.segmentColor,
                  border: Border.all(color: Colors.black, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  data.categoryName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${data.percentage}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black, thickness: 2, height: 30),

          // Nominal per category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.categoryName.toUpperCase(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                FormatHelper.currencyFormatter.format(data.amount),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
