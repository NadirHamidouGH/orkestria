import 'package:orkestria/data/datasources/user/user_datasource.dart';
import 'package:orkestria/domain/entities/user.dart';
import 'package:orkestria/domain/repositories/user_repository.dart';

/// Implementation of the UserRepository interface.
class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource; // Data source for user data.

  UserRepositoryImpl(this.dataSource);

  /// Retrieves a user by ID.
  @override
  Future<User> getUserById(String userId) async {
    return await dataSource.fetchUserById(userId); // Calls the data source.
  }

  /// Authenticates a user.
  @override
  Future<bool> authenticate(String username, String password) async {
    return await dataSource.authenticate(username, password); // Calls the data source.
  }
}