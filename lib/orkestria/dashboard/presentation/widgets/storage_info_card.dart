import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants.dart';

/// A widget displaying storage information.
class StorageInfoCard extends StatelessWidget {
  StorageInfoCard({
    Key? key,
    required this.title, // Title of the storage item.
    required this.svgSrc, // SVG icon source.
    required this.amountOfFiles, // Amount of files (e.g., percentage).
    required this.numOfFiles, // Number of files.
  }) : super(key: key);

  final String title, svgSrc, amountOfFiles;
  final int numOfFiles;

  @override
  Widget build(BuildContext context) {
    return Container( // Container for styling.
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey.withOpacity(0.3)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
        color: Colors.grey.withOpacity(0.2), // Background color. // NOTE: Consider making this color dynamic based on theme.
      ),
      child: Row(
        children: [
          SizedBox( // Icon container.
            height: 40,
            width: 40,
            child: SvgPicture.asset(
              svgSrc,
              color: Colors.red.shade400, // Icon color. // NOTE: Consider making this color dynamic based on theme.
            ),
          ),
          Expanded( // Expanded area for title and number of files.
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( // Title text.
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text( // Number of files text.
                    "$numOfFiles",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Text( // Amount of files text.
            amountOfFiles,
          )
        ],
      ),
    );
  }
}