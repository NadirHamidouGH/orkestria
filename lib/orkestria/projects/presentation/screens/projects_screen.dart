import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/projects/presentation/widgets/project_details_list.dart';


class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    // Fetch the projects when the screen is first loaded
    return const Scaffold(
      body:  ProjectDetailsList(),

    );
  }
}
