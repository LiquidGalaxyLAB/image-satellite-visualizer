import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_satellite_visualizer/models/resolution.dart';
import 'package:image_satellite_visualizer/screens/image_form/maps.dart';

class DataStep extends StatelessWidget {
  final coordinateCallback;
  final resolutionCallback;
  final cloudCoverageCallback;
  final dateCallback;
  final Map<String, TextEditingController> textControllers;
  final DateTime date;
  final Resolution resolution;

  const DataStep({
    required this.textControllers,
    required this.date,
    required this.coordinateCallback,
    required this.dateCallback,
    required this.resolutionCallback,
    required this.resolution,
    required this.cloudCoverageCallback,
    Key? key,
  }) : super(key: key);

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
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: screenSize.height * 0.025,
                  ),
                ),
                Text(
                  'First pair of coordinates',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: textControllers['lat1Controller'],
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
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: textControllers['lon1Controller'],
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
                      ),
                    ),
                  ],
                ),
                Text(
                  'Second pair of coordinates',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: textControllers['lat2Controller'],
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
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: textControllers['lon2Controller'],
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
                      ),
                    ),
                  ],
                ),
                Center(
                  child: OutlinedButton(
                    child: Text('GET LOCATIONS'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Maps(
                          coordiantesCallback: this.setLocation,
                          resolutionCallback: this.setResolution,
                          cloudCoverageCallback: this.setCloudCoverage,
                          resolution: resolution,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: screenSize.height * 0.45,
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
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: screenSize.height * 0.025,
                  ),
                ),
                Spacer(),
                Center(
                  child: Text(
                    '${date.year}/${date.month}/${date.day}',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.03,
                    ),
                  ),
                ),
                Spacer(),
                Center(
                  child: OutlinedButton(
                    child: Text('GET DATE'),
                    onPressed: () async => await _selectDate(context),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setLocation(Map<MarkerId, Marker> markers) {
    coordinateCallback(markers);
  }

  void setResolution(Resolution resolution) {
    resolutionCallback(resolution);
  }

  void setCloudCoverage(double cloudCoverage) {
    cloudCoverageCallback(cloudCoverage);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != date) dateCallback(picked);
  }
}
