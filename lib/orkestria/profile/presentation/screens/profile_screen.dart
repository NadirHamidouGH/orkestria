import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/profile/presentation/widgets/profile_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProfilePage(),
    );
  }
}
