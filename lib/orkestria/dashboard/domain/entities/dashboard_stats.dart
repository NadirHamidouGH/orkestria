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

  // Factory constructor to create the entity from JSON
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    var list = json['alerts_by_sensor_type'] as List;
    List<AlertBySensorType> alertsList = list.map((i) => AlertBySensorType.fromJson(i)).toList();

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

  // Method to convert the entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'projects': projects,
      'zones': zones,
      'cards': cards,
      'sensors': sensors,
      'cameras': cameras,
      'alerts': alerts,
      'camera_kpi': cameraKpi,
      'alerts_by_sensor_type': alertsBySensorType.map((e) => e.toJson()).toList(),
    };
  }
}

class AlertBySensorType {
  final int alertCount;
  final String sensorId;
  final String sensorType;

  AlertBySensorType({
    required this.alertCount,
    required this.sensorId,
    required this.sensorType,
  });

  // Factory constructor to create the object from JSON
  factory AlertBySensorType.fromJson(Map<String, dynamic> json) {
    return AlertBySensorType(
      alertCount: json['alert_count'] as int,
      sensorId: json['sensor_id'] as String,
      sensorType: json['sensor_type'] as String,
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'alert_count': alertCount,
      'sensor_id': sensorId,
      'sensor_type': sensorType,
    };
  }
}
