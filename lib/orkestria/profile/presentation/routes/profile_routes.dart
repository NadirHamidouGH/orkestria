import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/profile/presentation/routes/profile_route.dart';

final List<RouteBase> profilRoutes = [
  profileRoute,
];

final GoRouter profilRouter = GoRouter(
  routes: profilRoutes,
);