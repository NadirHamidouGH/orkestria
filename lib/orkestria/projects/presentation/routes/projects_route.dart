import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/projects/presentation/screens/projects_screen.dart';
import 'package:orkestria/router.dart';

/// Route path for the projects screen.
const projectsRoutePath = '/projects';

/// Route name for the projects screen.
const projectsRouteName = 'projects';

/// GoRoute configuration for the projects screen.
final projectsRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey, // Key for the parent navigator.
  path: projectsRoutePath, // Path for the route.
  name: projectsRouteName, // Name for the route.
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage( // Use NoTransitionPage to prevent transitions.
      child: ProjectsScreen(), // The ProjectsScreen widget.
      key: ValueKey(projectsRouteName), // Key for the page.
    );
  },
);