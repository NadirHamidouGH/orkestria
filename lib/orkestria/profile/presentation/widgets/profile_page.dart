import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/orkestria/profile/domain/entities/profil.dart';
import 'package:orkestria/orkestria/profile/presentation/widgets/about_section.dart';
import 'package:orkestria/orkestria/profile/presentation/widgets/contact_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Tab> tabs = [
    const Tab(
      text: "Profile",
      icon: Icon(
        LucideIcons.user,
        color: Colors.white,
      ),
    ),
    const Tab(
      text: "Info",
      icon: Icon(
        LucideIcons.info,
        color: Colors.white,
      ),
    ),
  ];

  Profile? profile;

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // Fetch profile data when the widget initializes
  }

  Future<void> _fetchProfile() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final bearerToken = sharedPreferences.getString('authToken');

      if (bearerToken != null) {
        final fetchedProfile = await fetchProfile(bearerToken);
        setState(() {
          profile = fetchedProfile; // Save the fetched profile data
        });
      } else {
        print('Bearer token not found');
      }
    } catch (error) {
      print('Error fetching profile: $error');
    }
  }

  Future<Profile> fetchProfile(String token) async {
    const url = 'https://ms.camapp.dev.fortest.store/projects/keycloak/users/abdelhak';
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await Dio().get(url, options: Options(headers: headers));
    if (response.statusCode == 200) {
      return Profile.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
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
                  child: stats(profile!),
                ),
              ],
            ):const Center(child: CircularProgressIndicator()),
          ),
          bottom: TabBar(
            tabs: tabs,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
          ),
        ),
        body: profile == null
            ? const Center(child: SizedBox()) // Show loading indicator while data is fetched
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
    return const Padding(
      padding: EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
      child: Text(
        "CP Alger",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Padding profileName(Profile profile) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        "${profile.firstName} ${profile.lastName}",
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Row stats(Profile profile) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              "Zones",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "3",
              style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Cameras",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "87",
              style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Sensors",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "150",
              style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
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
        backgroundImage: NetworkImage(
          "https://picsum.photos/300/300",
        ),
      ),
    );
  }
}
