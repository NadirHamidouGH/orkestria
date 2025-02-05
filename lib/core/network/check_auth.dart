import 'dart:convert';

/// Checks if a JWT (JSON Web Token) is expired.
///
/// This function decodes the JWT payload, extracts the expiration time,
/// and compares it to the current time.
///
/// Args:
///   token: The JWT string.  Must be a valid JWT.
///
/// Returns:
///   True if the token is expired, false otherwise.  Returns false if there's an error decoding the token.
bool isTokenExpired(String token) {
  try {
    final payload = token.split('.')[1]; // Extract the payload part of the JWT (the middle part).
    // JWT payload is base64url encoded.  We need to decode it.
    // base64Url.normalize handles padding issues that might occur.
    final decodedPayload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(payload))));
    final exp = decodedPayload['exp']; // Extract the expiration time (typically in seconds since the epoch).

    if (exp is! int) { // Check if 'exp' is actually an integer (important for type safety)
      return false; // Handle the case where exp is not an integer by assuming it's not expired (or however you want to handle this case)
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Get the current time in seconds since the epoch.

    return exp <= currentTime; // Compare expiration time with current time.
  } catch (e) {
    // Handle any exceptions during decoding (e.g., invalid JWT format).
    // In this case, we'll assume the token is *not* expired to prevent issues.
    // You might want to log the error or handle it differently in your application.
    print("Error decoding JWT: $e"); // Log the error for debugging.
    return false; // Or return true, depending on how you want to treat invalid tokens.
  }
}