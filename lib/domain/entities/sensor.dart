class Sensor {
  final String id;
  final String name;
  final String model;
  final String modelName;
  final String status;
  final String cardId;
  final String sensorTypeId;
  final double locationLat;
  final double locationLng;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime lastOnlineAt;

  Sensor({
    required this.id,
    required this.name,
    required this.model,
    required this.modelName,
    required this.status,
    required this.cardId,
    required this.sensorTypeId,
    required this.locationLat,
    required this.locationLng,
    required this.isOnline,
    required this.createdAt,
    required this.lastOnlineAt,
  });
}
