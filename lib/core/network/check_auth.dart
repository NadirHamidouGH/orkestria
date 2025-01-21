import 'dart:convert';

bool isTokenExpired(String token) {
  final payload = token.split('.')[1]; // Extract payload from JWT
  final decodedPayload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(payload))));
  final exp = decodedPayload['exp']; // Expiration time in seconds since epoch
  final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Current time in seconds
  return exp <= currentTime;
}
