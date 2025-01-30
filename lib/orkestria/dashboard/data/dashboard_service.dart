import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/data/my_files.dart';
import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';

class DashboardService {
  final DashboardDataSourceApi dashboardDataSource;

  DashboardService({required this.dashboardDataSource});

  Future<DashboardStats?> fetchDashboardData() async {
    try {
      return await dashboardDataSource.fetchStats();
    } catch (e) {
      print("Error in DashboardService: $e");
      return null;
    }
  }

  Future<List<CloudStorageInfo>> fetchDashboardDataToWidget() async {
    DashboardStats? dashboardData = await fetchDashboardData();

    if (dashboardData == null) {
      return [];
    }

    return [
      CloudStorageInfo(
        title: "Sites",
        numOfFiles: "${dashboardData.projects} sites",
        svgSrc: "assets/icons/projects.svg",
        totalStorage: "",
        color: Color(0xFFAB4545),
      ),
      CloudStorageInfo(
        title: "Camera KPI",
        numOfFiles: "${dashboardData.cameraKpi} CKPI",
        svgSrc: "assets/icons/video.svg",
        totalStorage: "",
        color: Color(0xFFAB4545),
      ),
      CloudStorageInfo(
        title: "Cameras",
        numOfFiles: "${dashboardData.cameras} Cameras",
        svgSrc: "assets/icons/camera.svg",
        totalStorage: "",
        color: Color(0xFFAB4545),
      ),
      CloudStorageInfo(
        title: "Alerts",
        numOfFiles: "${dashboardData.alerts} Alerts",
        svgSrc: "assets/icons/alert.svg",
        totalStorage: "",
        color: Color(0xFFAB4545),
      ),
    ];
  }
}
