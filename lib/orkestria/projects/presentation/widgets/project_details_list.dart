import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/constants.dart';

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({
    Key? key,
    required this.projectName,
    required this.description,
    required this.iconsData,
  }) : super(key: key);

  final String projectName;
  final String description;
  final List<Map<String, dynamic>> iconsData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                projectName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: defaultPadding / 2),
              Text(
                description,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: iconsData.map((data) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Icon(
                      data["icon"] as IconData,
                      size: 30,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data["text"].toString(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

      ),
    );
  }
}

class ProjectDetailsList extends StatelessWidget {
  const ProjectDetailsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      // decoration: const BoxDecoration(
      //   color: secondaryColor,
      //   borderRadius: BorderRadius.all(Radius.circular(10)),
      // ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 56,),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ProjectDetails(
                  projectName: "CP Alger",
                  description: "Project Description",
                  iconsData: [
                    {"icon": LucideIcons.cctv, "text": "8"},
                    {"icon": LucideIcons.map_pin, "text": "3"},
                    {"icon": LucideIcons.bell_dot, "text": "3"},
                  ],
                ),
                SizedBox(height: defaultPadding),
                ProjectDetails(
                  projectName: "CP Boumerdes",
                  description: "Project Description",
                  iconsData: [
                    {"icon": LucideIcons.cctv, "text": "5"},
                    {"icon": LucideIcons.map_pin, "text": "2"},
                    {"icon": LucideIcons.bell_dot, "text": "2"},
                  ],
                ),
                SizedBox(height: defaultPadding),
                ProjectDetails(
                  projectName: "CP Oran",
                  description: "Project Description",
                  iconsData: [
                    {"icon": LucideIcons.cctv, "text": "5"},
                    {"icon": LucideIcons.map_pin, "text": "10"},
                    {"icon": LucideIcons.bell_dot, "text": "4"},
                  ],
                ),
                SizedBox(width: defaultPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
