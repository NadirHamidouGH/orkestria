import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/alerts/presentation/screens/alerts_screen.dart';
import 'package:orkestria/router.dart';

/// Path for the alerts route.
const alertsRoutePath = '/alerts';

/// Name for the alerts route.
const alertsRouteName = 'alerts';

/// GoRoute configuration for the alerts screen.
final alertsRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey, // Key for the root navigator.
  path: alertsRoutePath, // Path for the route.
  name: alertsRouteName, // Name for the route.
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage( // Uses NoTransitionPage for no animation.
      child: AlertsScreen(), // The screen to display for this route.
      key: ValueKey(alertsRouteName), // Key for the page.
    );
  },
);