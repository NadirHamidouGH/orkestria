import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/camera%20kpi/presentation/widgets/camera_kpi_list.dart';

class CameraKpiScreen extends StatefulWidget {
  const CameraKpiScreen({super.key});

  @override
  State<CameraKpiScreen> createState() => _CameraKpiScreenState();
}

class _CameraKpiScreenState extends State<CameraKpiScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
            children: [
              SizedBox(height: 56,),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: CameraList(),
              ),
            ],
          )
      ),
    );
  }
}
