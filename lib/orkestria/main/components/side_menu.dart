import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/orkestria/alerts/presentation/screens/alerts_screen.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/screens/camera_kpi_screen.dart';
import 'package:orkestria/orkestria/profile/presentation/screens/profile_screen.dart';
import 'package:orkestria/orkestria/projects/presentation/routes/projects_route.dart';
import 'package:orkestria/orkestria/recording/presentation/screens/recording_screen.dart';
import 'package:orkestria/orkestria/settings/presentation/screens/settings_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
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
            title: "Recording",
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
            title: "Camera KPI",
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
              //TODO: replace with goRouter
                Navigator.pop(context);
                Navigator.pop(context);
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
    return ListTile(
      onTap: press,
      horizontalTitleGap: 8.0,
      leading: Icon(icon),
      title: Text(
        title,
        style: subtitle2,
      ),
    );
  }
}
