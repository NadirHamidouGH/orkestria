import 'package:dio/dio.dart';
import 'package:orkestria/core/network/check_auth.dart';
import 'package:orkestria/domain/usecases/authenticate_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  final AuthenticateUseCase authenticateUseCase;

  TokenInterceptor(this.authenticateUseCase);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('authToken');

    if (token != null) {
      if (isTokenExpired(token)) {
        // Refresh token if expired
        await authenticateUseCase.refreshToken();
        options.headers['Authorization'] = 'Bearer ${authenticateUseCase.authToken}';
      } else {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }
}
