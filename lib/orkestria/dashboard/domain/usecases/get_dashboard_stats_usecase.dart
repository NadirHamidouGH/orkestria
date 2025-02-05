import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';
import 'package:orkestria/orkestria/dashboard/domain/repositories/dashboard_repository.dart';

/// Use case for retrieving dashboard statistics.
class GetDashboardStatsUseCase {
  final DashboardRepository repository; // Repository for dashboard data.

  GetDashboardStatsUseCase(this.repository);

  /// Executes the use case to fetch dashboard statistics.
  Future<DashboardStats> call() {
    return repository.fetchDashboardStats(); // Delegates to the repository.
  }
}