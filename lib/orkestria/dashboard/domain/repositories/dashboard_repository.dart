import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';

/// Abstract class defining the interface for dashboard repository operations.
abstract class DashboardRepository {
  /// Fetches dashboard statistics.
  Future<DashboardStats> fetchDashboardStats();
}