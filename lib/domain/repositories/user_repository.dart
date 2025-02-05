import 'package:orkestria/domain/entities/user.dart';

/// Abstract class defining the interface for user repository operations.
abstract class UserRepository {
  /// Retrieves a user by ID.
  Future<User> getUserById(String userId);

  /// Authenticates a user.
  Future<bool> authenticate(String username, String password);
}