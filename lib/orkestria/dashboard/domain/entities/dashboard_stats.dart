/// Represents dashboard statistics.
class DashboardStats {
  final int projects;
  final int zones;
  final int cards;
  final int sensors;
  final int cameras;
  final int alerts;
  final int cameraKpi;
  final List<AlertBySensorType> alertsBySensorType;

  DashboardStats({
    required this.projects,
    required this.zones,
    required this.cards,
    required this.sensors,
    required this.cameras,
    required this.alerts,
    required this.cameraKpi,
    required this.alertsBySensorType,
  });

  /// Creates a DashboardStats instance from a JSON map.
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    var list = json['alerts_by_sensor_type'] as List; // Get the list of alerts by sensor type.
    List<AlertBySensorType> alertsList = list.map((i) => AlertBySensorType.fromJson(i)).toList(); // Convert each item in the list to an AlertBySensorType object.

    return DashboardStats(
      projects: json['projects'] as int,
      zones: json['zones'] as int,
      cards: json['cards'] as int,
      sensors: json['sensors'] as int,
      cameras: json['cameras'] as int,
      alerts: json['alerts'] as int,
      cameraKpi: json['camera_kpi'] as int,
      alertsBySensorType: alertsList,
    );
  }

  /// Converts a DashboardStats instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'projects': projects,
      'zones': zones,
      'cards': cards,
      'sensors': sensors,
      'cameras': cameras,
      'alerts': alerts,
      'camera_kpi': cameraKpi,
      'alerts_by_sensor_type': alertsBySensorType.map((e) => e.toJson()).toList(), // Convert each AlertBySensorType object to JSON.
    };
  }
}

/// Represents alert counts by sensor type.
class AlertBySensorType {
  final int alertCount;
  final String sensorId;
  final String sensorType;

  AlertBySensorType({
    required this.alertCount,
    required this.sensorId,
    required this.sensorType,
  });

  /// Creates an AlertBySensorType instance from a JSON map.
  factory AlertBySensorType.fromJson(Map<String, dynamic> json) {
    return AlertBySensorType(
      alertCount: json['alert_count'] as int,
      sensorId: json['sensor_id'] as String,
      sensorType: json['sensor_type'] as String,
    );
  }

  /// Converts an AlertBySensorType instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'alert_count': alertCount,
      'sensor_id': sensorId,
      'sensor_type': sensorType,
    };
  }
}