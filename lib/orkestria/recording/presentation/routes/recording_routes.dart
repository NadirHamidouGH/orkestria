import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/recording/presentation/routes/recording_route.dart';

final List<RouteBase> recordingRoutes = [
  recordingRoute,
];

final GoRouter recordingRouter = GoRouter(
  routes: recordingRoutes,
);