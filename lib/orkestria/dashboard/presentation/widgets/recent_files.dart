import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orkestria/orkestria/alerts/domain/entities/alert.dart';
import '../../../../core/constants.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({Key? key}) : super(key: key);

  @override
  _RecentFilesState createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  late Future<List<Alert>> _recentFilesFuture;

  @override
  void initState() {
    super.initState();
    _recentFilesFuture = fetchRecentFiles();
  }

  Future<List<Alert>> fetchRecentFiles() async {
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
        'https://ms.camapp.dev.fortest.store/projects/alerts/?skip=0&limit=4', // Use the same endpoint as AlertsList
        options: Options(
          method: 'GET',
          headers: headers,
        ),
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
    return FutureBuilder<List<Alert>>(
      future: _recentFilesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recent files found.'));
        } else {
          List<Alert> recentFiles = snapshot.data!;
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
                  "Notifications",
                  style: subtitle1,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: const [
                      DataColumn(
                        label: Text(
                          "Event",
                          style: subtitle1Regular,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Date",
                          style: subtitle1Regular,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Time",
                          style: subtitle1Regular,
                        ),
                      ),
                    ],
                    rows: List.generate(
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

  DataRow recentFileDataRow(Alert alert) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              SvgPicture.asset(
                color: Colors.grey,
                "assets/icons/alert.svg", // You can replace with the appropriate icon for the recent files
                height: 18,
                width: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  alert.message?.split(' ').take(3).join(' ') ?? '',
                  style: bodyText2,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            alert.createdAt.length > 10
                ? alert.createdAt.substring(0, 10)
                : alert.createdAt,
            style: bodyText2,
          ),
        ),
        DataCell(
          Text(
            alert.createdAt.length > 10
                ? alert.createdAt.substring(11,16) // Extract the time from the timestamp
                : '',
            style: bodyText2,
          ),
        ),
      ],
    );
  }
}
