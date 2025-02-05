import 'package:dio/dio.dart'; // NOTE: Consider injecting Dio instance.
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:orkestria/orkestria/projects/domain/entities/project.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../dashboard/presentation/widgets/load_widget_logo.dart';

/// Fetches projects from the API.
Future<List<Project>> fetchProjects() async {
  final dio = Dio(); // NOTE: Consider injecting Dio instance for testability.
  final sharedPreferences = await SharedPreferences.getInstance();
  final bearerToken = sharedPreferences.getString('authToken');

  if (bearerToken == null || bearerToken.isEmpty) {
    throw Exception('Authentication token is missing. Please log in again.');
  }

  var headers = {
    'Authorization': 'Bearer $bearerToken',
  };

  try {
    var response = await dio.get( // Use dio.get for simpler requests.
      'https://ms.camapp.dev.fortest.store/projects/projects/',
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data;
      return jsonData.map((project) => Project.fromJson(project)).toList();
    } else {
      throw Exception('Failed to load projects: ${response.statusMessage}');
    }
  } catch (e) {
    throw Exception('Error fetching projects: ${e.toString()}'); // NOTE: Consider more specific error handling.
  }
}

/// Widget to display a list of projects.
class ProjectDetailsList extends StatefulWidget {
  const ProjectDetailsList({Key? key}) : super(key: key);

  @override
  _ProjectDetailsListState createState() => _ProjectDetailsListState();
}

class _ProjectDetailsListState extends State<ProjectDetailsList> {
  List<Project> _projects = []; // List of projects.
  bool _isLoading = false; // Loading state.
  String _errorMessage = ''; // Error message.

  @override
  void initState() {
    super.initState();
    _loadProjects(); // Load projects on initialization.
  }

  /// Loads projects from the API.
  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<Project> projects = await fetchProjects(); // Fetch projects.
      setState(() {
        _projects = projects; // Update project list.
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load projects: ${e.toString()}'; // Set error message.
      });
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) { // Show loading indicator.
      return const Center(child: LoaderWidget());
    }

    if (_errorMessage.isNotEmpty) { // Show error message.
      return Center(child: Text(_errorMessage));
    }

    return SingleChildScrollView( // Enables scrolling if content overflows.
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24,
          ), // Spacing.
          const Padding( // "Sites" title.
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Sites',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // List of projects.
          ListView.builder(
            shrinkWrap: true, // Important: needed for nested lists.
            physics: const NeverScrollableScrollPhysics(), // Prevents scrolling of the inner list.
            itemCount: _projects.length,
            itemBuilder: (context, index) {
              final project = _projects[index];
              return ProjectDetails( // Display project details.
                projectName: project.name,
                description: project.status ?? "----",
                iconsData: [
                  {"icon": LucideIcons.cctv, "text": project.camerasCount.toString()},
                  {"icon": LucideIcons.map_pin, "text": project.zonesCount.toString()},
                  {"icon": LucideIcons.bell_dot, "text": project.hasAlerts.toString()},
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Widget to display details for a single project.
class ProjectDetails extends StatelessWidget {
  const ProjectDetails({
    super.key,
    required this.projectName,
    required this.description,
    required this.iconsData,
  });

  final String projectName;
  final String description;
  final List<Map<String, dynamic>> iconsData;

  @override
  Widget build(BuildContext context) {
    return Container( // Container for styling.
      margin: const EdgeInsets.all(8),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Expanded to take available space.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( // Project name.
                  projectName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: defaultPadding / 2), // Spacing.
                Text( // Project description.
                  description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: defaultPadding), // Spacing.
              ],
            ),
          ),
          Wrap( // Wrap for the icons.
            spacing: 8.0,
            runSpacing: 8.0,
            children: iconsData.map((data) {
              return Column(
                children: [
                  Icon( // Icon.
                    data["icon"] as IconData,
                    size: 30,
                    color: Colors.grey, // NOTE: Consider making this color dynamic.
                  ),
                  const SizedBox(height: 4), // Spacing.
                  Text( // Icon text.
                    data["text"].toString(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}