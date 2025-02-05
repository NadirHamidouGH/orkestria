import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_service.dart';
import 'package:orkestria/orkestria/dashboard/data/my_files.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/project_details.dart'; // NOTE: Unused import.
import '../../../../core/constants.dart';
import '../../../../core/utils/responsive.dart';
import 'file_info_card.dart';
import 'load_widget_grid.dart';

/// Widget displaying information about files/data categories.
class MyFiles extends StatelessWidget {
  const MyFiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size; // Get screen size.
    return Column(
      children: [
        const Row( // Header row with title.
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Sites",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding), // Spacing.
        const DynamicProjectList(), // List of dynamic projects.
        const SizedBox(height: defaultPadding), // Spacing.
        Responsive( // Responsive grid view for file info cards.
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4, // Adjust columns based on screen width.
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1, // Adjust aspect ratio based on screen width.
          ),
          tablet: const FileInfoCardGridView(), // Default for tablet.
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4, // Adjust aspect ratio for desktop.
          ),
        ),
      ],
    );
  }
}

/// Grid view displaying file info cards.
class FileInfoCardGridView extends StatefulWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4, // Default number of columns.
    this.childAspectRatio = 1, // Default aspect ratio.
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<FileInfoCardGridView> createState() => _FileInfoCardGridViewState();
}

class _FileInfoCardGridViewState extends State<FileInfoCardGridView> {
  bool _isLoading = true; // Loading state.
  late Future<List<CloudStorageInfo>> _dashboardDataFuture; // Future for data.

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = DashboardService(dashboardDataSource: DashboardDataSourceApi()).fetchDashboardDataToWidget(); // Fetch data.
    _startLoading(); // Simulate loading delay.
  }

  /// Simulates a loading delay.
  void _startLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false; // Set loading to false after delay.
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) { // Show loading indicator if loading.
      return SizedBox( // Sized box to prevent layout issues during loading.
        height: 300,
        width: 400,
        child: LoadingGridDashboard(),
      );
    }

    return FutureBuilder<List<CloudStorageInfo>>( // Build UI based on data.
      future: _dashboardDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { // Show indicator during data fetch.
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) { // Show error message if error occurred.
          return const Center(child: Text("Error loading data"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // Show message if no data.
          return const Center(child: Text("No data available"));
        }

        List<CloudStorageInfo> demoMyFiles = snapshot.data!; // Data from the snapshot.

        return GridView.builder( // Grid view for the file info cards.
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling within the grid.
          shrinkWrap: true, // Prevents unbounded height.
          itemCount: demoMyFiles.length, // Number of items.
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // Grid layout.
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            childAspectRatio: widget.childAspectRatio,
          ),
          itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]), // Build each card.
        );
      },
    );
  }
}