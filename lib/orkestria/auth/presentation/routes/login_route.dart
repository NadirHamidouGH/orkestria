import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/auth/presentation/screens/Login/login_screen.dart';
import 'package:orkestria/router.dart';
const loginRoutePath = '/login';
const loginRouteName = 'login';

final loginRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: loginRoutePath,
  name: loginRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: LoginScreen(),
      key: ValueKey(loginRouteName),
    );
  },
);
