import 'package:flutter/material.dart';
import 'package:orkestria/orkestria/alerts/presentation/widgets/alerts_list.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
            children: [
              SizedBox(height: 56,),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: AlertsList(),
              ),
            ],
          )
      ),
    );
  }
}
