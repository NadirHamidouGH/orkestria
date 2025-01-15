import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/routes/camera_kpi_route.dart';

final List<RouteBase> cameraKpiRoutes = [
  cameraKpiRoute,
];

final GoRouter authRouter = GoRouter(
  routes: cameraKpiRoutes,
);