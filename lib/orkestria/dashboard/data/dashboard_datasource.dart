import 'package:dio/dio.dart'; // NOTE: Consider injecting Dio instance.
import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Data source for fetching dashboard statistics from the API.
class DashboardDataSourceApi {
  final Dio dio = Dio(); // NOTE: Consider injecting Dio instance for better testability.

  /// Fetches dashboard statistics.
  Future<DashboardStats> fetchStats() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final authToken = sharedPreferences.getString('authToken');

      if (authToken == null || authToken.isEmpty) { // Check for null or empty token.
        throw Exception('Authentication token is missing. Please log in again.');
      }

      var headers = {
        'Authorization': 'Bearer $authToken',
      };

      var response = await dio.get( // Use dio.get for simplicity.
        'https://ms.camapp.dev.fortest.store/projects/dashboard/',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        return DashboardStats.fromJson(data);
      } else {
        throw Exception('Failed to load stats: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching stats: $e');
    }
  }
}