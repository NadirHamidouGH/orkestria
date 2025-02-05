import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:orkestria/orkestria/alerts/presentation/routes/alerts_route.dart'; // Use route paths.
import 'package:orkestria/orkestria/auth/presentation/routes/login_route.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/routes/camera_kpi_route.dart'; // Use route paths.
import 'package:orkestria/orkestria/profile/presentation/routes/profile_route.dart'; // Use route paths.
import 'package:orkestria/orkestria/projects/presentation/routes/projects_route.dart';
import 'package:orkestria/orkestria/recording/presentation/routes/recording_route.dart'; // Use route paths.
import 'package:orkestria/orkestria/settings/presentation/routes/settings_route.dart'; // Use route paths.
import 'package:provider/provider.dart';

/// Side menu/drawer for navigation.
class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return Drawer( // Use a Drawer widget.
      backgroundColor: isDarkMode ? bgColor : secondaryColorLight.withOpacity(0.95), // Dynamic background color.
      child: ListView(
        children: [
          DrawerHeader( // Header section of the drawer.
            child: isDarkMode // Dynamic logo.
                ? Image.asset("assets/images/logo.png")
                : Image.asset("assets/images/logo_dark.png"),
          ),
          DrawerListTile( // Dashboard link.
            title: "Dashboard",
            icon: LucideIcons.layout_dashboard,
            press: () {
              Navigator.pop(context); // Close the drawer.
            },
          ),
          DrawerListTile( // Sites link.
            title: "Sites",
            icon: LucideIcons.factory,
            press: () {
              GoRouter.of(context).push(projectsRoutePath); // Navigate using GoRouter.
            },
          ),
          DrawerListTile( // Alerts link.
            title: "Alerts",
            icon: LucideIcons.triangle_alert,
            press: () {
              GoRouter.of(context).push(alertsRoutePath); // Navigate using GoRouter.
            },
          ),
          DrawerListTile( // Camera KPI link.
            title: "Camera KPI",
            icon: LucideIcons.file_video_2,
            press: () {
              GoRouter.of(context).push(recordingRoutePath); // Navigate using GoRouter.
            },
          ),
          DrawerListTile( // Cameras link.
            title: "Cameras",
            icon: LucideIcons.scan_eye,
            press: () {
              GoRouter.of(context).push(cameraKpiRoutePath); // Navigate using GoRouter.
            },
          ),
          DrawerListTile( // Profile link.
            title: "Profile",
            icon: LucideIcons.user,
            press: () {
              GoRouter.of(context).push(profileRoutePath); // Navigate using GoRouter.
            },
          ),
          DrawerListTile( // Settings link.
            title: "Settings",
            icon: LucideIcons.settings,
            press: () {
              GoRouter.of(context).push(settingsRoutePath); // Navigate using GoRouter.
            },
          ),
          DrawerListTile( // Sign out link.
            title: "Sign Out",
            icon: LucideIcons.log_out,
            press: () {
              GoRouter.of(context).go(loginRoutePath); // Navigate using GoRouter.
            },
          ),
        ],
      ),
    );
  }
}

/// A tile in the drawer list.
class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title, // Title text.
    required this.icon, // Icon.
    required this.press, // Callback function.
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return ListTile( // Use a ListTile widget.
      onTap: press, // Call the callback on tap.
      horizontalTitleGap: 8.0,
      leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.black54), // Icon with dynamic color.
      title: Text(
        title,
      ),
    );
  }
}