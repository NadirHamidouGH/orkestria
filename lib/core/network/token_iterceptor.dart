import 'package:dio/dio.dart';
import 'package:orkestria/core/network/check_auth.dart'; // Assuming this contains the isTokenExpired function.
import 'package:orkestria/domain/usecases/authenticate_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An interceptor for Dio that adds an authentication token to requests.
/// This interceptor checks for an existing token in shared preferences,
/// refreshes it if expired, and then adds the token to the request headers.
class TokenInterceptor extends Interceptor {
  final AuthenticateUseCase authenticateUseCase; // Use case for authentication and token refresh.

  /// Constructor for the TokenInterceptor.
  /// Requires an instance of AuthenticateUseCase to handle token refresh.
  TokenInterceptor(this.authenticateUseCase);

  /// Called before a request is sent.
  /// This method retrieves the token from shared preferences, checks if it's
  /// expired, refreshes it if necessary, and adds the token to the request headers.
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final sharedPreferences = await SharedPreferences.getInstance(); // Gets an instance of SharedPreferences.
    final token = sharedPreferences.getString('authToken'); // Retrieves the auth token from SharedPreferences.

    if (token != null) { // Checks if a token exists.
      if (isTokenExpired(token)) { // Checks if the token is expired.
        // Refresh token if expired.
        await authenticateUseCase.refreshToken(); // Calls the refresh token use case.
        options.headers['Authorization'] = 'Bearer ${authenticateUseCase.authToken}'; // Adds the refreshed token to the Authorization header.
      } else {
        options.headers['Authorization'] = 'Bearer $token'; // Adds the existing token to the Authorization header.
      }
    }

    return handler.next(options); // Continues the request.  Crucially important!
  }
}