import 'package:dio/dio.dart'; // NOTE: Consider injecting Dio instance.
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:orkestria/orkestria/dashboard/data/dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_service.dart';
import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo.dart';
import 'package:orkestria/orkestria/profile/domain/entities/profil.dart';
import 'package:orkestria/orkestria/profile/presentation/widgets/about_section.dart';
import 'package:orkestria/orkestria/profile/presentation/widgets/contact_section.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Profile page widget.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Tab> tabs = [
    // Tabs for the TabBar.
    const Tab(
      text: "Profile",
      icon: Icon(LucideIcons.user),
    ),
    const Tab(
      text: "Info",
      icon: Icon(LucideIcons.info),
    ),
  ];

  final DashboardService dashboardService = // Dashboard service instance.
      DashboardService(dashboardDataSource: DashboardDataSourceApi());

  Profile? profile; // Profile data.
  DashboardStats? dashboardStats; // Dashboard statistics data.

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // Fetch profile data.
    _fetchDashboardData(); // Fetch dashboard data.
  }

  /// Fetches profile data.
  Future<void> _fetchProfile() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final bearerToken = sharedPreferences.getString('authToken');

      if (bearerToken != null) {
        final fetchedProfile =
            await fetchProfile(bearerToken); // Fetch profile.
        setState(() {
          profile = fetchedProfile; // Update profile state.
        });
      } else {
        print(
            'Bearer token not found'); // Log if token not found. // NOTE: Consider a more user-friendly message.
      }
    } catch (error) {
      print(
          'Error fetching profile: $error'); // Log error. // NOTE: Consider a more user-friendly message.
    }
  }

  /// Fetches dashboard data.
  Future<void> _fetchDashboardData() async {
    try {
      final stats =
          await dashboardService.fetchDashboardData(); // Fetch dashboard stats.
      setState(() {
        dashboardStats = stats; // Update dashboard stats state.
      });
    } catch (error) {
      print(
          'Error fetching dashboard data: $error'); // Log error. // NOTE: Consider a more user-friendly message.
    }
  }

  /// Fetches a profile using a token.
  Future<Profile> fetchProfile(String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('username');
    var url =
        'https://ms.camapp.dev.fortest.store/projects/keycloak/users/$username';
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await Dio().get(
      // NOTE: Consider injecting Dio instance.
      url,
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      return Profile.fromJson(response.data); // Return profile from JSON.
    } else {
      throw Exception(
          'Failed to fetch profile'); // Throw exception if fetch fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController =
        Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return DefaultTabController(
      // Tab controller for the profile page.
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          // App bar.
          elevation: 2,
          automaticallyImplyLeading: false, // Remove back button.
          backgroundColor: isDarkMode
              ? bgColor
              : secondaryColorLight, // Dynamic background color.
          toolbarHeight: 180, // Height of the toolbar.
          title: Padding(
            // Profile info in the app bar.
            padding: const EdgeInsets.only(top: 8.0),
            child: profile != null // Show profile info or loading indicator.
                ? Column(
                    children: [
                      profilePhotos(profile!),
                      profileName(profile!),
                      hobbies(profile!),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: stats(profile!, dashboardStats!),
                      ),
                    ],
                  )
                : const Center(child: LoaderWidget()), // Loading indicator.
          ),
          bottom: TabBar(
            // Tab bar.
            tabs: tabs,
            indicatorColor:
                isDarkMode ? Colors.white : Colors.black87, // Indicator color.
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor:
                isDarkMode ? Colors.white : Colors.black87, // Label color.
          ),
        ),
        body: profile == null // Show content based on profile data.
            ? const Center(child: SizedBox()) // Empty SizedBox while loading.
            : TabBarView(
                // Tab bar view.
                children: [
                  SingleChildScrollView(
                    // Scrollable content for Contact section.
                    child: ContactSection(profile: profile!),
                  ),
                  SingleChildScrollView(
                    // Scrollable content for About section.
                    child: AboutSection(profile: profile!),
                  ),
                ],
              ),
      ),
    );
  }

  /// Displays profile photo.
  Container profilePhotos(Profile profile) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      width: 70,
      height: 70,
      alignment: Alignment.center,
      child: const CircleAvatar(
        // NOTE: Consider making the image source dynamic.
        radius: 50,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage("https://picsum.photos/300/300"),
      ),
    );
  }

  /// Displays profile name.
  Padding profileName(Profile profile) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        profile.username,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  /// Displays user hobbies/email.
  Padding hobbies(Profile profile) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
      child: Text(
        profile.email,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  /// Displays user stats (zones, cameras, sensors).
  Row stats(Profile profile, DashboardStats stats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Text(
              "Zones",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8.0),
            Text(stats.zones.toString(), style: TextStyle(fontSize: 14)),
          ],
        ),
        Column(
          children: [
            const Text("Cameras", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8.0),
            Text(stats.cameras.toString(), style: TextStyle(fontSize: 14)),
          ],
        ),
        Column(
          children: [
            const Text("Sensors", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8.0),
            Text(
              stats.sensors.toString(),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
