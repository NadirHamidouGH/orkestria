import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/screens/camera_kpi_screen.dart';
import 'package:orkestria/router.dart';
const cameraKpiRoutePath = '/cameraKpi';
const cameraKpiRouteName = 'cameraKpi';

final cameraKpiRoute = GoRoute(
  parentNavigatorKey: rootNavigatorKey,
  path: cameraKpiRoutePath,
  name: cameraKpiRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      // child: CameraKpiScreen(),
      child: CameraKpiScreen(),
      key: ValueKey(cameraKpiRouteName),
    );
  },
);
