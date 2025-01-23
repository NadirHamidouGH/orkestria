import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/profile/domain/entities/profil.dart';

import '../../../../core/utils/colors.dart';

class ContactSection extends StatelessWidget {
  final Profile profile;

  const ContactSection({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${profile.firstName} ${profile.lastName}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            ListTile(
              title: const Text('Username'),
              subtitle: Text(profile.username),
            ),

            ListTile(
              title: const Text('Email'),
              subtitle: Text(profile.email),
            ),


            const SizedBox(height: 8),

            // Displaying the status (enabled/disabled)
            Text('Status: ${profile.enabled ? 'Activé' : 'Désactivé'}'),
            const SizedBox(height: 16),

            // Displaying roles with heading and Divider
            const Text(
              'Roles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 1.0),
            for (var role in profile.roles)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(role.name),
              ),

            const SizedBox(height: 16),

            // Displaying groups with heading and Divider
            const Text(
              'Groups',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 1.0),
            for (var group in profile.groups)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(group.name),
              ),
          ],
        ),
      ),
    );
  }
}