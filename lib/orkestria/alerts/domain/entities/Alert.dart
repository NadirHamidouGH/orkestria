class Alert {
  final int id;
  final String alertType;
  final String message;
  final double value;
  final double threshold;
  final String sensorId;
  final String status;
  final String createdAt;

  Alert({
    required this.id,
    required this.alertType,
    required this.message,
    required this.value,
    required this.threshold,
    required this.sensorId,
    required this.status,
    required this.createdAt,
  });

  // Méthode pour créer une instance à partir d'un JSON
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as int,
      alertType: json['alert_type'] as String,
      message: json['message'] as String,
      value: (json['value'] as num).toDouble(),
      threshold: (json['threshold'] as num).toDouble(),
      sensorId: json['sensor_id'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  // Méthode pour convertir une instance en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alert_type': alertType,
      'message': message,
      'value': value,
      'threshold': threshold,
      'sensor_id': sensorId,
      'status': status,
      'created_at': createdAt,
    };
  }
}
