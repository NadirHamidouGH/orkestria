import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/projects/presentation/routes/projects_route.dart';

final List<RouteBase> projectsRoutes = [
  projectsRoute,
];

final GoRouter projectsRouter = GoRouter(
  routes: projectsRoutes,
);