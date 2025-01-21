import 'package:dio/dio.dart';
import 'package:orkestria/orkestria/projects/domain/entities/project.dart';
import 'package:orkestria/orkestria/projects/domain/repositories/project_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectDataSourceApi implements ProjectRepository {
  final Dio dio;

  ProjectDataSourceApi(this.dio);

  @override
  Future<List<Project>> fetchProjects() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final bearerToken = sharedPreferences.getString('authToken');
    var headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      var response = await dio.get(
        'https://ms.camapp.dev.fortest.store/projects/projects/',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((project) => Project.fromJson(project)).toList();
      } else {
        throw Exception('Failed to load projects: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching projects: $e');
    }
  }
}
