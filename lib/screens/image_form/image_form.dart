import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';
import 'package:image_satellite_visualizer/models/image_request.dart';
import 'package:image_satellite_visualizer/models/resolution.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/api_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/data_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/final_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/layer_step.dart';
import 'package:geodesy/geodesy.dart' as geodesy;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'dart:math';
import 'dart:io';

class ImageForm extends StatefulWidget {
  const ImageForm({Key? key}) : super(key: key);

  @override
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  RegExp regex = RegExp("&URL=(.*)");
  Box? imageBox;
  final geodesy.Geodesy geodesyLib = geodesy.Geodesy();

  int _currentStep = 0;

  String selectedApi = "Nasa";
  Map<String, TextEditingController> coordinates = {
    "lat1Controller": TextEditingController(),
    "lon1Controller": TextEditingController(),
    "lat2Controller": TextEditingController(),
    "lon2Controller": TextEditingController(),
  };
  late double cloudCoverage;
  DateTime date = DateTime.now();
  String layer = ""; //TODO: Add map for base and ovelay layers
  String layerShortName = "";
  String layerDescription = "";
  List<Map<String, String>> colors = [{}];
  String? imagePath;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Map<String, String> coordinatesMap = {};
  Resolution resolution = Resolution.km1;

  void createRequest() async {
    var minLat = min(double.parse(coordinates['lat1Controller']!.text),
        double.parse(coordinates['lat2Controller']!.text));
    var maxLat = max(double.parse(coordinates['lat1Controller']!.text),
        double.parse(coordinates['lat2Controller']!.text));
    var minLon = min(double.parse(coordinates['lon1Controller']!.text),
        double.parse(coordinates['lon2Controller']!.text));
    var maxLon = max(double.parse(coordinates['lon1Controller']!.text),
        double.parse(coordinates['lon2Controller']!.text));

    Map<String, double> bbox = {
      'lat1': minLat,
      'lat2': maxLat,
      'lon1': minLon,
      'lon2': maxLon,
    };

    ImageRequest request = new ImageRequest(
      layers: [layer],
      time: '2020-03-30',
      bbox: bbox,
      resolution: resolution,
      cloudCoverage: cloudCoverage,
    );

    String url;
    if (selectedApi == "Nasa") {
      url = request.getNasaRequestUrl();
      print(request.getNasaRequestUrl());
    } else if (selectedApi == "SentinelHub") {
      url = request.getSentinelHubRequestUrl();
      print(request.getSentinelHubRequestUrl());
    } else {
      var match = regex.firstMatch(request.getCopernicusRequestUrl())?.group(1);
      url = match!;
      print(match);
    }

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      File file = new File(path.join(documentDirectory.path,
          '${DateTime.now().millisecondsSinceEpoch}.jpeg'));
      file.writeAsBytesSync(response.bodyBytes);
      setState(() {
        imagePath = file.path;
        coordinatesMap = {
          'minLat': minLat.toString(),
          'minLon': minLon.toString(),
          'maxLat': maxLat.toString(),
          'maxLon': maxLon.toString(),
        };
      });
    } else {
      setState(() {
        _currentStep--;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Error fetching image'),
            );
          });
    }
  }

  void createImage() {
    var imageData = ImageData(
      imagePath: imagePath!,
      title: nameController.text,
      description: descriptionController.text,
      coordinates: coordinatesMap,
      api: selectedApi,
      date: date,
      layer: layerShortName,
      layerDescription: layerDescription,
      colors: colors,
      demo: false,
    );
    print('result: ' + imageData.toString());
    imageBox?.add(imageData);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    imageBox = Hive.box('imageBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('New Image'),
        leading: BackButton(color: Colors.white),
      ),
      body: Theme(
        data: ThemeData(
          colorScheme:
              ColorScheme.light(primary: Theme.of(context).accentColor),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          physics: ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          onStepContinue: continued,
          onStepCancel: cancel,
          steps: <Step>[
            Step(
              title: new Text('API'),
              content: ApiStep(selectedApi, setApi),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: new Text('Location and date'),
              content: DataStep(
                textControllers: coordinates,
                date: date,
                resolution: resolution,
                coordinateCallback: setCoordinates,
                resolutionCallback: setResolution,
                cloudCoverageCallback: setCloudCoverage,
                dateCallback: setDate,
              ),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: new Text('Layers'),
              content: FilterStep(layer, setLayer, selectedApi),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: new Text('Final'),
              content:
                  FinalStep(nameController, descriptionController, imagePath),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 3 ? StepState.complete : StepState.disabled,
            ),
          ],
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < 3) {
      if (_currentStep == 0) {
        setState(() => _currentStep += 1);
      } else if (_currentStep == 1) {
        coordinatesCheck()
            ? sizeCheck()
                ? setState(() => _currentStep += 1)
                : showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content:
                            Text('Height/Width must not be greater than 3000'),
                      );
                    })
            : showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('Coordinates are required'),
                  );
                });
      } else if (_currentStep == 2) {
        layer.isNotEmpty
            ? setState(() {
                try {
                  createRequest();
                  _currentStep += 1;
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(e.toString()),
                        );
                      });
                }
              })
            : showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('Layer is required'),
                  );
                });
      }
    } else {
      imagePath != null
          ? infoCheck()
              ? createImage()
              : showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Name/Description is required'),
                    );
                  })
          : showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Await for image'),
                );
              });
    }
  }

  cancel() {
    if (_currentStep > 0) {
      if (_currentStep == 3) imagePath = null;
      setState(() => _currentStep -= 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  void setApi(String api) {
    setState(() {
      selectedApi = api;
    });
  }

  void setCoordinates(Map<MarkerId, Marker> markers) {
    setState(() {
      coordinates['lat1Controller']?.text =
          markers.values.elementAt(0).position.latitude.toString();
      coordinates['lon1Controller']?.text =
          markers.values.elementAt(0).position.longitude.toString();
      coordinates['lat2Controller']?.text =
          markers.values.elementAt(1).position.latitude.toString();
      coordinates['lon2Controller']?.text =
          markers.values.elementAt(1).position.longitude.toString();
    });
  }

  void setResolution(Resolution newResolution) {
    setState(() {
      resolution = newResolution;
    });
  }

  void setDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  void setLayer(
    String incomingLayer,
    String incomingShortName,
    String incomingLayerDescription,
    List<Map<String, String>> incomingColors,
  ) {
    setState(() {
      layer = incomingLayer;
      layerShortName = incomingShortName;
      layerDescription = incomingLayerDescription;
      colors = incomingColors;
    });
  }

  void setCloudCoverage(double incomingCloudCoverage) {
    setState(() {
      cloudCoverage = incomingCloudCoverage;
    });
  }

  Map<String, String> getResolutions() {
    int height = (geodesyLib.distanceBetweenTwoGeoPoints(
              geodesy.LatLng(double.parse(coordinates['lat1Controller']!.text),
                  double.parse(coordinates['lon1Controller']!.text)),
              geodesy.LatLng(double.parse(coordinates['lat2Controller']!.text),
                  double.parse(coordinates['lon1Controller']!.text)),
            ) /
            1000)
        .round();
    int width = (geodesyLib.distanceBetweenTwoGeoPoints(
              geodesy.LatLng(double.parse(coordinates['lat1Controller']!.text),
                  double.parse(coordinates['lon1Controller']!.text)),
              geodesy.LatLng(double.parse(coordinates['lat1Controller']!.text),
                  double.parse(coordinates['lon2Controller']!.text)),
            ) /
            1000)
        .round();
    return {
      'height': height.toString(),
      'width': width.toString(),
    };
  }

  bool sizeCheck() {
    return double.parse(getResolutions()['width']!) < 3000 ||
            double.parse(getResolutions()['height']!) < 3000
        ? true
        : false;
  }

  bool coordinatesCheck() {
    for (var element in coordinates.values) {
      if (element.text.isEmpty) return false;
    }
    return true;
  }

  bool infoCheck() {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty)
      return false;
    return true;
  }
}
