import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/orkestria/profile/presentation/widgets/about_section.dart';
import 'package:orkestria/orkestria/profile/presentation/widgets/contact_section.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          automaticallyImplyLeading : false,
          backgroundColor: bgColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
          ),
          toolbarHeight: 180,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                profilePhotos(),
                profileName(),
                hobbies(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: stats(),
                ),
              ],
            ),
          ),
          bottom: TabBar(
            tabs: tabs,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: contactSection(),
            ),
            const SingleChildScrollView(
              child: AboutSection(),
            ),
          ],
        ),
      ),
    );
  }

  Padding hobbies() {
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
          color: Colors.grey
        ),
      ),
    );
  }

  Padding profileName() {
    return const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        "Nadir HAMIDOU",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Row stats() {
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

  Container profilePhotos() {
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