import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/settings/presentation/screens/settings_screen.dart';
import 'package:orkestria/router.dart';
const settingsRoutePath = '/settings';
const settingsRouteName = 'settings';

final settingsRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: settingsRoutePath,
  name: settingsRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: SettingsScreen(),
      key: const ValueKey(settingsRouteName),
    );
  },
);
