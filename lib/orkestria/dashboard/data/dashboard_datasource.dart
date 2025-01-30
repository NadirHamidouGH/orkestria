import 'package:dio/dio.dart';
import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardDataSourceApi {
  final Dio dio = Dio();

  // Method to fetch the stats from the API
  Future<DashboardStats> fetchStats() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final authToken = sharedPreferences.getString('authToken');
      var headers = {
        'Authorization': 'Bearer $authToken',
      };

      var response = await dio.request(
        'https://ms.camapp.dev.fortest.store/projects/dashboard/',
        options: Options(
          method: 'GET',
          headers: headers
        ),
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
