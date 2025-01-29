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
  int totalSensors = 0;

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
      var alertsBySensorType = stats.alertsBySensorType;
      for(var alert in alertsBySensorType.values){
            totalSensors += alert;
      }
      setState(() {
        _dashboardStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      print('Error fetching stats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: SizedBox());
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
          Chart(alertsBySensorType),
          if (alertsBySensorType != null) ...[
            for (var sensorType in alertsBySensorType.entries)
              StorageInfoCard(
                svgSrc: "assets/icons/sensor.svg",
                title: sensorType.key,
                amountOfFiles: "${((sensorType.value/totalSensors) * 100).toStringAsFixed(2)}%",
                numOfFiles: sensorType.value,
              ),
          ],
        ],
      ),
    );
  }
}
