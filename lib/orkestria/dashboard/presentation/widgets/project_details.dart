import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:dio/dio.dart'; // NOTE: Consider injecting Dio instance.
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:orkestria/orkestria/projects/domain/entities/project.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';
import 'load_widget_row.dart';

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
    var response = await dio.get( // Use dio.get for simplicity.
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
    throw Exception('Error fetching projects: ${e.toString()}');
  }
}

/// Displays a list of dynamic projects.
class DynamicProjectList extends StatefulWidget {
  const DynamicProjectList({Key? key}) : super(key: key);

  @override
  _DynamicProjectListState createState() => _DynamicProjectListState();
}

class _DynamicProjectListState extends State<DynamicProjectList> {
  List<Project> _projects = []; // List to store projects.
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
        _projects = projects; // Update the project list.
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
    if (_isLoading) { // Show loading indicator if loading.
      return SizedBox( // Sized box to prevent layout issues during loading.
          height: 200,
          width: 400,
          child: LoadingRowDashboard());
    }

    if (_errorMessage.isNotEmpty) { // Show error message if any.
      return Center(child: Text(_errorMessage));
    }

    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return Container( // Container for styling.
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: isDarkMode ? secondaryColor : secondaryColorLight,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView( // Allows horizontal scrolling of project cards.
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _projects.map((project) { // Map projects to ProjectDetails widgets.
                return Padding(
                  padding: const EdgeInsets.only(right: defaultPadding),
                  child: ProjectDetails(
                    projectName: project.name,
                    description: project.status ?? "----", // Display status or default.
                    iconsData: [ // Data for the icons.
                      {"icon": LucideIcons.cctv, "text": project.camerasCount.toString()},
                      {"icon": LucideIcons.map_pin, "text": project.zonesCount.toString()},
                      {"icon": LucideIcons.bell_dot, "text": project.hasAlerts.toString()},
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays details of a project.
class ProjectDetails extends StatelessWidget {
  const ProjectDetails({
    Key? key,
    required this.projectName,
    required this.description,
    required this.iconsData,
  }) : super(key: key);

  final String projectName;
  final String description;
  final List<Map<String, dynamic>> iconsData; // Data for the icons.

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return Container( // Container for styling.
      width: 200,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey.shade400.withOpacity(0.9),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
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
          Row( // Row for the icon and text data.
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: iconsData.map((data) {
              return Column(
                children: [
                  Icon( // Icon.
                    data["icon"] as IconData,
                    size: 30,
                    color: const Color(0xFFAB4545).withOpacity(0.8), // NOTE: Consider making this color dynamic.
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