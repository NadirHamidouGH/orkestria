import 'package:orkestria/orkestria/projects/data/project_api_service.dart';
import 'package:orkestria/orkestria/projects/domain/entities/project.dart';
import 'package:orkestria/orkestria/projects/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDataSourceApi dataSource;

  ProjectRepositoryImpl(this.dataSource);

  @override
  Future<List<Project>> fetchProjects() {
    return dataSource.fetchProjects();
  }
}
