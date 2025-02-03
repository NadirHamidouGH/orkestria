import 'package:flutter/material.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class SensorsDetails extends StatefulWidget {
  const SensorsDetails({Key? key}) : super(key: key);

  @override
  _SensorsDetailsState createState() => _SensorsDetailsState();
}

class _SensorsDetailsState extends State<SensorsDetails> {
  late final GetDashboardStatsUseCase _getDashboardStatsUseCase;
  bool _isLoading = true;
  DashboardStats? _dashboardStats;
  int totalAlerts = 0;
  Map<String, int>? alertsMap;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDashboardStatsUseCase = Provider.of<GetDashboardStatsUseCase>(context);
    _fetchDashboardStats();
  }

  Future<void> _fetchDashboardStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await _getDashboardStatsUseCase();
      totalAlerts = stats.alertsBySensorType.fold<int>(0, (sum, alert) => sum + alert.alertCount);

      setState(() {
        _dashboardStats = stats;
        alertsMap = _convertAlertsToMap(stats.alertsBySensorType);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching stats: $e');
    }
  }

  Map<String, int> _convertAlertsToMap(List<AlertBySensorType> alerts) {
    return {for (var sensor in alerts) sensor.sensorType: sensor.alertCount};
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        final isDarkMode = themeController.isDarkMode;

        return Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: isDarkMode ? secondaryColor : secondaryColorLight,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const Text("Alerts by type", style: TextStyle(fontSize: 20),),
              const SizedBox(height: defaultPadding),
              if (alertsMap != null) Chart(alertsMap!),
              const SizedBox(height: defaultPadding),
              if (_dashboardStats?.alertsBySensorType != null) ...[
                for (var sensor in _dashboardStats!.alertsBySensorType)
                  StorageInfoCard(
                    svgSrc: "assets/icons/sensor.svg",
                    title: sensor.sensorType,
                    amountOfFiles: "${((sensor.alertCount / totalAlerts) * 100).toStringAsFixed(2)}%",
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
