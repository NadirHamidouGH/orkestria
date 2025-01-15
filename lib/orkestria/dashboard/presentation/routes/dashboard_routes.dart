import 'package:go_router/go_router.dart';
import 'dashboard_route.dart';

final List<RouteBase> dashboardRoutes = [
  dashboardRoute,
];

final GoRouter authRouter = GoRouter(
  routes: dashboardRoutes,
);