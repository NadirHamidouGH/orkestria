import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final Map<String, int>? alertsBySensorType;

  const Chart(this.alertsBySensorType, {super.key});

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  String? selectedSensor;
  int? selectedSensorIndex;

  @override
  Widget build(BuildContext context) {
    int totalAlerts = widget.alertsBySensorType?.values.fold(0, (sum, value) => sum! + value) ?? 0;

    if (totalAlerts == 0) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text("No data available", style: TextStyle(fontSize: 16)),
        ),
      );
    }

    List<PieChartSectionData> pieChartSections = _generatePieChartSections(widget.alertsBySensorType, totalAlerts);

    // Sort the alertsBySensorType data by percentage before displaying in the text
    var sortedAlerts = _sortAlertsByPercentage(widget.alertsBySensorType, totalAlerts);

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: pieChartSections,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, PieTouchResponse? touchResponse) {
                  if (event is FlTapUpEvent && touchResponse != null) {
                    final touchedIndex = touchResponse.touchedSection?.touchedSectionIndex;
                    if (touchedIndex != null) {
                      setState(() {
                        selectedSensorIndex = touchedIndex;
                        selectedSensor = sortedAlerts.keys.elementAt(touchedIndex); // Use sortedAlerts
                      });
                    }
                  }
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  selectedSensor != null ? "$selectedSensor" : "Sensors",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (selectedSensor != null)
                  Text(
                    "Alerts: ${(sortedAlerts[selectedSensor]! / totalAlerts * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(fontSize: 14),
                  ),
                const Text("of 100%", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartSections(Map<String, int>? alertsBySensorType, int totalAlerts) {
    if (alertsBySensorType == null || totalAlerts == 0) return [];

    // Sort entries by percentage
    List<MapEntry<String, int>> sortedEntries = _sortAlertsByPercentage(alertsBySensorType, totalAlerts).entries.toList();

    // List of PieChart sections
    List<PieChartSectionData> sections = [];

    // Color palette
    List<Color> colorPalette = [
      Colors.red.shade800,
      Colors.red.shade500,
      Colors.orange.shade800,
      Colors.orange.shade600,
      Colors.orangeAccent,
      Colors.yellow,
      Colors.lightGreen,
      Colors.green.shade400,
      Colors.green.shade600,
      Colors.green.shade300,
    ];

    // Assign colors based on percentage
    for (int i = 0; i < sortedEntries.length; i++) {
      int count = sortedEntries[i].value;
      double percentage = (count / totalAlerts) * 100;
      Color sectionColor = colorPalette[i % colorPalette.length];

      // Check if the section is selected
      bool isSelected = selectedSensorIndex == i;

      sections.add(
        PieChartSectionData(
          color: sectionColor,
          value: percentage,
          showTitle: false,
          radius: isSelected ? 35 : 25,
          badgePositionPercentageOffset: 1.5,
          badgeWidget: null,
        ),
      );
    }

    return sections;
  }

  // Sort the alertsBySensorType by the percentage of alerts
  Map<String, int> _sortAlertsByPercentage(Map<String, int>? alertsBySensorType, int totalAlerts) {
    if (alertsBySensorType == null) return {};

    // Convert to list of entries and sort by percentage
    List<MapEntry<String, int>> sortedEntries = alertsBySensorType.entries.toList();
    sortedEntries.sort((a, b) {
      double percentageA = (a.value / totalAlerts) * 100;
      double percentageB = (b.value / totalAlerts) * 100;
      return percentageB.compareTo(percentageA);  // Sort in descending order
    });

    // Rebuild the sorted map
    Map<String, int> sortedAlerts = {};
    for (var entry in sortedEntries) {
      sortedAlerts[entry.key] = entry.value;
    }

    return sortedAlerts;
  }
}
