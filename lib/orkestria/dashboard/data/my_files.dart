import 'package:flutter/material.dart';

import '../../../core/constants.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final String? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Projects",
    numOfFiles: "3 projets",
    svgSrc: "assets/icons/projects.svg",
    totalStorage: "",
    color: primaryColor,

  ),
  CloudStorageInfo(
    title: "Records",
    numOfFiles: "14",
    svgSrc: "assets/icons/video.svg",
    totalStorage: "2.9GB",
    color: Color(0xFFFFA113),
  ),
  CloudStorageInfo(
    title: "Borads",
    numOfFiles: "12 Board",
    svgSrc: "assets/icons/marker.svg",
    totalStorage: "3 zones",
    color: Color(0xFF2C8025),
  ),
  CloudStorageInfo(
    title: "Alerts",
    numOfFiles: "emergencies",
    svgSrc: "assets/icons/alert.svg",
    totalStorage: "2",
    color: Color(0xFFDE203C),
  ),
];
