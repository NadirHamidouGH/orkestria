import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart'; // NOTE: Consider injecting Dio instance.
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orkestria/orkestria/alerts/domain/entities/alert.dart';
import '../../../../core/constants.dart';

/// Widget displaying recent alerts/notifications.
class RecentFiles extends StatefulWidget {
  const RecentFiles({Key? key}) : super(key: key);

  @override
  _RecentFilesState createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  late Future<List<Alert>> _recentFilesFuture; // Future for recent alerts.

  @override
  void initState() {
    super.initState();
    _recentFilesFuture = fetchRecentFiles(); // Fetch recent alerts on initialization.
  }

  /// Fetches recent alerts from the API.
  Future<List<Alert>> fetchRecentFiles() async {
    final dio = Dio(); // NOTE: Consider injecting Dio instance for better testing.
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
        'https://ms.camapp.dev.fortest.store/projects/alerts/?skip=0&limit=4', // Same endpoint as AlertsList.
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((file) => Alert.fromJson(file)).toList();
      } else {
        throw Exception('Failed to load recent files: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching recent files: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return FutureBuilder<List<Alert>>( // Build UI based on future.
      future: _recentFilesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { // Show empty SizedBox while loading.
          return const Center(child: SizedBox()); // Or a more appropriate loading indicator.
        } else if (snapshot.hasError) { // Show error message if error.
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // Show message if no data.
          return const Center(child: Text('No recent files found.'));
        } else {
          List<Alert> recentFiles = snapshot.data!; // Get the data.
          return Container( // Container for styling.
            padding: const EdgeInsets.all(paddingHalf),
            decoration: BoxDecoration(
              color: isDarkMode ? secondaryColor : secondaryColorLight,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text( // Title.
                  "Notifications",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox( // Table of recent alerts.
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: const [ // Table columns.
                      DataColumn(
                        label: Text("Event"),
                      ),
                      DataColumn(
                        label: Text("Date"),
                      ),
                      DataColumn(
                        label: Text("Time"),
                      ),
                    ],
                    rows: List.generate( // Generate table rows.
                      recentFiles.length,
                          (index) => recentFileDataRow(recentFiles[index]),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  /// Builds a DataRow for a recent alert.
  DataRow recentFileDataRow(Alert alert) {
    return DataRow(
      cells: [
        DataCell( // Event cell.
          Row(
            children: [
              SvgPicture.asset(
                color: const Color(0xFFAB4545).withOpacity(0.8), // NOTE: Consider making this color dynamic.
                "assets/icons/alert.svg",
                height: 14,
                width: 14,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  alert.message?.split(' ').take(3).join(' ') ?? '', // Display first 3 words of message.
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        DataCell( // Date cell.
          Text(
            alert.createdAt.length > 10
                ? alert.createdAt.substring(0, 10) // Extract date.
                : alert.createdAt,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell( // Time cell.
          Text(
            alert.createdAt.length > 10
                ? alert.createdAt.substring(11, 16) // Extract time.
                : '',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}