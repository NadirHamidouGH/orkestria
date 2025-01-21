import 'package:orkestria/domain/entities/user.dart';

abstract class UserDataSource {
  Future<User> fetchUserById(String userId);
  Future<bool> authenticate(String username, String password);
  // Future<void> saveUser(User user);
}
