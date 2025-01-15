import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants.dart';
import '../../data/recent_file.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
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
          const Text(
            "Notifications",
            style: subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: const [
                DataColumn(
                  label: Text("Event", style: subtitle1Regular,),
                ),
                DataColumn(
                  label: Text("Date", style: subtitle1Regular,),
                ),
                DataColumn(
                  label: Text("Time", style: subtitle1Regular,),
                ),
              ],
              rows: List.generate(
                demoRecentFiles.length,
                (index) => recentFileDataRow(demoRecentFiles[index]),
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
                          style: bodyText2,
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date!, style: bodyText2),),
      DataCell(Text(fileInfo.size!, style: bodyText2)),
    ],
  );
}
