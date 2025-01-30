import 'package:flutter/material.dart';
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_dashboardStats == null) {
      return const Center(child: Text("No data available"));
    }

    final alertsBySensorType = _dashboardStats?.alertsBySensorType;

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alerts by type",
            style: subtitle1,
          ),
          const SizedBox(height: defaultPadding),
          if (alertsMap != null) Chart(alertsMap!),
          const SizedBox(height: defaultPadding),
          if (alertsBySensorType != null) ...[
            for (var sensor in alertsBySensorType)
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
  }
}
