import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:orkestria/orkestria/alerts/domain/entities/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';

class AlertsList extends StatefulWidget {
  const AlertsList({Key? key}) : super(key: key);

  @override
  _AlertsListState createState() => _AlertsListState();
}

class _AlertsListState extends State<AlertsList> {
  late Future<List<Alert>> _alertsFuture;

  @override
  void initState() {
    super.initState();
    _alertsFuture = fetchAlerts();
  }

  Future<List<Alert>> fetchAlerts() async {
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
        'https://ms.camapp.dev.fortest.store/projects/alerts/',
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Alert>>(
      future: _alertsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No alerts found.'));
        } else {
          List<Alert> alertList = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(paddingHalf),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Alerts",
                  style: heading2,
                ),
                SizedBox(
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
                    rows: List.generate(
                      alertList.length,
                          (index) => alertDataRow(alertList[index]),
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

  DataRow alertDataRow(Alert alert) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              SvgPicture.asset(
                color: Colors.grey,
                "assets/icons/alert.svg" ?? '', // Remplace avec un chemin par défaut si nécessaire
                height: 18,
                width: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  (alert.message ?? '')
                      .split(' ')
                      .take(3)
                      .join(' '),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            (alert.createdAt.length > 10 ? alert.createdAt.substring(0, 10) : alert.createdAt),
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
