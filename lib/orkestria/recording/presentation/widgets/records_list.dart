import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart'; // NOTE: Consider injecting Dio instance.
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo.dart';
import 'package:orkestria/orkestria/recording/domain/entities/record.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';

/// Widget displaying a list of camera records.
class RecordsList extends StatefulWidget {
  const RecordsList({super.key});

  @override
  _RecordsListState createState() => _RecordsListState();
}

class _RecordsListState extends State<RecordsList> {
  int _currentPage = 0; // Current page number.
  final int _itemsPerPage = 9; // Number of items per page.
  Future<List<Records>>? _recordsFuture; // Future for fetching records.

  @override
  void initState() {
    super.initState();
    _recordsFuture = fetchRecords(_currentPage); // Fetch initial records.
  }

  /// Fetches records from the API with pagination.
  Future<List<Records>> fetchRecords(int page) async {
    final dio = Dio(); // NOTE: Consider injecting Dio instance.
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
    List<dynamic> jsonData = response.data["data"]; // Access the "data" field.
    return jsonData.map((record) => Records.fromJson(record)).toList();
    } else {
    throw Exception('Failed to load records: ${response.statusMessage}');
    }
    } catch (e) {
    throw Exception('Error fetching records: ${e.toString()}'); // NOTE: Consider more specific error handling.
    }
  }

  /// Loads the next page of records.
  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _recordsFuture = fetchRecords(_currentPage);
    });
  }

  /// Loads the previous page of records.
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
    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return Container( // Container for styling.
      padding: const EdgeInsets.all(paddingHalf),
      decoration: BoxDecoration(
        color: isDarkMode ? secondaryColor : secondaryColorLight,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView( // Allows vertical scrolling.
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text( // Title.
              "Camera KPI",
              style: TextStyle(fontSize: 24),
            ),
            FutureBuilder<List<Records>>( // Build UI based on future.
              future: _recordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) { // Show loading indicator.
                  return const Center(
                      child: Column(
                        children: [
                          LoaderWidget(),
                          Spacer()
                        ],
                      ));
                } else if (snapshot.hasError) { // Show error message.
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // Show "no records" message.
                  return const Center(child: Text('No records found.'));
                }

                final records = snapshot.data!; // Get the records data.

                return SizedBox( // Table of records.
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 4,
                    columns: const [ // Table columns.
                      DataColumn(
                        label: Text("Object"),
                      ),
                      DataColumn(
                        label: Text("Date"),
                      ),
                      DataColumn(
                        label: Text("IC"),
                      ),
                      DataColumn(
                        label: Text("Image"),
                      ),
                    ],
                    rows: records.map((record) => recordDataRow(record)).toList(), // Generate table rows.
                  ),
                );
              },
            ),
            Row( // Pagination buttons.
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

  /// Builds a DataRow for a record.
  DataRow recordDataRow(Records record) {
    return DataRow(
      cells: [
        DataCell( // Object cell.
          Row(
            children: [
              SvgPicture.asset(
                color: Colors.grey, // NOTE: Consider making this color dynamic.
                'assets/icons/record.svg',
                height: 18,
                width: 18,
              ),
              Text(
                textAlign: TextAlign.left,
                record.objectClass,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        DataCell( // Date cell.
          Text(
            record.capturedAt.toIso8601String().split('T')[0],
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell( // IC cell.
          Text(
            textAlign: TextAlign.center,
            record.confidence.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell( // Image cell.
          IconButton(
            icon: const Icon(LucideIcons.image),
            onPressed: () {
              showDialog( // Show image in a modal dialog.
                context: context,
                builder: (BuildContext context) {
                  return ImageModal(imageUrl: truncateString(record.imagePath)); // Pass truncated URL.
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Truncates the image URL to remove query parameters.
String truncateString(String inputString) {
  int index = inputString.indexOf("?response-content-type=");
  if (index != -1) {
    return inputString.substring(0, index);
  } else {
    return inputString;
  }
}

/// Modal dialog displaying an image.
class ImageModal extends StatefulWidget {
  final String imageUrl;

  const ImageModal({super.key, required this.imageUrl});

  @override
  State<ImageModal> createState() => _ImageModalState();
}

class _ImageModalState extends State<ImageModal> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    // Simulate loading delay (replace with your actual image loading logic)
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: LoaderWidget())
            : InteractiveViewer(
          maxScale: 4.0, // Adjust max zoom level as needed
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

