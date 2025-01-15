import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orkestria/orkestria/alerts/data/alerts_file.dart';
import '../../../../core/constants.dart';


class AlertsList extends StatelessWidget {
  const AlertsList({
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
            "Alerts",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: const [
                DataColumn(
                  label: Text("Event"),
                ),
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Time"),
                ),
              ],
              rows: List.generate(
                demoAlertList.length,
                (index) => recentFileDataRow(demoAlertList[index]),
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
