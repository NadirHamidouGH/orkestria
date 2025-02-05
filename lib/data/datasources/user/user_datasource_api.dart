import 'package:dio/dio.dart';
import 'package:orkestria/data/datasources/user/user_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user.dart';

/// Implementation of the UserDataSource interface using a remote API.
class UserDataSourceApi implements UserDataSource {
  final Dio dio = Dio(); // Dio instance for network requests.
  String? authToken; // Stores the authentication token.
  String? refreshToken; // Stores the refresh token.

  /// Authenticates a user and retrieves a JWT token.
  @override
  Future<bool> authenticate(String username, String password) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = { // Request body for authentication.
      'grant_type': 'password',
      'client_id': 'micro-project',
      'client_secret': 'LYraqgcU76cyAKumDVxJYUBAoBS0sZqO', // Client secret - should be handled securely!
      'username': username,
      'password': password,
    };

    try {
      var response = await dio.post( // Makes the authentication request.
        'https://auth.corepulse.fr/realms/ORKESTRIA/protocol/openid-connect/token',
        options: Options(headers: headers),
        data: data,
      );

      if (response.statusCode == 200) {
        final sharedPreferences = await SharedPreferences.getInstance(); // Stores tokens in shared preferences.

        authToken = response.data['access_token'];
        refreshToken = response.data['refresh_token'];
        sharedPreferences.setString('authToken', authToken.toString());
        sharedPreferences.setString('refresh_token', refreshToken.toString()); // Corrected: Store the refresh token
        sharedPreferences.setString('username', username);
        sharedPreferences.setString('password', password);

        return true;
      } else {
        print('Authentication Error: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  /// Fetches a user by ID. Requires authentication.
  @override
  Future<User> fetchUserById(String userId) async {
    if (authToken == null) {
      throw Exception('User not authenticated');
    }

    var headers = {
      'Authorization': 'Bearer $authToken',
    };

    try {
      var response = await dio.get( // Makes the request to fetch the user.
        'https://example.com/api/users/$userId', // Replace with your API endpoint.
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        var userData = response.data; // Adapt to your API response structure.
        return User( // Creates a User object from the API response.
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          passwordHash: userData['passwordHash'],
          role: userData['role'],
          createdAt: DateTime.parse(userData['createdAt']),
          updatedAt: DateTime.parse(userData['updatedAt']),
          projectIds: List<String>.from(userData['projectIds']),
          zoneIds: List<String>.from(userData['zoneIds']),
        );
      } else {
        throw Exception('Error fetching user');
      }
    } catch (e) {
      print('Error: $e');
      rethrow; // Rethrows the caught exception.
    }
  }

  /// Saves a user (not implemented here).
  @override
  Future<void> saveUser(User user) async {
    // Implement user saving logic if needed.
  }
}