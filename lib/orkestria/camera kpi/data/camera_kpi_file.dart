class RecentFile {
  final String? icon, title, date, size;

  RecentFile({this.icon, this.title, this.date, this.size});
}

List demoCameraKpiList = [
  RecentFile(
    icon: "assets/icons/camera.svg",
    title: "camera 1",
    date: "01025",
    size: "100",
  ),
  RecentFile(
    icon: "assets/icons/camera.svg",
    title: "camera 2",
    date: "27025",
    size: "112",
  ),
  RecentFile(
    icon: "assets/icons/camera.svg",
    title: "camera 3",
    date: "23025",
    size: "00",
  ),
];
