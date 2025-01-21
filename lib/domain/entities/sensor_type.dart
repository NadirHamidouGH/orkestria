class SensorType {
  final String id;
  final String name;
  final String unit;
  final double maxValue;
  final double minValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  SensorType({
    required this.id,
    required this.name,
    required this.unit,
    required this.maxValue,
    required this.minValue,
    required this.createdAt,
    required this.updatedAt,
  });
}
