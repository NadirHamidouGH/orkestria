import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_service.dart';
import 'package:orkestria/orkestria/dashboard/data/my_files.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/project_details.dart';
import '../../../../core/constants.dart';
import '../../../../core/utils/responsive.dart';
import 'file_info_card.dart';
import 'load_widget_grid.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Sites",
              style: subtitle1,
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        const DynamicProjectList(),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: const FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatefulWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<FileInfoCardGridView> createState() => _FileInfoCardGridViewState();
}

class _FileInfoCardGridViewState extends State<FileInfoCardGridView> {
  bool _isLoading = true;
  late Future<List<CloudStorageInfo>> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = DashboardService(dashboardDataSource: DashboardDataSourceApi()).fetchDashboardDataToWidget();
    _startLoading();
  }

  void _startLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 300,
        width: 400,
        child: LoadingGridDashboard(),
      );
    }

    return FutureBuilder<List<CloudStorageInfo>>(
      future: _dashboardDataFuture, // Call the service
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data available"));
        }

        List<CloudStorageInfo> demoMyFiles = snapshot.data!;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: demoMyFiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            childAspectRatio: widget.childAspectRatio,
          ),
          itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
        );
      },
    );
  }
}
