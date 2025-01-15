import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/projects/presentation/screens/projects_screen.dart';
import 'package:orkestria/router.dart';
const projectsRoutePath = '/projects';
const projectsRouteName = 'projects';

final projectsRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: projectsRoutePath,
  name: projectsRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: ProjectsScreen(),
      key: ValueKey(projectsRouteName),
    );
  },
);
