///
/// This file defines the main routes used in the application
/// using the `GoRouter` library. It also configures the
/// `Navigator` keys, navigation observers, and helper methods
/// for navigation.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/alerts/presentation/routes/alerts_route.dart';
import 'package:orkestria/orkestria/auth/presentation/routes/login_route.dart';
import 'package:orkestria/orkestria/auth/presentation/routes/signup_route.dart';
import 'package:orkestria/orkestria/auth/presentation/routes/splash_route.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/routes/camera_kpi_route.dart';
import 'package:orkestria/orkestria/profile/presentation/routes/profile_route.dart';
import 'package:orkestria/orkestria/projects/presentation/routes/projects_route.dart';
import 'package:orkestria/orkestria/recording/presentation/routes/recording_route.dart';
import 'package:orkestria/orkestria/settings/presentation/routes/settings_route.dart';


/// A global key for the `Navigator`, used to manage navigation in the app.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Main configuration for GoRouter.
///
/// - Defines the initial route.
/// - Maps paths to their corresponding widgets.
/// - Sets up navigation observers, including Dynatrace.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  // initialLocation: preloginSplashRoutePath,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    splashRoute,
    loginRoute,
    signupRoute,
    profileRoute,
    alertsRoute,
    cameraKpiRoute,
    projectsRoute,
    recordingRoute,
    settingsRoute
  ],
);

/// Navigate back to the previous view.
///
/// A utility method to return to the previous view.
///
/// Example usage:
/// ```dart
/// backToPreviousView(context);
/// ```
void backToPreviousView(BuildContext context) {
  GoRouter.of(context).pop();
}

/// Extension for GoRouter-related utilities.
///
/// This extension adds additional methods
/// to the GoRouter class to simplify navigation tasks.
extension RouterUtils on GoRouter {
  /// Checks if the current route matches a given path.
  ///
  /// [context]: The current context.
  /// [path]: The path to check against.
  ///
  /// Returns `true` if the current route starts with the given path.
  bool isCurrentLocation(BuildContext context, String path) {
    return GoRouterState.of(context).uri.toString().startsWith(path);
  }

  /// Navigates to a new route only if it is not the current route.
  ///
  /// [context]: The current context.
  /// [path]: The new route's path.
  ///
  /// Example usage:
  /// ```dart
  /// GoRouter().navigateIfNotCurrentLocation(context, '/new-path');
  /// ```
  void navigateIfNotCurrentLocation(BuildContext context, String path) {
    if (!isCurrentLocation(context, path)) {
      GoRouter.of(context).go(path);
    }
  }
}
