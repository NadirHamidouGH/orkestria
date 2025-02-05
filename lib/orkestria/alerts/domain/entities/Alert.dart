/// Represents an alert.
class Alert {
  final int id;
  final String alertType;
  final String message;
  final double value;
  final double threshold;
  final String sensorId;
  final String status;
  final String createdAt; // NOTE: Consider using a DateTime object instead of a String for createdAt.

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

  /// Creates an Alert instance from a JSON map.
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as int,
      alertType: json['alert_type'] as String,
      message: json['message'] as String,
      value: (json['value'] as num).toDouble(), // Explicitly cast to double.
      threshold: (json['threshold'] as num).toDouble(), // Explicitly cast to double.
      sensorId: json['sensor_id'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String, // NOTE:  If you switch to DateTime, parse the string here.
    );
  }

  /// Converts an Alert instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alert_type': alertType,
      'message': message,
      'value': value,
      'threshold': threshold,
      'sensor_id': sensorId,
      'status': status,
      'created_at': createdAt, // NOTE: If you use DateTime, format it to a String here.
    };
  }
}