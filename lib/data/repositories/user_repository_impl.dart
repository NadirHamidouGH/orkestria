import 'package:orkestria/data/datasources/user/user_datasource.dart';
import 'package:orkestria/domain/entities/user.dart';
import 'package:orkestria/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<User> getUserById(String userId) async {
    return await dataSource.fetchUserById(userId);
  }

  @override
  Future<bool> authenticate(String username, String password) async {
    return await dataSource.authenticate(username, password);
  }

  // @override
  // Future<void> createUser(User user) async {
  //   await dataSource.saveUser(user);
  // }
}
