import 'dart:convert';

class Records {
  final String id;
  final String objectClass;
  final String boundingBox;
  final String imagePath;
  final String cameraId;
  final double confidence;
  final DateTime capturedAt;
  final DateTime? insertedAt;
  final dynamic metaData;

  Records({
    required this.id,
    required this.objectClass,
    required this.boundingBox,
    required this.imagePath,
    required this.cameraId,
    required this.confidence,
    required this.capturedAt,
    this.insertedAt,
    this.metaData,
  });

  // Méthode pour créer une instance à partir d'un JSON
  factory Records.fromJson(Map<String, dynamic> json) {
    return Records(
      id: json['id'] as String,
      objectClass: json['object_class'] as String,
      boundingBox: json['bounding_box'] as String,
      imagePath: json['image_path'] as String,
      cameraId: json['camera_id'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      capturedAt: DateTime.parse(json['captured_at'] as String),
      insertedAt: json['insertedAt'] != null ? DateTime.parse(json['insertedAt'] as String) : null,
      metaData: json['meta_data'],
    );
  }

  // Méthode pour convertir une instance en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object_class': objectClass,
      'bounding_box': jsonEncode(boundingBox),
      'image_path': imagePath,
      'camera_id': cameraId,
      'confidence': confidence,
      'captured_at': capturedAt.toIso8601String(),
      'insertedAt': insertedAt?.toIso8601String(),
      'meta_data': metaData,
    };
  }
}
