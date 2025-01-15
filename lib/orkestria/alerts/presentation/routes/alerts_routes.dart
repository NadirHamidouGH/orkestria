import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/alerts/presentation/routes/alerts_route.dart';

final List<RouteBase> dashboardRoutes = [
  alertsRoute,
];

final GoRouter authRouter = GoRouter(
  routes: dashboardRoutes,
);