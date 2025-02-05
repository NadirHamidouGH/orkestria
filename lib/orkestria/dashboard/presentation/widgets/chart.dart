import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// A widget displaying a pie chart of alerts by sensor type.
class Chart extends StatefulWidget {
  final Map<String, int>? alertsBySensorType; // Data for the chart.

  const Chart(this.alertsBySensorType, {super.key});

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  String? selectedSensor; // Currently selected sensor.
  int? selectedSensorIndex; // Index of the selected sensor.

  @override
  Widget build(BuildContext context) {
    // Calculate the total number of alerts.
    int totalAlerts = widget.alertsBySensorType?.values.fold(0, (sum, value) => sum! + value) ?? 0;

    // Display a message if no data is available.
    if (totalAlerts == 0) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text("No data available", style: TextStyle(fontSize: 16)),
        ),
      );
    }

    // Generate the pie chart sections data.
    List<PieChartSectionData> pieChartSections = _generatePieChartSections(widget.alertsBySensorType, totalAlerts);

    // Sort the alerts by percentage for display.
    var sortedAlerts = _sortAlertsByPercentage(widget.alertsBySensorType, totalAlerts);

    return SizedBox(
      height: 200,
      child: Stack( // Use a Stack to overlay text on the chart.
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: pieChartSections,
              pieTouchData: PieTouchData( // Handle tap events on the chart.
                touchCallback: (FlTouchEvent event, PieTouchResponse? touchResponse) {
                  if (event is FlTapUpEvent && touchResponse != null) {
                    final touchedIndex = touchResponse.touchedSection?.touchedSectionIndex;
                    if (touchedIndex != null) {
                      setState(() {
                        selectedSensorIndex = touchedIndex;
                        selectedSensor = sortedAlerts.keys.elementAt(touchedIndex); // Update selected sensor.
                      });
                    }
                  }
                },
              ),
            ),
          ),
          Positioned.fill( // Position the text in the center of the chart.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  selectedSensor != null ? "$selectedSensor" : "Sensors", // Display selected sensor or "Sensors".
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (selectedSensor != null) // Display percentage for selected sensor.
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

  /// Generates the pie chart section data.
  List<PieChartSectionData> _generatePieChartSections(Map<String, int>? alertsBySensorType, int totalAlerts) {
    if (alertsBySensorType == null || totalAlerts == 0) return []; // Return empty list if no data.

    List<MapEntry<String, int>> sortedEntries = _sortAlertsByPercentage(alertsBySensorType, totalAlerts).entries.toList(); // Sort entries by percentage.
    List<PieChartSectionData> sections = []; // List to hold the pie chart sections.
    List<Color> colorPalette = [ // Color palette for the chart sections.
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

    for (int i = 0; i < sortedEntries.length; i++) { // Create a section for each entry.
      int count = sortedEntries[i].value;
      double percentage = (count / totalAlerts) * 100;
      Color sectionColor = colorPalette[i % colorPalette.length]; // Assign color from palette.
      bool isSelected = selectedSensorIndex == i; // Check if the section is selected.

      sections.add(
        PieChartSectionData(
          color: sectionColor,
          value: percentage,
          showTitle: false,
          radius: isSelected ? 35 : 25, // Adjust radius for selected section.
          badgePositionPercentageOffset: 1.5,
          badgeWidget: null,
        ),
      );
    }

    return sections;
  }

  /// Sorts the alerts by percentage.
  Map<String, int> _sortAlertsByPercentage(Map<String, int>? alertsBySensorType, int totalAlerts) {
    if (alertsBySensorType == null) return {}; // Return empty map if no data.

    List<MapEntry<String, int>> sortedEntries = alertsBySensorType.entries.toList();
    sortedEntries.sort((a, b) {
      double percentageA = (a.value / totalAlerts) * 100;
      double percentageB = (b.value / totalAlerts) * 100;
      return percentageB.compareTo(percentageA); // Sort in descending order.
    });

    Map<String, int> sortedAlerts = {}; // Create a new map with sorted entries.
    for (var entry in sortedEntries) {
      sortedAlerts[entry.key] = entry.value;
    }

    return sortedAlerts;
  }
}