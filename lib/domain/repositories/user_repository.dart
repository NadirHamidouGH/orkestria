import 'package:orkestria/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getUserById(String userId);
  Future<bool> authenticate(String username, String password);
  // Future<void> createUser(User user);
}
