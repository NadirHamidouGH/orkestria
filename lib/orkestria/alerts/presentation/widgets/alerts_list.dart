import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/alerts/domain/entities/alert.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';
import '../../../dashboard/presentation/widgets/load_widget_logo.dart';

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
    _alertsFuture = fetchAlerts(_currentPage);
  }

  Future<List<Alert>> fetchAlerts(int page) async {
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
        'https://ms.camapp.dev.fortest.store/projects/alerts/?skip=${page * _itemsPerPage}&limit=$_itemsPerPage',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
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

  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _alertsFuture = fetchAlerts(_currentPage);
    });
  }

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
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(paddingHalf),
      decoration: BoxDecoration(
        color: isDarkMode ? secondaryColor : secondaryColorLight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Alerts",
              style: TextStyle(fontSize: 24),
              // style: heading2,
            ),
            FutureBuilder<List<Alert>>(
              future: _alertsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoaderWidget());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No alerts found.'));
                }

                final alerts = snapshot.data!;
                return SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 4,
                    columns: const [
                      DataColumn(
                        label: Text("Event"),
                      ),
                      DataColumn(
                        label: Text("Date"),
                      ),
                      DataColumn(
                        label: Text("Status"),
                      ),
                    ],
                    rows: alerts.map((alert) => alertDataRow(alert)).toList(),
                  ),
                );
              },
            ),
            Row(
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

  DataRow alertDataRow(Alert alert) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
              const SizedBox(height: 8,),
              SvgPicture.asset(
                color: Colors.grey,
                "assets/icons/alert.svg", // Replace with a default path if needed
                height: 16,
                width: 16,
              ),

              ],),
              const SizedBox(width: 8), // Add spacing between icon and text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (alert.message ?? ''),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            (alert.createdAt.length > 10
                ? alert.createdAt.substring(0, 10)
                : alert.createdAt),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            alert.status ?? '',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

}
