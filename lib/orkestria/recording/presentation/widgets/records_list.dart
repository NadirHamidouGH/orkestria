import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:orkestria/orkestria/recording/domain/entities/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';

class RecordsList extends StatefulWidget {
  const RecordsList({Key? key}) : super(key: key);

  @override
  _RecordsListState createState() => _RecordsListState();
}

class _RecordsListState extends State<RecordsList> {
  int _currentPage = 0;
  final int _itemsPerPage = 12;
  Future<List<Records>>? _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = fetchRecords(_currentPage);
  }

  // Updated fetchRecords to include page-based fetching
  Future<List<Records>> fetchRecords(int page) async {
    final dio = Dio();
    final sharedPreferences = await SharedPreferences.getInstance();
    final bearerToken = sharedPreferences.getString('authToken');

    if (bearerToken == null || bearerToken.isEmpty) {
      throw Exception('Authentication token is missing. Please log in again.');
    }

    final headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      final response = await dio.request(
        'https://ms.camapp.dev.fortest.store/projects/cameras/data/?skip=${page * _itemsPerPage}&limit=$_itemsPerPage',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data["data"];
        return jsonData.map((record) => Records.fromJson(record)).toList();
      } else {
        throw Exception('Failed to load records: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching records: ${e.toString()}');
    }
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _recordsFuture = fetchRecords(_currentPage);
    });
  }

  void _loadPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _recordsFuture = fetchRecords(_currentPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(paddingHalf),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recordings",
              style: heading2,
            ),
            FutureBuilder<List<Records>>(
              future: _recordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Column(children: [
                          CircularProgressIndicator(),
                          Spacer()
                      ],)

                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No records found.'));
                }

                final records = snapshot.data!;

                return SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: const [
                      DataColumn(
                        label: Text("Object"),
                      ),
                      DataColumn(
                        label: Text("Date"),
                      ),
                      DataColumn(
                        label: Text("Confidence"),
                      ),
                    ],
                    rows: records.map((record) => recordDataRow(record)).toList(),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _loadPreviousPage,
                  tooltip: 'Previous Page',
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
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

  DataRow recordDataRow(Records record) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              SvgPicture.asset(
                color: Colors.grey,
                'assets/icons/record.svg', // Replace with your actual path
                height: 18,
                width: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  record.objectClass,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            record.capturedAt.toIso8601String().split('T')[0],
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            record.confidence.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
