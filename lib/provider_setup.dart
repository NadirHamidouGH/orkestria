import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orkestria/data/datasources/user/user_datasource_api.dart';
import 'package:orkestria/data/repositories/user_repository_impl.dart';
import 'package:orkestria/domain/usecases/authenticate_usecase.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_repository_impl.dart';
import 'package:orkestria/orkestria/projects/data/project_api_service.dart';
import 'package:orkestria/orkestria/projects/data/project_repository_impl.dart';
import 'package:orkestria/orkestria/projects/domain/usecases/fetch_project_usecase.dart';
import 'package:provider/provider.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:orkestria/orkestria/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';

/// Sets up and provides dependencies using Provider.
/// This function initializes various services, repositories, and use cases
/// and makes them available throughout the application.
MultiProvider setupProviders(Widget child) {
  final dio = Dio( // Creates a Dio instance for making network requests.
    BaseOptions(
      baseUrl: 'https://auth.corepulse.fr/', // Base URL for the API.
      connectTimeout: const Duration(seconds: 5), // Connection timeout.
      receiveTimeout: const Duration(seconds: 3), // Receive timeout.
    ),
  );

  return MultiProvider( // Provides multiple dependencies to the widget tree.
    providers: [
      // Provides the UserRepository implementation.
      Provider<UserRepositoryImpl>(
        create: (_) => UserRepositoryImpl(UserDataSourceApi()), // Creates an instance of UserRepositoryImpl.
      ),
      // Provides the ProjectRepository implementation.
      Provider<ProjectRepositoryImpl>(
        create: (_) => ProjectRepositoryImpl(ProjectDataSourceApi(dio)), // Creates an instance of ProjectRepositoryImpl.
      ),
      // Provides the Dio instance for network requests.
      Provider<Dio>(
        create: (_) => dio, // Provides the pre-configured Dio instance.
      ),
      // Provides the AuthenticateUseCase.
      ProxyProvider2<UserRepositoryImpl, Dio, AuthenticateUseCase>(
        update: (_, repository, dio, __) =>
            AuthenticateUseCase(repository, dio), // Creates an instance of AuthenticateUseCase with dependencies.
      ),
      // Provides the FetchProjectsUseCase.
      ProxyProvider2<ProjectRepositoryImpl, Dio, FetchProjectsUseCase>(
        update: (_, projectRepository, dio, __) =>
            FetchProjectsUseCase(projectRepository), // Creates an instance of FetchProjectsUseCase.
      ),
      // Provides the DashboardDataSourceApi.  Consider using a mock or real implementation here.
      Provider<DashboardDataSourceApi>(
        create: (_) => DashboardDataSourceApi(), // Creates an instance of DashboardDataSourceApi.  Currently uses a basic implementation.
      ),
      // Provides the DashboardRepository implementation.
      ProxyProvider<DashboardDataSourceApi, DashboardRepository>(
        update: (_, dataSource, __) => DashboardRepositoryImpl(dataSource), // Creates an instance of DashboardRepositoryImpl.
      ),
      // Provides the GetDashboardStatsUseCase.
      ProxyProvider<DashboardRepository, GetDashboardStatsUseCase>(
        update: (_, dashboardRepository, __) =>
            GetDashboardStatsUseCase(dashboardRepository), // Creates an instance of GetDashboardStatsUseCase.
      ),
    ],
    child: child, // The child widget that will have access to the provided dependencies.
  );
}