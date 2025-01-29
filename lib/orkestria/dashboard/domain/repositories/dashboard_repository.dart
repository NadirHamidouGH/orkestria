import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> fetchDashboardStats();
}
