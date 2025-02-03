import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orkestria/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants.dart';
import 'provider_setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  await themeController.loadTheme();

  runApp(
    setupProviders(
      ChangeNotifierProvider.value(
        value: themeController,
        child: MyApp(),
      ),
    ),
  );
}

class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await saveTheme();
    notifyListeners();
  }

  Future<void> saveTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('is_dark_mode', _isDarkMode);
  }

  Future<void> loadTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    _isDarkMode = sharedPreferences.getBool('is_dark_mode') ?? false;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Orkestria',
          routerConfig: appRouter,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.black),
            canvasColor: Colors.grey[200],
            primaryColor: primaryColor,
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: bgColor,
            textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
            canvasColor: secondaryColor,
            primaryColor: primaryColor,
          ),
          themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
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
