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
import 'package:orkestria/orkestria/dashboard/data/mock_dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:orkestria/orkestria/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';

MultiProvider setupProviders(Widget child) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://auth.corepulse.fr/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  return MultiProvider(
    providers: [
      // Provide the implementation of UserRepository
      Provider(
        create: (_) => UserRepositoryImpl(UserDataSourceApi()),
      ),
      // Provide the implementation of ProjectRepository
      Provider(
        create: (_) => ProjectRepositoryImpl(ProjectDataSourceApi(dio)),
      ),
      // Provide the Dio instance
      Provider(
        create: (_) => dio,
      ),
      // Provide the UseCase AuthenticateUseCase
      ProxyProvider2<UserRepositoryImpl, Dio, AuthenticateUseCase>(
        update: (_, repository, dio, __) =>
            AuthenticateUseCase(repository, dio),
      ),
      // Provide the UseCase FetchProjectsUseCase
      ProxyProvider2<ProjectRepositoryImpl, Dio, FetchProjectsUseCase>(
        update: (_, projectRepository, dio, __) =>
            FetchProjectsUseCase(projectRepository),
      ),
      // Provide the DashboardDataSourceApi
      Provider<DashboardDataSourceApi>(
        create: (_) => DashboardDataSourceApi(), // Use your mock data source
      ),
      // Provide the DashboardRepository
      ProxyProvider<DashboardDataSourceApi, DashboardRepository>(
        update: (_, dataSource, __) => DashboardRepositoryImpl(dataSource),
      ),
      // Provide the UseCase GetDashboardStatsUseCase
      ProxyProvider<DashboardRepository, GetDashboardStatsUseCase>(
        update: (_, dashboardRepository, __) =>
            GetDashboardStatsUseCase(dashboardRepository),
      ),
    ],
    child: child,
  );
}