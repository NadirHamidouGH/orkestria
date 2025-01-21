import 'package:flutter/material.dart';
import '../widgets/records_list.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SizedBox(height: 56,),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: RecordsList(),
          ),
        ],
      ),
    );
  }
}
