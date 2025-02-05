import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/profile/presentation/screens/profile_screen.dart';
import 'package:orkestria/router.dart';

/// Route path for the profile screen.
const profileRoutePath = '/profile';

/// Route name for the profile screen.
const profileRouteName = 'profile';

/// GoRoute configuration for the profile screen.
final profileRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey, // Key for the root navigator.
  path: profileRoutePath, // Path for the route.
  name: profileRouteName, // Name for the route.
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage( // Use NoTransitionPage for no transitions.
      child: ProfileScreen(), // The screen to display.
      key: const ValueKey(profileRouteName), // Key for the page.
    );
  },
);