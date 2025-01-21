import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orkestria/data/datasources/user/user_datasource_api.dart';
import 'package:orkestria/data/repositories/user_repository_impl.dart';
import 'package:orkestria/domain/usecases/authenticate_usecase.dart';
import 'package:orkestria/orkestria/projects/data/project_api_service.dart';
import 'package:orkestria/orkestria/projects/domain/usecases/fetch_project_usecase.dart';
import 'package:orkestria/router.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'core/constants.dart';
import 'orkestria/projects/data/project_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dio
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://auth.corepulse.fr/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        // Provide the implementation of UserRepository
        Provider(
          create: (_) => UserRepositoryImpl(UserDataSourceApi()),
        ),
        // Provide the implementation of ProjectRepository
        Provider(
          create: (_) => ProjectRepositoryImpl(ProjectDataSourceApi(dio)),
        ),
        // Provide the Dio instance
        Provider(
          create: (_) => dio,
        ),
        // Provide the UseCase AuthenticateUseCase
        ProxyProvider2<UserRepositoryImpl, Dio, AuthenticateUseCase>(
          update: (_, repository, dio, __) => AuthenticateUseCase(repository, dio),
        ),
        // Provide the UseCase FetchProjectsUseCase
        ProxyProvider2<ProjectRepositoryImpl, Dio, FetchProjectsUseCase>(
          update: (_, projectRepository, dio, __) => FetchProjectsUseCase(projectRepository),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Orkestria',
      routerConfig: appRouter,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
    );
  }
}

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
