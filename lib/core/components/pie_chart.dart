// Sesuaikan import ini dengan lokasi model CategoryChartItem kamu
import 'package:atur_dompet/config/utils/category_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PieChartDistribution extends StatelessWidget {
  final String title;
  final List<CategoryChartItem> dataItems;

  const PieChartDistribution({
    super.key,
    required this.title,
    required this.dataItems,
  });

  @override
  Widget build(BuildContext context) {
    if (dataItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),

        // Pie Chart
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 1,
              centerSpaceRadius: 10,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    return;
                  }

                  final touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;

                  if (touchedIndex >= 0 && event is FlTapDownEvent) {
                    if (Get.isBottomSheetOpen == true) return;
                    showChartDetailSheet(dataItems[touchedIndex]);
                  }
                },
              ),
              sections: dataItems.map((data) {
                return PieChartSectionData(
                  color: data.segmentColor,
                  value: data.percentage.toDouble(),
                  title: '${data.percentage}%',
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Legend
        Wrap(
          spacing: 10,
          runSpacing: 5,
          children: dataItems.map((item) {
            return InkWell(
              onTap: () => showChartDetailSheet(item),
              child: Row(
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
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
