import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/alerts/presentation/screens/alerts_screen.dart';
import 'package:orkestria/router.dart';
const alertsRoutePath = '/alerts';
const alertsRouteName = 'alerts';

final alertsRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: alertsRoutePath,
  name: alertsRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: AlertsScreen(),
      key: ValueKey(alertsRouteName),
    );
  },
);
