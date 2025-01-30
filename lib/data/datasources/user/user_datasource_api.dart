import 'package:dio/dio.dart';
import 'package:orkestria/data/datasources/user/user_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user.dart';

class UserDataSourceApi implements UserDataSource {
  final Dio dio = Dio();
  String? authToken;
  String? refreshToken;

  // Fonction pour authentifier l'utilisateur et obtenir un token JWT
  @override
  Future<bool> authenticate(String username, String password) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = {
      'grant_type': 'password',
      'client_id': 'micro-project',
      'client_secret': 'LYraqgcU76cyAKumDVxJYUBAoBS0sZqO',
      'username': username,
      'password': password,
    };

    try {
      var response = await dio.post(
        'https://auth.corepulse.fr/realms/ORKESTRIA/protocol/openid-connect/token',
        options: Options(
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        // Récupérer le token JWT et le stocker pour les futures requêtes
        final sharedPreferences = await SharedPreferences.getInstance();

        authToken = response.data['access_token'];
        refreshToken = response.data['refresh_token'];
        sharedPreferences.setString('authToken', authToken.toString());
        sharedPreferences.setString('refresh_token', authToken.toString());
        sharedPreferences.setString('username', username);
        sharedPreferences.setString('password', password);

        return true;
      } else {
        print('Erreur d\'authentification: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      print('Erreur: $e');
      return false;
    }
  }

  // Fonction pour récupérer un utilisateur par son ID (avec authentification)
  @override
  Future<User> fetchUserById(String userId) async {
    // Vérifie si l'utilisateur est authentifié avant de faire une requête API
    if (authToken == null) {
      throw Exception('Utilisateur non authentifié');
    }

    var headers = {
      'Authorization': 'Bearer $authToken',
    };

    var data = {};

    try {
      var response = await dio.get(
        'https://example.com/api/users/$userId', // Remplace cette URL par celle de ton API
        options: Options(
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        var userData = response.data; // Adapte cette ligne à la structure de ta réponse API
        return User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          passwordHash: userData['passwordHash'],
          role: userData['role'],
          createdAt: DateTime.parse(userData['createdAt']),
          updatedAt: DateTime.parse(userData['updatedAt']),
          projectIds: List<String>.from(userData['projectIds']),
          zoneIds: List<String>.from(userData['zoneIds']),
        );
      } else {
        throw Exception('Erreur lors de la récupération de l\'utilisateur');
      }
    } catch (e) {
      print('Erreur: $e');
      rethrow;
    }
  }

  // Fonction pour sauvegarder un utilisateur (pas implémentée ici, mais peut être adaptée)
  @override
  Future<void> saveUser(User user) async {
    // Implémente la logique pour enregistrer l'utilisateur, si nécessaire
  }
}
