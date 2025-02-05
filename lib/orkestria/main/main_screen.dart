import 'package:flutter/material.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting MenuAppController via Provider.
import 'package:provider/provider.dart';
import '../../core/utils/responsive.dart';
import '../dashboard/presentation/screens/dashboard_screen.dart';
import 'components/side_menu.dart';

/// Main screen layout with side menu and dashboard.
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey, // Access the scaffold key.
      drawer: const SideMenu(), // Side menu/drawer.
      body: SafeArea( // Ensures content is within safe area.
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Side menu only on larger screens.
            if (Responsive.isDesktop(context))
              const Expanded( // Takes 1/6 of the screen.
                child: SideMenu(),
              ),
            const Expanded( // Takes 5/6 of the screen.
              flex: 5,
              child: DashboardScreen(), // Dashboard content.
            ),
          ],
        ),
      ),
    );
  }
}