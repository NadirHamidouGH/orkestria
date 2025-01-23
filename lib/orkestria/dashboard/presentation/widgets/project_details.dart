import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:dio/dio.dart';
import 'package:orkestria/orkestria/projects/domain/entities/project.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';

// Service for fetching projects via API
Future<List<Project>> fetchProjects() async {
  final dio = Dio();
  final sharedPreferences = await SharedPreferences.getInstance();
  final bearerToken = sharedPreferences.getString('authToken');

  if (bearerToken == null || bearerToken.isEmpty) {
    throw Exception('Authentication token is missing. Please log in again.');
  }

  var headers = {
    'Authorization': 'Bearer $bearerToken',
  };

  try {
    var response = await dio.request(
      'https://ms.camapp.dev.fortest.store/projects/projects/',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
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

// Widget to display dynamic projects
class DynamicProjectList extends StatefulWidget {
  const DynamicProjectList({Key? key}) : super(key: key);

  @override
  _DynamicProjectListState createState() => _DynamicProjectListState();
}

class _DynamicProjectListState extends State<DynamicProjectList> {
  List<Project> _projects = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<Project> projects = await fetchProjects();
      setState(() {
        _projects = projects;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load projects: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Projects',
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // const SizedBox(height: defaultPadding),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _projects.map((project) {
                return Padding(
                  padding: const EdgeInsets.only(right: defaultPadding),
                  child: ProjectDetails(
                    projectName: project.name,
                    description: project.status ?? "----",
                    iconsData: [
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

// Widget for each project details
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
      width: 200,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: iconsData.map((data) {
              return Column(
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
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
