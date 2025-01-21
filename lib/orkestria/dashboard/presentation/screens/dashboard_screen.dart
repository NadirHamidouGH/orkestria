import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/projects/presentation/project_provider/project_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../widgets/header.dart';
import '../widgets/my_fields.dart';
import '../widgets/recent_files.dart';
import '../widgets/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the projects when the screen is first loaded
    // Future<void> fetchProjects() async {
    //   await context.read<ProjectProvider>().fetchProjects();
    // }
    //
    // // Call _fetchProjects when the widget is built
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   fetchProjects();
    // });

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const MyFiles(),
                      const SizedBox(height: defaultPadding),
                      const RecentFiles(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) const StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
