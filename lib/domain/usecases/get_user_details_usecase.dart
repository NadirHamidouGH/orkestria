import 'package:orkestria/domain/entities/user.dart';
import 'package:orkestria/domain/repositories/user_repository.dart';

class GetUserDetails {
  final UserRepository userRepository;

  GetUserDetails(this.userRepository);

  Future<User> call(String userId) async {
    // On appelle la méthode du repository pour récupérer l'utilisateur
    return await userRepository.getUserById(userId);
  }
}
