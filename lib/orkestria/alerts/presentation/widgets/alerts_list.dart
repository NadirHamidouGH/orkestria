import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider making ThemeController a provided dependency instead of relying on main.dart import.
import 'package:orkestria/orkestria/alerts/domain/entities/alert.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';
import '../../../dashboard/presentation/widgets/load_widget_logo.dart';

/// Widget displaying a paginated list of alerts.
class AlertsList extends StatefulWidget {
  const AlertsList({Key? key}) : super(key: key);

  @override
  _AlertsListState createState() => _AlertsListState();
}

class _AlertsListState extends State<AlertsList> {
  int _currentPage = 0;
  final int _itemsPerPage = 9;
  Future<List<Alert>>? _alertsFuture;

  @override
  void initState() {
    super.initState();
    _alertsFuture = fetchAlerts(_currentPage); // Fetch initial alerts.
  }

  /// Fetches alerts from the API.
  Future<List<Alert>> fetchAlerts(int page) async {
    final dio = Dio(); // NOTE: Consider injecting Dio instance.
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
        'https://ms.camapp.dev.fortest.store/projects/alerts/?skip=${page * _itemsPerPage}&limit=$_itemsPerPage',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((alert) => Alert.fromJson(alert)).toList();
      } else {
        throw Exception('Failed to load alerts: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching alerts: ${e.toString()}');
    }
  }

  /// Loads the next page of alerts.
  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _alertsFuture = fetchAlerts(_currentPage);
    });
  }

  /// Loads the previous page of alerts.
  void _loadPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _alertsFuture = fetchAlerts(_currentPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context); // Accessing ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return Container( // Container for styling.
      padding: const EdgeInsets.all(paddingHalf),
      decoration: BoxDecoration(
          color: isDarkMode ? secondaryColor : secondaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView( // Allows scrolling if content overflows.
        scrollDirection: Axis.vertical, // Vertical scrolling.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text( // Alerts title.
              "Alerts",
              style: TextStyle(fontSize: 24),
            ),
            FutureBuilder<List<Alert>>( // Builds UI based on future.
              future: _alertsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoaderWidget()); // Loading indicator.
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}')); // Error message.
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No alerts found.')); // Empty state message.
                }

                final alerts = snapshot.data!;
                return SizedBox( // Table of alerts.
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 4,
                    columns: const [ // Table columns.
                      DataColumn(label: Text("Event")),
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("Status")),
                    ],
                    rows: alerts.map((alert) => alertDataRow(alert)).toList(), // Generate table rows.
                  ),
                );
              },
            ),
            Row( // Pagination controls.
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _loadPreviousPage,
                  tooltip: 'Previous Page',
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _loadNextPage,
                  tooltip: 'Next Page',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a DataRow for an alert.
  DataRow alertDataRow(Alert alert) {
    return DataRow(
      cells: [
        DataCell( // Event cell.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [ // Icon column.
                const SizedBox(height: 8,),
                SvgPicture.asset(
                  color: Colors.grey,
                  "assets/icons/alert.svg", // Replace with a default path if needed
                  height: 16,
                  width: 16,
                ),

              ],),
              const SizedBox(width: 8), // Spacing.
              Expanded( // Expanded text.
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (alert.message ?? ''), // Display message or empty string.
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell( // Date cell.
          Text(
            (alert.createdAt.length > 10 // Format date.
                ? alert.createdAt.substring(0, 10)
                : alert.createdAt),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell( // Status cell.
          Text(
            alert.status ?? '', // Display status or empty string.
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}