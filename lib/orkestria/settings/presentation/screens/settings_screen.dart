import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_service.dart';
import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo_dark.dart';
import 'package:orkestria/orkestria/profile/domain/entities/profil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = true;
  bool notificationEnabled = true;
  String _errorMessage = '';
  String selectedLanguage = "English";
  String selectedZone = "El harach";
  final DashboardService dashboardService =
  DashboardService(dashboardDataSource: DashboardDataSourceApi());
  Profile? profile;
  DashboardStats? dashboardStats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await Future.wait([
        _fetchProfile(),
        _fetchDashboardData(),
      ]);
    } catch (error) {
      setState(() {
        _errorMessage = 'Error loading data: $error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProfile() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final bearerToken = sharedPreferences.getString('authToken');

    if (bearerToken != null) {
      final username = sharedPreferences.getString('username');
      var url = 'https://ms.camapp.dev.fortest.store/projects/keycloak/users/$username';
      final headers = {'Authorization': 'Bearer $bearerToken'};

      final response = await Dio().get(url, options: Options(headers: headers));
      if (response.statusCode == 200) {
        profile = Profile.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch profile');
      }
    } else {
      throw Exception('Bearer token not found');
    }
  }

  Future<void> _fetchDashboardData() async {
    dashboardStats = await dashboardService.fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    if (isLoading) {
      return Container(
          color: isDarkMode ? bgColor : Colors.white,
          child: Center(child: isDarkMode ? const LoaderWidget() : const LoaderDarkWidget()));
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return Scaffold(
      backgroundColor: isDarkMode ? bgColor : bgColorLight,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Settings", style: TextStyle(fontSize: 24)),
              ),
              _buildSettingsCard(themeController),
              const SizedBox(height: 16),
              _buildProfileCard(),
              const SizedBox(height: 16),
              _buildDashboardCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(ThemeController themeController) {
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsTile(
            title: "Language",
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              items: const [
                DropdownMenuItem(value: "English", child: Text("English")),
                DropdownMenuItem(value: "French", child: Text("French")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          SettingsTile(
            title: "Enable Dark Mode",
            trailing: Switch(
              value: themeController.isDarkMode,
              onChanged: (value) => themeController.toggleTheme(),
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          SettingsTile(
            title: "Enable Notifications",
            trailing: Switch(
              value: notificationEnabled,
              onChanged: (value) {
                setState(() {
                  notificationEnabled = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsTile(
            title: "Email",
            trailing: Text(profile?.email ?? "Not available"),
          ),
          const Divider(height: 1, color: Colors.white10),
          SettingsTile(
            title: "Username",
            trailing: Text(profile?.username ?? "Not available"),
          ),
          const Divider(height: 1, color: Colors.white10),
          const SettingsTile(
            title: "Roles : ",
            trailing: Text(""),
          ),
          for (var role in profile!.roles)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(role.name),
            ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard() {
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsTile(
            title: "Sites",
            trailing: Text('${dashboardStats?.projects ?? 0}'),
          ),
          const Divider(height: 1, color: Colors.white10),
          SettingsTile(
            title: "Cameras",
            trailing: Text('${dashboardStats?.cameras ?? 0}'),
          ),
          const Divider(height: 1, color: Colors.white10),
          SettingsTile(
            title: "Zones",
            trailing: Text('${dashboardStats?.zones ?? 0}'),
          ),
          const Divider(height: 1, color: Colors.white10),
          SettingsTile(
            title: "Boards",
            trailing: Text('${dashboardStats?.cards ?? 0}'),
          ),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final Widget child;
  const SettingsCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeController>(context).isDarkMode;
    return Card(
      color: isDarkMode ? secondaryColor : secondaryColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
  const SettingsTile({Key? key, required this.title, required this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          trailing,
        ],
      ),
    );
  }
}
