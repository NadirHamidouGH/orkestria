class RecentFile {
  final String? icon, title, date, size;

  RecentFile({this.icon, this.title, this.date, this.size});
}

List demoRecentFiles = [
  RecentFile(
    icon: "assets/icons/video.svg",
    title: "Video record",
    date: "01-03-2025",
    size: "10:00",
  ),
  RecentFile(
    icon: "assets/icons/alert.svg",
    title: "Sensor alert",
    date: "27-02-2025",
    size: "11:22",
  ),
  RecentFile(
    icon: "assets/icons/alert.svg",
    title: "Sensor alert",
    date: "23-02-2025",
    size: "00:21",
  ),
];
