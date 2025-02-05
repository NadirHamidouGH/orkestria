import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider instead of direct import.
import 'package:orkestria/orkestria/alerts/presentation/routes/alerts_route.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/routes/camera_kpi_route.dart';
import 'package:orkestria/orkestria/projects/presentation/routes/projects_route.dart';
import 'package:orkestria/orkestria/recording/presentation/routes/recording_route.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import '../../data/my_files.dart';

/// Displays information about a file or data category.
class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info; // Data for the card.

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return GestureDetector( // Makes the card tappable.
      onTap: () {
        switch (info.title) { // Navigate based on card title.
          case 'Sites':
            GoRouter.of(context).push(projectsRoutePath);
            break; // Important to prevent fallthrough!
          case 'Camera KPI':
            GoRouter.of(context).push(recordingRoutePath);
            break;
          case 'Cameras':
            GoRouter.of(context).push(cameraKpiRoutePath);
            break;
          case 'Alerts':
            GoRouter.of(context).push(alertsRoutePath);
            break;
          default:
          // Handle unknown titles or log a warning.
            print('Unknown route for title: ${info.title}'); // Or a more robust way to handle the unknown route.
        }
      },
      child: Container( // Container for styling.
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: isDarkMode ? secondaryColor : secondaryColorLight,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container( // Icon container.
                  padding: const EdgeInsets.all(defaultPadding * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    colorFilter:
                    ColorFilter.mode(info.color ?? Colors.black, BlendMode.srcIn),
                  ),
                ),
                Icon(Icons.more_vert, // More options icon.
                    color: isDarkMode ? Colors.white54 : Colors.black87) // NOTE: Consider making the icon color dynamic based on theme.
              ],
            ),
            Text( // Title text.
              info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row( // File count and storage info.
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.numOfFiles}",
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  info.totalStorage!,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// Displays a progress bar.
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color; // Color of the progress bar.
  final int? percentage; // Percentage of progress.

  @override
  Widget build(BuildContext context) {
    return Stack( // Use a Stack to create the progress bar effect.
      children: [
        Container( // Background track.
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder( // Builds the filled portion of the progress bar.
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}