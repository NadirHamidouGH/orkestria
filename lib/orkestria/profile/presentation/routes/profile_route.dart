import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/profile/presentation/screens/profile_screen.dart';
import 'package:orkestria/router.dart';
const profileRoutePath = '/profile';
const profileRouteName = 'profile';

final profileRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: profileRoutePath,
  name: profileRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: ProfileScreen(),
      key: ValueKey(profileRouteName),
    );
  },
);
