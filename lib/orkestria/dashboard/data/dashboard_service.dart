import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/dashboard/data/dashboard_datasource.dart';
import 'package:orkestria/orkestria/dashboard/data/my_files.dart';
import 'package:orkestria/orkestria/dashboard/domain/entities/dashboard_stats.dart';

/// Service for fetching and processing dashboard data.
class DashboardService {
  final DashboardDataSourceApi dashboardDataSource; // Data source for dashboard data.

  DashboardService({required this.dashboardDataSource});

  /// Fetches dashboard statistics.
  Future<DashboardStats?> fetchDashboardData() async {
    try {
      return await dashboardDataSource.fetchStats();
    } catch (e) {
      print("Error in DashboardService: $e"); // Log the error.
      return null; // Return null on error.
    }
  }

  /// Transforms dashboard data into a list of CloudStorageInfo objects.
  Future<List<CloudStorageInfo>> fetchDashboardDataToWidget() async {
    DashboardStats? dashboardData = await fetchDashboardData();

    if (dashboardData == null) {
      return []; // Return empty list if data is null.
    }

    // NOTE: Consider making the colors configurable (perhaps as parameters or via a theme).
    // Hardcoding colors makes the widget less flexible.
    return [
      CloudStorageInfo(
        title: "Sites",
        numOfFiles: "${dashboardData.projects} sites",
        svgSrc: "assets/icons/projects.svg",
        totalStorage: "", // Consider what to display here if not total storage.
        color: const Color(0xFFAB4545), // Hardcoded color.
      ),
      CloudStorageInfo(
        title: "Camera KPI",
        numOfFiles: "${dashboardData.cameraKpi} CKPI",
        svgSrc: "assets/icons/video.svg",
        totalStorage: "", // Consider what to display here if not total storage.
        color: const Color(0xFFAB4545), // Hardcoded color.
      ),
      CloudStorageInfo(
        title: "Cameras",
        numOfFiles: "${dashboardData.cameras} Cameras",
        svgSrc: "assets/icons/camera.svg",
        totalStorage: "", // Consider what to display here if not total storage.
        color: const Color(0xFFAB4545), // Hardcoded color.
      ),
      CloudStorageInfo(
        title: "Alerts",
        numOfFiles: "${dashboardData.alerts} Alerts",
        svgSrc: "assets/icons/alert.svg",
        totalStorage: "", // Consider what to display here if not total storage.
        color: const Color(0xFFAB4545), // Hardcoded color.
      ),
    ];
  }
}