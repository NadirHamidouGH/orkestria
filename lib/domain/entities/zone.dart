class Zone {
  final String id;
  final String hash;
  final String name;
  final bool hasAlerts;
  final DateTime insertedAt;
  final DateTime startedAt;
  final String projectId;
  final int camerasCount;
  final int sensorsCount;
  final int cardsCount;

  Zone({
    required this.id,
    required this.hash,
    required this.name,
    required this.hasAlerts,
    required this.insertedAt,
    required this.startedAt,
    required this.projectId,
    required this.camerasCount,
    required this.sensorsCount,
    required this.cardsCount,
  });
}
