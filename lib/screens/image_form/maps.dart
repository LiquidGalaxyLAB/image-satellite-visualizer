import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart' as geodesy;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_satellite_visualizer/models/resolution.dart';

class Maps extends StatefulWidget {
  final coordiantesCallback;
  final resolutionCallback;
  final cloudCoverageCallback;
  final Resolution resolution;
  const Maps({
    required this.coordiantesCallback,
    required this.resolutionCallback,
    required this.resolution,
    required this.cloudCoverageCallback,
    Key? key,
  }) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final geodesy.Geodesy geodesyLib = geodesy.Geodesy();

  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor pinLocationIcon;

  static final CameraPosition _initial = CameraPosition(
    target: LatLng(-23.36, -46.84),
    zoom: 1.0,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  int _markerIdCounter = 1;

  double cloudCoverage = 0;

  List<bool> isSelected = [false, true];

  late Resolution mapsResolution;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    mapsResolution = widget.resolution;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            initialCameraPosition: _initial,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(markers.values),
            polygons: Set<Polygon>.of(polygons.values),
            onTap: (LatLng position) =>
                isSelected[0] ? _addMarker(position) : null,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.grey[50],
              height: screenSize.height,
              width: screenSize.width * 0.3,
            ),
          ),
          SafeArea(
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 12.5),
              width: screenSize.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Get Locations',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenSize.height * 0.025,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            contentPadding: EdgeInsets.all(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: mapsResolution.toString(),
                              isDense: true,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text("250m"),
                                  value: Resolution.m250.toString(),
                                ),
                                DropdownMenuItem(
                                  child: Text("500m"),
                                  value: Resolution.m500.toString(),
                                ),
                                DropdownMenuItem(
                                  child: Text("1km"),
                                  value: Resolution.km1.toString(),
                                ),
                                DropdownMenuItem(
                                  child: Text("5km"),
                                  value: Resolution.km5.toString(),
                                ),
                                DropdownMenuItem(
                                  child: Text("10km"),
                                  value: Resolution.km10.toString(),
                                ),
                              ],
                              onChanged: (newValue) {
                                Resolution newResolution = Resolution.km1;
                                switch (newValue) {
                                  case "Resolution.m250":
                                    newResolution = Resolution.m250;
                                    break;
                                  case "Resolution.m500":
                                    newResolution = Resolution.m500;
                                    break;
                                  case "Resolution.km1":
                                    newResolution = Resolution.km1;
                                    break;
                                  case "Resolution.km5":
                                    newResolution = Resolution.km5;
                                    break;
                                  case "Resolution.km10":
                                    newResolution = Resolution.km10;
                                    break;
                                }
                                setState(() {
                                  mapsResolution = newResolution;
                                });
                                widget.resolutionCallback(newResolution);
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First pair of coordinates',
                                style: TextStyle(
                                    fontSize: screenSize.height * 0.03),
                              ),
                              markers.entries.length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Latitude    ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                markers.values
                                                    .elementAt(0)
                                                    .position
                                                    .latitude
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Longitude    ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                markers.values
                                                    .elementAt(0)
                                                    .position
                                                    .longitude
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: screenSize.height * 0.01,
                                    ),
                              Text(
                                'Second pair of coordinates',
                                style: TextStyle(
                                    fontSize: screenSize.height * 0.03),
                              ),
                              markers.entries.length > 1
                                  ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Latitude    ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                markers.values
                                                    .elementAt(1)
                                                    .position
                                                    .latitude
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Longitude    ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                markers.values
                                                    .elementAt(1)
                                                    .position
                                                    .longitude
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: screenSize.height * 0.01,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: sizeCheck()
                                ? Colors.grey[300]
                                : Colors.red[300],
                            // color: Colors.grey[300],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expected Size',
                                style: TextStyle(
                                    fontSize: screenSize.height * 0.03),
                              ),
                              markers.entries.length > 1
                                  ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Height    ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(getResolutions()['height']!),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Width    ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(getResolutions()['width']!),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: screenSize.height * 0.01,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: sizeCheck()
                                ? Colors.grey[300]
                                : Colors.red[300],
                            // color: Colors.grey[300],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cloud Coverage: ${this.cloudCoverage.toString()}',
                                style: TextStyle(
                                    fontSize: screenSize.height * 0.03),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Slider(
                                    value: cloudCoverage,
                                    min: 0,
                                    max: 100,
                                    onChanged: (double value) {
                                      setState(() {
                                        cloudCoverage = double.parse(
                                            value.toStringAsFixed(1));
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      sizeCheck()
                          ? Container()
                          : Text(
                              'Height/Width must not be greater than 3000',
                              style: TextStyle(
                                color: Colors.red[700],
                              ),
                            ),
                    ],
                  ),
                  Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      markers.entries.length == 2 && sizeCheck()
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color?>(
                                          Theme.of(context).accentColor),
                                ),
                                child: Text('CONTINUE'),
                                onPressed: () {
                                  this.widget.coordiantesCallback(markers);
                                  this.widget.cloudCoverageCallback(cloudCoverage);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                                Colors.grey[100]),
                          ),
                          child: Text(
                            'RESET',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: _resetMarkers,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                color: Colors.grey[50],
                child: ToggleButtons(
                  children: <Widget>[
                    Icon(Icons.crop_square_outlined),
                    Icon(Icons.map),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          isSelected[buttonIndex] = true;
                        } else {
                          isSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: isSelected,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void myPolygon(double lat1, double lon1, double lat2, double lon2) {
    final PolygonId polygonId = PolygonId('polygon');

    final List<LatLng> polygonCoords = [];
    polygonCoords.add(LatLng(lat1, lon1));
    polygonCoords.add(LatLng(lat1, lon2));
    polygonCoords.add(LatLng(lat2, lon2));
    polygonCoords.add(LatLng(lat2, lon1));

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      points: polygonCoords,
      strokeColor: Color.fromARGB(50, 255, 0, 0),
      fillColor: Color.fromARGB(50, 255, 0, 0),
    );

    setState(() {
      polygons[polygonId] = polygon;
    });
  }

  void _addMarker(LatLng position) async {
    final int markerCount = markers.length;

    if (markerCount == 2) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      icon: pinLocationIcon,
      markerId: markerId,
      position: position,
      rotation: 0,
    );
    setState(() {
      markers[markerId] = marker;
      if (markerCount == 1)
        myPolygon(
          markers.values.elementAt(0).position.latitude,
          markers.values.elementAt(0).position.longitude,
          markers.values.elementAt(1).position.latitude,
          markers.values.elementAt(1).position.longitude,
        );
    });
  }

  void _resetMarkers() {
    setState(() {
      markers = <MarkerId, Marker>{};
      polygons = <PolygonId, Polygon>{};
    });
  }

  Map<String, String> getResolutions() {
    double height = (geodesyLib.distanceBetweenTwoGeoPoints(
          geodesy.LatLng(markers.values.elementAt(0).position.latitude,
              markers.values.elementAt(0).position.longitude),
          geodesy.LatLng(markers.values.elementAt(1).position.latitude,
              markers.values.elementAt(0).position.longitude),
        ) /
        1000);
    double width = (geodesyLib.distanceBetweenTwoGeoPoints(
          geodesy.LatLng(markers.values.elementAt(0).position.latitude,
              markers.values.elementAt(0).position.longitude),
          geodesy.LatLng(markers.values.elementAt(0).position.latitude,
              markers.values.elementAt(1).position.longitude),
        ) /
        1000);

    switch (mapsResolution) {
      case Resolution.m250:
        height *= 4;
        width *= 4;
        break;
      case Resolution.m500:
        height *= 2;
        width *= 2;
        break;
      case Resolution.km1:
        height *= 1;
        width *= 1;
        break;
      case Resolution.km5:
        height *= 0.2;
        width *= 0.2;
        break;
      case Resolution.km10:
        height *= 0.1;
        width *= 0.1;
        break;
    }

    return {
      'height': height.round().toString(),
      'width': width.round().toString(),
    };
  }

  bool sizeCheck() {
    if (markers != {} && markers.values.length > 1) {
      return double.parse(getResolutions()['width']!) < 3000 ||
              double.parse(getResolutions()['height']!) < 3000
          ? true
          : false;
    } else {
      return true;
    }
  }
}
