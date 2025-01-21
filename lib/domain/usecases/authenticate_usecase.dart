import 'package:dio/dio.dart';
import 'package:orkestria/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateUseCase {
  final UserRepository userRepository;

  AuthenticateUseCase(this.userRepository, this.dio);

  final Dio dio;

  String? authToken;


  Future<void> refreshToken() async {

    try {
      // Retrieve the refresh token from SharedPreferences
      final sharedPreferences = await SharedPreferences.getInstance();
      final refreshToken = sharedPreferences.getString('refresh_token');

      if (refreshToken == null) {
        throw Exception('No refresh token found. Please log in again.');
      }

      // Send the refresh token to the server to get a new access token
      final response = await dio.post(
        'https://auth.corepulse.fr/realms/ORKESTRIA/protocol/openid-connect/token',
        data: {
          'grant_type': 'refresh_token',
          'client_id': 'micro-project',
          'client_secret': 'LYraqgcU76cyAKumDVxJYUBAoBS0sZqO',
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        authToken = response.data['access_token'];

        // Save the new token in SharedPreferences
        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString('authToken', authToken!);
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Error refreshing token: $e');
    }
  }

  Future<bool> call(String username, String password) async {
    return await userRepository.authenticate(username, password);
  }
}
