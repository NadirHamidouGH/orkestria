import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/projects/domain/entities/project.dart';
import 'package:orkestria/orkestria/projects/domain/usecases/fetch_project_usecase.dart';

class ProjectProvider extends ChangeNotifier {
  final FetchProjectsUseCase fetchProjectsUseCase;

  ProjectProvider(this.fetchProjectsUseCase);

  List<Project> _projects = [];
  List<Project> get projects => _projects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      _projects = await fetchProjectsUseCase.call();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load projects: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
