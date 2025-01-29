import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';
import 'package:orkestria/orkestria/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<DashboardStats> call() {
    return repository.fetchDashboardStats();
  }
}
