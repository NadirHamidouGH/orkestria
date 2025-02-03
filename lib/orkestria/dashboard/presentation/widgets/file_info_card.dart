import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/alerts/presentation/routes/alerts_route.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/routes/camera_kpi_route.dart';
import 'package:orkestria/orkestria/projects/presentation/routes/projects_route.dart';
import 'package:orkestria/orkestria/recording/presentation/routes/recording_route.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants.dart';
import '../../data/my_files.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return GestureDetector(
      onTap: (){
        switch(info.title){
          case'Sites': GoRouter.of(context).push(projectsRoutePath);
          case'Camera KPI': GoRouter.of(context).push(recordingRoutePath);
          case'Cameras': GoRouter.of(context).push(cameraKpiRoutePath);
          case'Alerts': GoRouter.of(context).push(alertsRoutePath);
        }
      },
      child: Container(
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
                Container(
                  padding: const EdgeInsets.all(defaultPadding * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    colorFilter: ColorFilter.mode(
                        info.color ?? Colors.black, BlendMode.srcIn),
                  ),
                ),
                 Icon(Icons.more_vert, color: isDarkMode ? Colors.white54 : Colors.black54 )
              ],
            ),
            Text(
              info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              // style: subtitle1Regular,
            ),
            // ProgressLine(
            //   color: info.color,
            //   percentage: info.percentage,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.numOfFiles}",
                  style: TextStyle(fontSize: 12),
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .bodySmall!,
                ),
                Text(
                  info.totalStorage!,
                  style: TextStyle(fontSize: 12),
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .bodySmall!
                  //     .copyWith(color: Colors.white70),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
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
