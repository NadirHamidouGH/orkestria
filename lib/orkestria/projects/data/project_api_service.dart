import 'package:dio/dio.dart';
import 'package:orkestria/orkestria/projects/domain/entities/project.dart';
import 'package:orkestria/orkestria/projects/domain/repositories/project_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of the ProjectRepository using the API.
class ProjectDataSourceApi implements ProjectRepository {
  final Dio dio; // Dio instance for making API requests.

  ProjectDataSourceApi(this.dio); // Constructor to inject Dio.

  @override
  Future<List<Project>> fetchProjects() async {
    final sharedPreferences = await SharedPreferences.getInstance(); // Get shared preferences.
    final bearerToken = sharedPreferences.getString('authToken'); // Get auth token.

    if (bearerToken == null || bearerToken.isEmpty) {
      throw Exception('Authentication token is missing. Please log in again.'); // Throw exception if token is missing.
    }

    var headers = {
      'Authorization': 'Bearer $bearerToken', // Authorization header.
    };

    try {
      var response = await dio.get( // Make GET request.
        'https://ms.camapp.dev.fortest.store/projects/projects/',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) { // Check for successful response.
        List<dynamic> jsonData = response.data; // Extract JSON data.
        return jsonData.map((project) => Project.fromJson(project)).toList(); // Convert JSON to Project list.
      } else {
        throw Exception('Failed to load projects: ${response.statusMessage}'); // Throw exception if request fails.
      }
    } catch (e) {
      throw Exception('Error fetching projects: $e'); // Throw exception if error occurs. // NOTE: Consider more specific error handling.
    }
  }
}