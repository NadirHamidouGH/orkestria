import 'package:orkestria/domain/entities/user.dart';

/// Abstract class defining the interface for user data access.
abstract class UserDataSource {

  /// Fetches a user by ID.
  Future<User> fetchUserById(String userId);

  /// Authenticates a user.
  Future<bool> authenticate(String username, String password);
}