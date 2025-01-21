import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/main/main_screen.dart';
import 'package:provider/provider.dart';

const mainRoutePath = '/main';
const mainRouteName = 'main';

final mainRoute = GoRoute(
  path: mainRoutePath,
  name: mainRouteName,
  pageBuilder: (BuildContext context, GoRouterState state) {
    // Wrapping MainScreen with MultiProvider to include MenuAppController
    return NoTransitionPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(), // Providing MenuAppController
          ),
        ],
        child: MainScreen(),
      ),
      key: const ValueKey(mainRouteName),
    );
  },
);
