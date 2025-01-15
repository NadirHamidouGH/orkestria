import 'package:flutter/material.dart';
import 'package:orkestria/core/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  String selectedLanguage = "English";
  String selectedZone = "Zone 1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 24,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Settings",
                style: heading2),
            ),
            SettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SettingsTile(
                    title: "Language",
                    trailing: DropdownButton<String>(
                      value: selectedLanguage,
                      items: const [
                        DropdownMenuItem(
                          value: "English",
                          child: Text("English"),
                        ),
                        DropdownMenuItem(
                          value: "French",
                          child: Text("French"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                      },
                    ),
                  ),
                  const Divider(height: 1,color: Colors.white10,),
                  SettingsTile(
                    title: "Zone",
                    trailing: DropdownButton<String>(
                      value: selectedZone,
                      items: const [
                        DropdownMenuItem(
                          value: "Zone 1",
                          child: Text("Zone 1"),
                        ),
                        DropdownMenuItem(
                          value: "Zone 2",
                          child: Text("Zone 2"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedZone = value!;
                        });
                      },
                    ),
                  ),
                  const Divider(height: 1,color: Colors.white10,),
                  SettingsTile(
                    title: "Enable Dark Mode",
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                  ),
                  const Divider(height: 1,color: Colors.white10,),
                  SettingsTile(
                    title: "Enable Notifications",
                    trailing: Switch(
                      value: isNotificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          isNotificationsEnabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SettingsTile(
                    title: "Phone",
                    trailing: Text("+123456789"),
                  ),
                  const Divider(height: 1,color: Colors.white10,),
                  const SettingsTile(
                    title: "Email",
                    trailing: Text("example@mail.com"),
                  ),
                  const Divider(height: 1,color: Colors.white10,),
                  SettingsTile(
                    title: "Role",
                    trailing: Text("Supervisor"),
                    onTap: () {
                      // Handle sign out
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SettingsTile(
                    title: "Site",
                    trailing: Text("CP ALGER"),
                  ),
                  Divider(height: 1,color: Colors.white10,),
                  SettingsTile(
                    title: "Zones",
                    trailing: Text("3"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final Widget child;

  const SettingsCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    Key? key,
    required this.title,
    required this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

