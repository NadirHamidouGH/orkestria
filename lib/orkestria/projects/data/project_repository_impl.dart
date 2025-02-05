import 'package:orkestria/orkestria/projects/data/project_api_service.dart';
import 'package:orkestria/orkestria/projects/domain/entities/project.dart';
import 'package:orkestria/orkestria/projects/domain/repositories/project_repository.dart';

/// Implementation of the ProjectRepository interface.
class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDataSourceApi dataSource; // Data source for fetching projects.

  ProjectRepositoryImpl(this.dataSource); // Constructor to inject the data source.

  @override
  Future<List<Project>> fetchProjects() {
    return dataSource.fetchProjects(); // Call the data source to fetch projects. // NOTE: Consider adding error handling or data transformation here if needed.
  }
}