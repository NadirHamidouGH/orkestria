import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/settings/presentation/routes/settings_route.dart';

final List<RouteBase> settingsRoutes = [
  settingsRoute,
];

final GoRouter settingsRouter = GoRouter(
  routes: settingsRoutes,
);