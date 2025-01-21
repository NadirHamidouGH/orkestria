class Camera {
  final String name;
  final String zoneId;
  final bool adjustableCoverage;
  final String description;
  final bool isOnline;
  final String? lastOnlineAt;
  final double locationLat;
  final double locationLng;
  final String model;
  final String status;
  final String thumbnailUrl;
  final String id;

  Camera({
    required this.name,
    required this.zoneId,
    required this.adjustableCoverage,
    required this.description,
    required this.isOnline,
    this.lastOnlineAt,
    required this.locationLat,
    required this.locationLng,
    required this.model,
    required this.status,
    required this.thumbnailUrl,
    required this.id,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      name: json['name'],
      zoneId: json['zoneId'],
      adjustableCoverage: json['adjustableCoverage'],
      description: json['description'],
      isOnline: json['isOnline'],
      lastOnlineAt: json['lastOnlineAt'],
      locationLat: json['location_lat'],
      locationLng: json['location_lng'],
      model: json['model'],
      status: json['status'],
      thumbnailUrl: json['thumbnailUrl'],
      id: json['id'],
    );
  }
}
