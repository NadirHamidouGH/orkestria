class SensorData {
  final String id;
  final String sensorId;
  final String unit;
  final String type;
  final double value;
  final DateTime insertedAt;

  SensorData({
    required this.id,
    required this.sensorId,
    required this.unit,
    required this.type,
    required this.value,
    required this.insertedAt,
  });
}
