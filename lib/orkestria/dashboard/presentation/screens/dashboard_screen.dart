import 'package:flutter/material.dart';
import '../../../../core/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../widgets/header.dart';
import '../widgets/my_fields.dart';
import '../widgets/recent_files.dart';
import '../widgets/sensors_details.dart';

/// Screen displaying the main dashboard.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea( // Ensures content is within safe area.
      child: SingleChildScrollView( // Allows scrolling if content overflows.
        primary: false, // Prevents nested scrolling issues.
        padding: const EdgeInsets.all(defaultPadding), // Padding around the content.
        child: Column(
          children: [
            const Header(), // Header section.
            const SizedBox(height: defaultPadding), // Spacing.
            Row( // Main content layout (row for larger screens, column for smaller).
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start.
              children: [
                Expanded( // Left side content (files, recent files).
                  flex: 5, // Takes 5/7 of the available space on larger screens.
                  child: Column(
                    children: [
                      const MyFiles(), // My files widget.
                      const SizedBox(height: defaultPadding), // Spacing.
                      const RecentFiles(), // Recent files widget.
                      if (Responsive.isMobile(context)) // Conditional rendering for mobile.
                        const SizedBox(height: defaultPadding), // Spacing on mobile.
                      if (Responsive.isMobile(context)) SensorsDetails(), // Sensors details on mobile.
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context)) // Conditional rendering for larger screens.
                  const SizedBox(width: defaultPadding), // Spacing on larger screens.
                if (!Responsive.isMobile(context)) // Sensors details on larger screens.
                   Expanded(
                    flex: 2, // Takes 2/7 of the available space on larger screens.
                    child: SensorsDetails(), // Sensors details widget.
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}