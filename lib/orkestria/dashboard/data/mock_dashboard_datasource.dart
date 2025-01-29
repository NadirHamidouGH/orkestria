import 'dart:async';

class DashboardDataSourceApi {
  final Map<String, dynamic> mockApiResponse = {
    "sites": 5,
    "camera_kpi": 320,
    "bords": 2,
    "alerts": 50,
    "zones": 4,
    "alerts_by_sensor_type": {
      "gaz": 20,
      "altitude": 15,
      "temperature": 5,
      "humidity": 9,
      "capteur 5": 15,
      "capteur 6": 24,
      "humidity 7": 18,
      "capteur 8": 12,
      "capteur 9": 30,
    }
  };

  Future<Map<String, dynamic>> fetchStats() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return mockApiResponse;
  }
}
