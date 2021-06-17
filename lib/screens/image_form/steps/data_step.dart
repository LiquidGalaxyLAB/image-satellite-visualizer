import 'package:flutter/material.dart';

class DataStep extends StatefulWidget {
  const DataStep({Key? key}) : super(key: key);

  @override
  _DataStepState createState() => _DataStepState();
}

class _DataStepState extends State<DataStep> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: screenSize.height * 0.5,
            width: screenSize.width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Location',
                  style: TextStyle(fontSize: screenSize.height * 0.05),
                ),
                Text(
                  'Select the location that you want to query',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                TextField(
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintText: 'Longitude',
                    labelText: 'Longitude',
                  ),
                ),
                TextField(
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintText: 'Latitude',
                    labelText: 'Latitude',
                  ),
                ),
                Center(
                  child: OutlinedButton(
                    child: Text('GET LOCATIONS'),
                    onPressed: () => print('maps'),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: screenSize.height * 0.5,
            width: screenSize.width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Date',
                  style: TextStyle(fontSize: screenSize.height * 0.05),
                ),
                Text(
                  'Select the date that you want to query',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                TextField(
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintText: 'Day',
                    labelText: 'Day',
                  ),
                ),
                TextField(
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintText: 'Month',
                    labelText: 'Month',
                  ),
                ),
                TextField(
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintText: 'Year',
                    labelText: 'Year',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
