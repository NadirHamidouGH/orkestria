import 'package:dio/dio.dart';
import 'package:orkestria/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Use case for authenticating a user and refreshing the authentication token.
class AuthenticateUseCase {
  final UserRepository userRepository; // Repository for user-related operations.
  final Dio dio; // Dio instance for network requests.

  AuthenticateUseCase(this.userRepository, this.dio);

  String? authToken; // Stores the authentication token.

  /// Refreshes the authentication token using the refresh token.
  Future<void> refreshToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final refreshToken = sharedPreferences.getString('refresh_token');

      if (refreshToken == null) {
        throw Exception('No refresh token found. Please log in again.');
      }

      final response = await dio.post(
        'https://auth.corepulse.fr/realms/ORKESTRIA/protocol/openid-connect/token',
        data: {
          'grant_type': 'refresh_token',
          'client_id': 'micro-project',
          'client_secret': 'LYraqgcU76cyAKumDVxJYUBAoBS0sZqO', // NOTE: Hardcoded client secret - BAD PRACTICE! Should be stored securely.
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        authToken = response.data['access_token'];
        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString('authToken', authToken!); // NOTE: Force unwrap might be risky if authToken is null. Consider null safety measures.
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Error refreshing token: $e');
    }
  }

  /// Authenticates a user using the provided credentials.
  Future<bool> call(String username, String password) async {
    return await userRepository.authenticate(username, password);
  }
}