import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/auth/presentation/screens/Splash/splash_screen.dart';
import 'package:orkestria/router.dart';
const splashRoutePath = '/';
const splashRouteName = 'splash';

final splashRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: splashRoutePath,
  name: splashRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: SplashScreen(),
      key: ValueKey(splashRouteName),
    );
  },
);
