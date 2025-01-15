import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orkestria/orkestria/camera%20kpi/data/camera_kpi_file.dart';
import '../../../../core/constants.dart';


class CameraList extends StatelessWidget {
  const CameraList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(paddingHalf),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Camera KPI",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: const [
                DataColumn(
                  label: Text("Camera"),
                ),
                DataColumn(
                  label: Text("KPI"),
                ),
                DataColumn(
                  label: Text("Events"),
                ),
              ],
              rows: List.generate(
                demoCameraKpiList.length,
                (index) => recentFileDataRow(demoCameraKpiList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              color: Colors.grey,
              fileInfo.icon!,
              height: 18,
              width: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.title!,
                          style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date!, style: const TextStyle(fontSize: 12),),),
      DataCell(Text(fileInfo.size!, style: const TextStyle(fontSize: 12),)),
    ],
  );
}
