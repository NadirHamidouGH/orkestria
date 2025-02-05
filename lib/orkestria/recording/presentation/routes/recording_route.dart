import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/recording/presentation/screens/recording_screen.dart';
import 'package:orkestria/router.dart';

/// Route path for the recording screen.
const recordingRoutePath = '/recording';

/// Route name for the recording screen.
const recordingRouteName = 'recording';

/// GoRoute configuration for the recording screen.
final recordingRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey, // Key for the parent navigator.
  path: recordingRoutePath, // Path for the route.
  name: recordingRouteName, // Name for the route.
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage( // Use NoTransitionPage to prevent transitions.
      child: RecordingScreen(), // The RecordingScreen widget.
      key: ValueKey(recordingRouteName), // Key for the page.
    );
  },
);