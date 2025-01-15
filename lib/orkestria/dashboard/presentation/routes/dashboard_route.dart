import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:orkestria/router.dart';
const dashboardRoutePath = '/dashboard';
const dashboardRouteName = 'dashboard';

final dashboardRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: dashboardRoutePath,
  name: dashboardRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: DashboardScreen(),
      key: const ValueKey(dashboardRouteName),
    );
  },
);
