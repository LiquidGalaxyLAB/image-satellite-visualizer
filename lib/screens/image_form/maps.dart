import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  final callback;
  const Maps({required this.callback, Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor pinLocationIcon;

  static final CameraPosition _initial = CameraPosition(
    target: LatLng(-23.36, -46.84),
    zoom: 1.0,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  int _markerIdCounter = 1;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/marker.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initial,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(markers.values),
            polygons: Set<Polygon>.of(polygons.values),
            onLongPress: (LatLng position) => _addMarker(position),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FloatingActionButton(
                backgroundColor: Colors.grey[100],
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  markers.entries.length == 2
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
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(Colors.grey[100]),
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
}
