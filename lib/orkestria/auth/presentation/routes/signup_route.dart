import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/auth/presentation/screens/Signup/signup_screen.dart';
import 'package:orkestria/router.dart';
const signupRoutePath = '/signup';
const signupRouteName = 'signup';

final signupRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: signupRoutePath,
  name: signupRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: SignUpScreen(),
      key: ValueKey(signupRouteName),
    );
  },
);
