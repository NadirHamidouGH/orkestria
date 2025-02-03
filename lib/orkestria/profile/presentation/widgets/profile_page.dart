import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_service.dart';
import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo.dart';
import 'package:orkestria/orkestria/profile/domain/entities/profil.dart';
import 'package:orkestria/orkestria/profile/presentation/widgets/about_section.dart';
import 'package:orkestria/orkestria/profile/presentation/widgets/contact_section.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Tab> tabs = [
     Tab(
      text: "Profile",
      icon: Icon(
        LucideIcons.user,
        // color: Colors.white,
      ),
    ),
     Tab(
      text: "Info",
      icon: Icon(
        LucideIcons.info,
        // color: Colors.white,
      ),
    ),
  ];

  final DashboardService dashboardService =
  DashboardService(dashboardDataSource: DashboardDataSourceApi());


  Profile? profile;
  DashboardStats? dashboardStats;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchDashboardData();
  }

  Future<void> _fetchProfile() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final bearerToken = sharedPreferences.getString('authToken');

      if (bearerToken != null) {
        final fetchedProfile = await fetchProfile(bearerToken);
        setState(() {
          profile = fetchedProfile;
        });
      } else {
        print('Bearer token not found');
      }
    } catch (error) {
      print('Error fetching profile: $error');
    }
  }

  Future<void> _fetchDashboardData() async {
    try {
      final stats = await dashboardService.fetchDashboardData();
      setState(() {
        dashboardStats = stats;
      });
    } catch (error) {
      print('Error fetching dashboard data: $error');
    }
  }

  Future<Profile> fetchProfile(String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('username');
    var url = 'https://ms.camapp.dev.fortest.store/projects/keycloak/users/$username';
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response =
    await Dio().get(url, options: Options(headers: headers));
    if (response.statusCode == 200) {
      return Profile.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          automaticallyImplyLeading: false,
          backgroundColor: isDarkMode ? bgColor : bgColor.withOpacity(0.4),
          titleTextStyle: const TextStyle(
            // color: Colors.white,// example 1
            // fontWeight: FontWeight.w700,
          ),
          toolbarHeight: 180,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: profile != null ? Column(

              children: [
                profilePhotos(profile!),
                profileName(profile!),
                hobbies(profile!),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: stats(profile!,dashboardStats!),
                ),
              ],
            ):const Center(child: LoaderWidget()),
          ),
          bottom: TabBar(
            tabs: tabs,
            indicatorColor: isDarkMode ? Colors.white : Colors.black87,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        body: profile == null
            ? const Center(child: SizedBox())
            : TabBarView(
          children: [
            SingleChildScrollView(
              child: ContactSection(profile: profile!),
            ),
            SingleChildScrollView(
              child: AboutSection(profile: profile!),
            ),
          ],
        ),
      ),
    );
  }

  Padding hobbies(Profile profile) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
      child: Text(
        profile.email,
        // style: const TextStyle(
        //   fontWeight: FontWeight.normal,
        //   fontSize: 14,
        //   color: Colors.grey,
        // ),
      ),
    );
  }

  Padding profileName(Profile profile) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        profile.username,
      ),
    );
  }

  Row stats(Profile profile,DashboardStats stats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Text(
              "Zones",
              // style: TextStyle(
              //   color: Colors.white,
              //   fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 8.0),
            Text(
              stats.zones.toString(),
              // style: const TextStyle(
              // fontWeight: FontWeight.normal,
              // color: Colors.grey),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              "Cameras",
              // style: TextStyle(
              //   color: Colors.white,
              //   fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 8.0),
            Text(
              stats.cameras.toString(),
            ),
          ],
        ),
         Column(
          children: [
            const Text(
              "Sensors",
              // style: TextStyle(
              //   color: Colors.white,
              //   fontWeight: FontWeight.bold,
              // ),
            ),
            const SizedBox(height: 8.0),
            Text(
              stats.sensors.toString(),
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }

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
        radius: 50,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage("https://picsum.photos/300/300"),
      ),
    );
  }
}
