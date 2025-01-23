import 'package:flutter/material.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/core/utils/colors.dart';
import 'package:orkestria/orkestria/profile/domain/entities/profil.dart';

class AboutSection extends StatelessWidget {
  final Profile profile;
  const AboutSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 1,
      child: Card(
        margin: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          right: 20,
          left: 20,
        ),
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
              profile.username,
            style: subtitle2,
          ),
        ),
      ),
    );
  }
}