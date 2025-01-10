import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: LucideIcons.layout_dashboard,
            press: () {},
          ),
          DrawerListTile(
            title: "Projects",
            icon: LucideIcons.folder_kanban,
            press: () {},
          ),
          DrawerListTile(
            title: "Alerts",
            icon: LucideIcons.triangle_alert,
            press: () {},
          ),
          DrawerListTile(
            title: "Recording",
            icon: LucideIcons.file_video_2,
            press: () {},
          ),
          DrawerListTile(
            title: "Camera KPI",
            icon: LucideIcons.scan_eye,
            press: () {},
          ),
          DrawerListTile(
            title: "Profile",
            icon: LucideIcons.user,
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            icon: LucideIcons.settings,
            press: () {},
          ),
          DrawerListTile(
            title: "Logout",
            icon: LucideIcons.log_out,
            press: () {},
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
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
