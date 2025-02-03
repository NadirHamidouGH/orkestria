import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/camera%20kpi/domain/entities/camera.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/screens/camera_live_view.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';

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
    _camerasFuture = fetchCameras(_currentPage);
  }

  Future<List<Camera>> fetchCameras(int page) async {
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
        'https://ms.camapp.dev.fortest.store/projects/cameras/?skip=${page * _itemsPerPage}&limit=$_itemsPerPage',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
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

  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _camerasFuture = fetchCameras(_currentPage);
    });
  }

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
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(paddingHalf),
      decoration: BoxDecoration(
        color: isDarkMode ? secondaryColor : secondaryColorLight,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cameras",
            style: TextStyle(fontSize: 24),
            // style: heading2,
          ),
          FutureBuilder<List<Camera>>(
            future: _camerasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  // child: Column(
                  //   children: [
                  child: LoaderWidget(),
                      // Spacer()
                  //   ],
                  // ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No cameras found.'));
              }

              final cameras = snapshot.data!;

              return SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: defaultPadding,
                  columns: const [
                    DataColumn(label: Text("Camera")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows: cameras.map((camera) => cameraDataRow(camera)).toList(),
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
    );
  }

  DataRow cameraDataRow(Camera camera) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              SvgPicture.asset(
                color: Colors.grey,
                'assets/icons/camera.svg', // Replace with your actual path
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
        DataCell(
          Text(
            camera.description,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraLiveView(videoUrl: 'https://file-examples.com/storage/fed070a54267a0d1f9ebf9a/2017/04/file_example_MP4_480_1_5MG.mp4' , cameraName: camera.name,),
                ),
              );
            },
            child: Text(
              camera.status ,
              style: TextStyle(fontSize: 12 , fontWeight: FontWeight.w700 ,color: camera.status.toString() == "online" ? Colors.green: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
