import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orkestria/core/analytics/firebase_analytics_engine.dart';
import 'package:orkestria/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants.dart';
import 'provider_setup.dart';

/// The main entry point of the application.
/// Initializes Flutter bindings, loads the theme, and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that Flutter bindings are initialized.
  final themeController = ThemeController(); // Instance of the theme controller.
  await themeController.loadTheme(); // Loads the theme from preferences.
  FirebaseAnalyticsEngine.init();

  runApp(
    setupProviders( // Configures providers (likely with dependencies).
      ChangeNotifierProvider.value( // Provides the theme controller to the widget tree.
        value: themeController,
        child: MyApp(), // The main application widget.
      ),
    ),
  );
}

/// Controller for the application's theme.
/// Manages theme changes (light/dark) and their persistence.
class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false; // Stores the dark mode state.

  /// Getter for the dark mode state.
  bool get isDarkMode => _isDarkMode;

  /// Toggles the theme and saves the change.
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode; // Inverts the theme state.
    await saveTheme(); // Saves the theme to preferences.
    notifyListeners(); // Notifies listeners (widgets) of the theme change.
  }

  /// Saves the current theme to shared preferences.
  Future<void> saveTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance(); // Gets an instance of SharedPreferences.
    await sharedPreferences.setBool('is_dark_mode', _isDarkMode); // Saves the dark mode state.
  }

  /// Loads the theme from shared preferences.
  /// If no value is found, the light theme is used by default.
  Future<void> loadTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance(); // Gets an instance of SharedPreferences.
    _isDarkMode = sharedPreferences.getBool('is_dark_mode') ?? false; // Retrieves the theme state or false by default.
    notifyListeners(); // Notifies listeners of the loaded theme.
  }
}

/// The main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>( // Listens for changes in the theme controller.
      builder: (context, themeController, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false, // Hides the debug banner.
          title: 'Orkestria', // The application title.
          routerConfig: appRouter, // Router configuration (navigation).
          theme: ThemeData( // Default light theme.
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white, // Screen background color.
            textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.black), // Text style with Google Fonts.
            canvasColor: Colors.grey[200], // Background color of UI elements.
            primaryColor: primaryColor, // Primary color of the application.
          ),
          darkTheme: ThemeData.dark().copyWith( // Dark theme.
            scaffoldBackgroundColor: bgColor,
            textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
            canvasColor: secondaryColor,
            primaryColor: primaryColor,
          ),
          themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Chooses the theme based on the controller.
        );
      },
    );
  }
}

/// Controller for the application's menu (likely for a drawer).
class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Global key for the Scaffold.

  /// Getter for the Scaffold key.
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  /// Opens the menu (drawer) if it's not already open.
  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}