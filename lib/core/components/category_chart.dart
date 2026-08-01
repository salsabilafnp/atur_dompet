// Graphic Chart
import 'package:atur_dompet/config/utils/category_helper.dart';
import 'package:flutter/material.dart';

class CategoryDistributionChart extends StatelessWidget {
  final String title;
  final List<CategoryChartItem> dataItems;

  const CategoryDistributionChart({
    super.key,
    required this.title,
    required this.dataItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),

        // Graphic Bar Stacked
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Row(
            children: dataItems.map((item) {
              return Expanded(
                flex: item.percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: item.segmentColor,
                    // Divider
                    border: Border(
                      right: dataItems.indexOf(item) != dataItems.length - 1
                          ? const BorderSide(color: Colors.black, width: 1)
                          : BorderSide.none,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${item.percentage}%',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 10),

        // Legend
        Wrap(
          spacing: 10,
          runSpacing: 5,
          children: dataItems.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Color Box
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: item.segmentColor,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                ),
                const SizedBox(width: 6),
                // Category Name
                Text(
                  item.categoryName.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
