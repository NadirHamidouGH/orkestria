import 'package:orkestria/orkestria/dashboard/data/mock_dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/domain/repositories/dashboard_repository.dart';
import '../domain/entities/dashboard_stats.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSourceApi dataSource;

  DashboardRepositoryImpl(this.dataSource);

  @override
  Future<DashboardStats> fetchDashboardStats() async {
    final data = await dataSource.fetchStats();
    return DashboardStats(
      sites: data['sites'],
      cameraKpi: data['camera_kpi'],
      bords: data['bords'],
      alerts: data['alerts'],
      zones: data['zones'],
      alertsBySensorType: Map<String, int>.from(data['alerts_by_sensor_type']),
    );
  }
}
