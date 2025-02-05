import 'package:orkestria/domain/entities/user.dart';
import 'package:orkestria/domain/repositories/user_repository.dart';

/// Use case for retrieving user details.
class GetUserDetails {
  final UserRepository userRepository; // Repository for user data access.

  GetUserDetails(this.userRepository);

  /// Retrieves user details by ID.
  Future<User> call(String userId) async {
    return await userRepository.getUserById(userId);
  }
}