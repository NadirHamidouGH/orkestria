import 'package:flutter/material.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:orkestria/orkestria/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

/// Displays details about sensors and alerts.
class SensorsDetails extends StatefulWidget {
  const SensorsDetails({Key? key}) : super(key: key);

  @override
  _SensorsDetailsState createState() => _SensorsDetailsState();
}

class _SensorsDetailsState extends State<SensorsDetails> {
  late final GetDashboardStatsUseCase _getDashboardStatsUseCase; // Use case for fetching stats.
  bool _isLoading = true; // Loading state.
  DashboardStats? _dashboardStats; // Dashboard statistics data.
  int totalAlerts = 0; // Total number of alerts.
  Map<String, int>? alertsMap; // Map of alerts by sensor type.

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDashboardStatsUseCase = Provider.of<GetDashboardStatsUseCase>(context); // Get use case from Provider.
    _fetchDashboardStats(); // Fetch dashboard stats.
  }

  /// Fetches dashboard statistics.
  Future<void> _fetchDashboardStats() async {
    setState(() {
      _isLoading = true; // Set loading to true.
    });

    try {
      final stats = await _getDashboardStatsUseCase(); // Execute use case.
      totalAlerts = stats.alertsBySensorType.fold<int>(0, (sum, alert) => sum + alert.alertCount); // Calculate total alerts.

      setState(() {
        _dashboardStats = stats; // Store dashboard stats.
        alertsMap = _convertAlertsToMap(stats.alertsBySensorType); // Convert alerts to map.
        _isLoading = false; // Set loading to false.
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false even if error occurs.
      });
      print('Error fetching stats: $e'); // Log the error. // NOTE: Consider a more user-friendly error display.
    }
  }

  /// Converts a list of AlertBySensorType to a map.
  Map<String, int> _convertAlertsToMap(List<AlertBySensorType> alerts) {
    return {for (var sensor in alerts) sensor.sensorType: sensor.alertCount}; // Create the map.
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>( // Use Consumer to access ThemeController.
      builder: (context, themeController, child) {
        final isDarkMode = themeController.isDarkMode; // Get dark mode status.

        return Container( // Container for styling.
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: isDarkMode ? secondaryColor : secondaryColorLight,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Alerts by type", style: TextStyle(fontSize: 20)), // Title.
              const SizedBox(height: defaultPadding), // Spacing.
              if (alertsMap != null) Chart(alertsMap!), // Chart displaying alerts.
              const SizedBox(height: defaultPadding), // Spacing.
              if (_dashboardStats?.alertsBySensorType != null) ...[ // Display sensor info cards.
                for (var sensor in _dashboardStats!.alertsBySensorType)
                  StorageInfoCard(
                    svgSrc: "assets/icons/sensor.svg",
                    title: sensor.sensorType,
                    amountOfFiles: "${((sensor.alertCount / totalAlerts) * 100).toStringAsFixed(2)}%", // Calculate and format percentage.
                    numOfFiles: sensor.alertCount,
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}