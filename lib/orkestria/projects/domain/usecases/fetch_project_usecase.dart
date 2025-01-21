import '../entities/project.dart';
import '../repositories/project_repository.dart';

class FetchProjectsUseCase {
  final ProjectRepository repository;

  FetchProjectsUseCase(this.repository);

  Future<List<Project>> call() async {
    return await repository.fetchProjects();
  }
}
