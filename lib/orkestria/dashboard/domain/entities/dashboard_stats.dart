class DashboardStats {
  final int sites;
  final int cameraKpi;
  final int bords;
  final int alerts;
  final int zones;
  final Map<String, int> alertsBySensorType;

  DashboardStats({
    required this.sites,
    required this.cameraKpi,
    required this.bords,
    required this.alerts,
    required this.zones,
    required this.alertsBySensorType,
  });

  // Factory constructor to create the entity from JSON
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      sites: json['sites'] as int,
      cameraKpi: json['camera_kpi'] as int,
      bords: json['bords'] as int,
      alerts: json['alerts'] as int,
      zones: json['zones'] as int,
      alertsBySensorType: Map<String, int>.from(json['alerts_by_sensor_type'] as Map),
    );
  }

  // Method to convert the entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'sites': sites,
      'camera_kpi': cameraKpi,
      'bords': bords,
      'alerts': alerts,
      'zones': zones,
      'alerts_by_sensor_type': alertsBySensorType,
    };
  }
}
