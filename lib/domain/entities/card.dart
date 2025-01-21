class Card {
  final String id;
  final String name;
  final String description;
  final double locationLat;
  final double locationLng;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sensorsCount;
  final String zoneId;

  Card({
    required this.id,
    required this.name,
    required this.description,
    required this.locationLat,
    required this.locationLng,
    required this.createdAt,
    required this.updatedAt,
    required this.sensorsCount,
    required this.zoneId,
  });
}
