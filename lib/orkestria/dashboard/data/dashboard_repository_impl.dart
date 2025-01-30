import 'package:orkestria/orkestria/dashboard/data/dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/domain/repositories/dashboard_repository.dart';
import '../domain/entities/dashboard_stats.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSourceApi dataSource;

  DashboardRepositoryImpl(this.dataSource);

  @override
  Future<DashboardStats> fetchDashboardStats() async {
    // Fetch data from the data source
    final dashboardStats = await dataSource.fetchStats();

    // Return the fetched DashboardStats object directly
    return dashboardStats;
  }
}
