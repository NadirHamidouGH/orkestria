import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/alerts/presentation/screens/alerts_screen.dart';
import 'package:orkestria/orkestria/auth/presentation/routes/login_route.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/screens/camera_kpi_screen.dart';
import 'package:orkestria/orkestria/profile/presentation/screens/profile_screen.dart';
import 'package:orkestria/orkestria/projects/presentation/routes/projects_route.dart';
import 'package:orkestria/orkestria/recording/presentation/screens/recording_screen.dart';
import 'package:orkestria/orkestria/settings/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return Drawer(
      backgroundColor: isDarkMode? bgColor : secondaryColorLight.withOpacity(0.95),
      child: ListView(
        children: [
          DrawerHeader(
            child: isDarkMode ? Image.asset("assets/images/logo.png") : Image.asset("assets/images/logo_dark.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: LucideIcons.layout_dashboard,
            press: () {
              Navigator.pop(context);
            },
          ),
          DrawerListTile(
            title: "Sites",
            icon: LucideIcons.factory,
            press: () {
              GoRouter.of(context).push(projectsRoutePath);
            },
          ),
          DrawerListTile(
            title: "Alerts",
            icon: LucideIcons.triangle_alert,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AlertsScreen();
                  },
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Camera KPI",
            icon: LucideIcons.file_video_2,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const RecordingScreen();
                  },
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Cameras",
            icon: LucideIcons.scan_eye,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CameraKpiScreen();
                  },
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Profile",
            icon: LucideIcons.user,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ProfileScreen();
                  },
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Settings",
            icon: LucideIcons.settings,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsScreen();
                  },
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Sign Out",
            icon: LucideIcons.log_out,
            press: () {
              GoRouter.of(context).go(loginRoutePath);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return ListTile(
      onTap: press,
      horizontalTitleGap: 8.0,
      leading: Icon(icon, color : isDarkMode ? Colors.white : Colors.black54),
      title: Text(
        title,
        // style: subtitle2,
      ),
    );
  }
}
