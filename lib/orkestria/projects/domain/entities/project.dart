class Project {
  final String id;
  final String? hash;
  final String name;
  final bool hasAlerts;
  final String? status;
  final DateTime insertedAt;
  final DateTime startedAt;
  final DateTime updatedAt;
  final int camerasCount;
  final int sensorsCount;
  final int cardsCount;
  final int zonesCount;

  Project({
    required this.id,
    required this.hash,
    required this.name,
    required this.hasAlerts,
    required this.status,
    required this.insertedAt,
    required this.startedAt,
    required this.updatedAt,
    required this.camerasCount,
    required this.sensorsCount,
    required this.cardsCount,
    required this.zonesCount,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      hash: json['hash'] as String?,
      name: json['name'] as String,
      hasAlerts: json['hasAlerts'] as bool,
      status: json['status'] as String?,
      insertedAt: DateTime.parse(json['insertedAt'] as String),
      startedAt: DateTime.parse(json['startedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      camerasCount: json['camerasCount'] as int,
      sensorsCount: json['sensorsCount'] as int,
      cardsCount: json['cardsCount'] as int,
      zonesCount: json['zonesCount'] as int,
    );
  }
}
