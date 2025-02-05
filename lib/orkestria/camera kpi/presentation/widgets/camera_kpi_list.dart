import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart'; // NOTE: Consider injecting Dio instance.
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:orkestria/orkestria/camera%20kpi/domain/entities/camera.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/screens/camera_live_view.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';

/// Widget displaying a paginated list of cameras.
class CameraList extends StatefulWidget {
  const CameraList({Key? key}) : super(key: key);

  @override
  _CameraListState createState() => _CameraListState();
}

class _CameraListState extends State<CameraList> {
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  Future<List<Camera>>? _camerasFuture;

  @override
  void initState() {
    super.initState();
    _camerasFuture = fetchCameras(_currentPage); // Fetch initial cameras.
  }

  /// Fetches cameras from the API.
  Future<List<Camera>> fetchCameras(int page) async {
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
      final response = await dio.get( // Use dio.get for simplicity.
        'https://ms.camapp.dev.fortest.store/projects/cameras/?skip=${page * _itemsPerPage}&limit=$_itemsPerPage',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((camera) => Camera.fromJson(camera)).toList();
      } else {
        throw Exception('Failed to load cameras: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching cameras: ${e.toString()}');
    }
  }

  /// Loads the next page of cameras.
  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _camerasFuture = fetchCameras(_currentPage);
    });
  }

  /// Loads the previous page of cameras.
  void _loadPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _camerasFuture = fetchCameras(_currentPage);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text( // Cameras title.
            "Cameras",
            style: TextStyle(fontSize: 24),
          ),
          FutureBuilder<List<Camera>>( // Builds UI based on future.
            future: _camerasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: LoaderWidget()); // Loading indicator.
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Error message.
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No cameras found.')); // Empty state message.
              }

              final cameras = snapshot.data!;

              return SizedBox( // Table of cameras.
                width: double.infinity,
                child: DataTable(
                  columnSpacing: defaultPadding,
                  columns: const [ // Table columns.
                    DataColumn(label: Text("Camera")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows: cameras.map((camera) => cameraDataRow(camera)).toList(), // Generate table rows.
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
    );
  }

  /// Builds a DataRow for a camera.
  DataRow cameraDataRow(Camera camera) {
    return DataRow(
      cells: [
        DataCell( // Camera name cell.
          Row(
            children: [
              SvgPicture.asset(
                color: Colors.grey,
                'assets/icons/camera.svg',
                height: 18,
                width: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  camera.name,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        DataCell( // Description cell.
          Text(
            camera.description,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell( // Status cell with play button.
          GestureDetector(
            onTap: () {
              Navigator.push( // Navigate to CameraLiveView.
                context,
                MaterialPageRoute(
                  builder: (context) => CameraLiveView(
                    videoUrl: 'https://file-examples.com/storage/fed070a54267a0d1f9ebf9a/2017/04/file_example_MP4_480_1_5MG.mp4', // NOTE: Hardcoded video URL - BAD PRACTICE. Should come from the camera object.
                    cameraName: camera.name,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  color: Colors.green.shade400,
                  'assets/icons/play.svg',
                  height: 14,
                  width: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    camera.status,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}