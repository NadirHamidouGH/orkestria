import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/profile/presentation/screens/profile_screen.dart';
import 'package:orkestria/orkestria/recording/presentation/screens/recording_screen.dart';
import 'package:orkestria/router.dart';
const recordingRoutePath = '/recording';
const recordingRouteName = 'recording';

final recordingRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: recordingRoutePath,
  name: recordingRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: RecordingScreen(),
      key: ValueKey(recordingRouteName),
    );
  },
);
