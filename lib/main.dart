import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/screens/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Satellite Visualizer',
      theme: ThemeData(
        primaryColor: Colors.blueGrey[700],
        accentColor: Colors.tealAccent[700],
      ),
      home: Dashboard(title: 'Image Satellite Visualizer'),
    );
  }
}