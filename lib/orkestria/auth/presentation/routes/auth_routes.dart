import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/auth/presentation/routes/login_route.dart';
import 'package:orkestria/orkestria/auth/presentation/routes/signup_route.dart';

final List<RouteBase> authRoutes = [
  loginRoute,
  signupRoute,
];

final GoRouter authRouter = GoRouter(
  routes: authRoutes,
);