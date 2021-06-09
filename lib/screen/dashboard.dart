import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/widget/image_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.01),
            child: TextButton(
              onPressed: () => print('cu'),
              child: Text(
                'DEMO',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.01),
            child: TextButton(
              onPressed: () => print('cu'),
              child: Icon(Icons.wifi, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(child: ImageCard()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('cu'),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
