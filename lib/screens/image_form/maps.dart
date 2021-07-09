import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart' as geodesy;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  final callback;
  const Maps({required this.callback, Key? key}) : super(key: key);

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

  List<bool> isSelected = [false, true];

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/marker.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
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
            onTap: (LatLng position) => isSelected[0] ? _addMarker(position) : null,
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
                                  this.widget.callback(markers);
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
    int height = (geodesyLib.distanceBetweenTwoGeoPoints(
              geodesy.LatLng(markers.values.elementAt(0).position.latitude,
                  markers.values.elementAt(0).position.longitude),
              geodesy.LatLng(markers.values.elementAt(1).position.latitude,
                  markers.values.elementAt(0).position.longitude),
            ) /
            1000)
        .round();
    int width = (geodesyLib.distanceBetweenTwoGeoPoints(
              geodesy.LatLng(markers.values.elementAt(0).position.latitude,
                  markers.values.elementAt(0).position.longitude),
              geodesy.LatLng(markers.values.elementAt(0).position.latitude,
                  markers.values.elementAt(1).position.longitude),
            ) /
            1000)
        .round();
    return {
      'height': height.toString(),
      'width': width.toString(),
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
